USE bLYtz_Megaplex

--SOAL
--1
SELECT mv.MovieID, [Total Revenue] = 'IDR ' + CAST(SUM(st.StudioPrice * dmt.QtySeatSold) AS VARCHAR)
FROM Movie mv, Studio st, ScTransaction sc, DetailMvsTransaction dmt
WHERE mv.MovieID = sc.MovieID
AND sc.StudioID = st.StudioID
AND dmt.TransactionID = sc.TransactionID
AND st.StudioPrice > 50000
AND DATEPART(DAY, sc.ShowDate) < 20
GROUP BY mv.MovieID

--2
SELECT ms.StaffName, [Total Sold Seats] = SUM(dmt.QtySeatSold)
FROM MsStaff ms, MvsTransaction mt, DetailMvsTransaction dmt
WHERE ms.StaffID = mt.StaffID
AND mt.MvsTransactionID = dmt.MvsTransactionID
AND ms.StaffGender LIKE 'Male'
AND DATEPART(DAY, mt.MvsTransactionDate) < 28
GROUP BY ms.StaffName
ORDER BY ms.StaffName DESC

--3
SELECT [Average Refreshment Revenue per Day] = 'IDR ' + CAST(AVG(drt.QtyRefreshmentSold * mr.RefreshmentPrice) AS VARCHAR), [Transaction Days] = CAST(COUNT(rt.RsTransactionDate) AS VARCHAR) + ' days', [Female Staff Count] = CAST(COUNT(ms.StaffGender) AS VARCHAR) + ' people'
FROM MsStaff ms
JOIN RsTransaction rt ON ms.StaffID = rt.StaffID
JOIN DetailRsTransaction drt ON drt.RsTransactionID = rt.RsTransactionID
JOIN MsRefreshment mr ON drt.RefreshmentID = mr.RefreshmentID
WHERE StaffGender = 'Female'
AND DATEDIFF(DAY,rt.RsTransactionDate, '2020-02-10') > 0
GROUP BY rt.RsTransactionDate

--4
SELECT [Staff First Name] = 'Mr. ' + SUBSTRING(StaffName,1,(CHARINDEX(' ',StaffName + ' ')-1)), [Total of Refreshment] = COUNT(drt.RefreshmentID), [Total of Quantity Sold] = SUM(drt.QtyRefreshmentSold)
FROM MsStaff ms
JOIN RsTransaction rt ON ms.StaffID = rt.StaffID
JOIN DetailRsTransaction drt ON drt.RsTransactionID = rt.RsTransactionID
JOIN MsRefreshment mr ON drt.RefreshmentID = mr.RefreshmentID
WHERE StaffGender = 'Male'
GROUP BY drt.RsTransactionID,ms.StaffName
UNION 
SELECT [Staff First Name] = 'Ms. ' + SUBSTRING(StaffName,1,(CHARINDEX(' ',StaffName + ' ')-1)), [Total of Refreshment] = COUNT(drt.RefreshmentID), [Total of Quantity Sold] = SUM(drt.QtyRefreshmentSold)
FROM MsStaff ms
JOIN RsTransaction rt ON ms.StaffID = rt.StaffID
JOIN DetailRsTransaction drt ON drt.RsTransactionID = rt.RsTransactionID
JOIN MsRefreshment mr ON drt.RefreshmentID = mr.RefreshmentID
WHERE StaffGender = 'Female'
GROUP BY drt.RsTransactionID,ms.StaffName

--5
SELECT [Refreshment Transaction ID] =  RIGHT(rt.RsTransactionID, 3), [Refreshment Transaction Date] = CONVERT(VARCHAR, rt.RsTransactionDate, 107)
FROM MsRefreshment mr
JOIN DetailRsTransaction drt ON drt.RefreshmentID = mr.RefreshmentID
JOIN RsTransaction rt ON rt.RsTransactionID = drt.RsTransactionID,
(
	SELECT [avgPrice] = AVG(drt.QtyRefreshmentSold * mr.RefreshmentPrice) 
	FROM MsRefreshment mr
	JOIN DetailRsTransaction drt ON drt.RefreshmentID = mr.RefreshmentID
) AS avgTotalPrice
WHERE mr.RefreshmentTypeID IN('RT006', 'RT007', 'RT008', 'RT009', 'RT010')
GROUP BY rt.RsTransactionID, rt.RsTransactionDate, avgTotalPrice.avgPrice
HAVING AVG(drt.QtyRefreshmentSold * mr.RefreshmentPrice) > avgTotalPrice.avgPrice

--6
SELECT [Transaction Date] = DATENAME(WEEKDAY, mt.MvsTransactionDate) + ', ' + CONVERT(VARCHAR, mt.MvsTransactionDate, 106), [Total Movie Revenue] = 'IDR ' + CAST(dmt.QtySeatSold * st.StudioPrice AS VARCHAR) 
FROM MvsTransaction mt
JOIN DetailMvsTransaction dmt ON dmt.MvsTransactionID = mt.MvsTransactionID
JOIN ScTransaction sc ON sc.TransactionID = dmt.TransactionID
JOIN Studio st ON st.StudioID = sc.StudioID,
(
	SELECT [avgMovie] = AVG(dmt.QtySeatSold * st.StudioPrice)
	FROM DetailMvsTransaction dmt
	JOIN ScTransaction sc ON sc.TransactionID = dmt.TransactionID
	JOIN Studio st ON st.StudioID = sc.StudioID
) AS avgMovieRevenue
WHERE DATEDIFF(DAY, mt.MvsTransactionDate, '2020-02-28') > 30
AND (dmt.QtySeatSold * st.StudioPrice) > avgMovieRevenue.avgMovie

--7
SELECT [Staff Last Name] = RIGHT(ms.StaffName, (CHARINDEX(' ', REVERSE(ms.StaffName) + ' ')-1)), rt.RsTransactionID, mr.RefreshmentName, [Price] = 'IDR ' + CAST(mr.RefreshmentPrice AS VARCHAR)
FROM MsStaff ms
JOIN RsTransaction rt ON rt.StaffID = ms.StaffID
JOIN DetailRsTransaction drt ON drt.RsTransactionID = rt.RsTransactionID
JOIN MsRefreshment mr ON mr.RefreshmentID = drt.RefreshmentID,
(
	SELECT [Minimum] = MIN(mr.RefreshmentPrice), [Maximum] = MAX(mr.RefreshmentPrice)
	FROM MsRefreshment mr
) AS MinMax
WHERE (mr.RefreshmentPrice > MinMax.Minimum AND mr.RefreshmentPrice < MinMax.Maximum)

--8
SELECT [Movie Transaction ID] = REPLACE(sc.TransactionID, 'MS', 'S '), st.StudioName, [Studio Price] = 'IDR ' + CAST(st.StudioPrice AS VARCHAR)
FROM ScTransaction sc
JOIN Studio st ON st.StudioID = sc.StudioID
JOIN DetailMvsTransaction dmt ON dmt.TransactionID = sc.TransactionID,
(
	SELECT [AvgSeatsBought] = AVG(dmt.QtySeatSold), [MaxSeatsBought] = MAX(dmt.QtySeatSold)
	FROM DetailMvsTransaction dmt
) AS SeatsBought,
(
	SELECT [AvgStudioPrice] = AVG(st.StudioPrice), [MaxStudioPrice] = MAX(st.StudioPrice)
	FROM Studio st 
) AS PriceStudio
WHERE (dmt.QtySeatSold BETWEEN SeatsBought.AvgSeatsBought AND SeatsBought.MaxSeatsBought)
AND (st.StudioPrice BETWEEN PriceStudio.AvgStudioPrice AND PriceStudio.MaxStudioPrice)

--9
CREATE VIEW [Movie Schedule Viewer]
AS
	SELECT [Studio ID] = REPLACE(st.StudioID, 'ST', 'Studio '), st.StudioName, [Total Play Schedule] = COUNT(sc.MovieID), [Movie Duration Total] = SUM(mv.MovieDuration)
	FROM Studio st
	JOIN ScTransaction sc ON sc.StudioID = st.StudioID
	JOIN Movie mv ON mv.MovieID = sc.MovieID
	WHERE StudioName LIKE 'Satin%' 
	AND mv.MovieDuration > 120
	GROUP BY st.StudioID, st.StudioName

--10
CREATE VIEW [Refreshment Transaction Summary Viewer]
AS
	SELECT [Transaction Count] = CAST(COUNT(drt.RsTransactionID) AS VARCHAR) + ' transactions', [Quantity Sold] = CAST(SUM(drt.QtyRefreshmentSold) AS VARCHAR) + ' products'
	FROM DetailRsTransaction drt
	JOIN RsTransaction rt ON rt.RsTransactionID = drt.RsTransactionID
	WHERE (DATENAME(WEEKDAY, rt.RsTransactionDate) = 'Saturday' OR DATENAME(WEEKDAY, rt.RsTransactionDate) = 'Sunday')
	AND drt.QtyRefreshmentSold > 5
	GROUP BY rt.RsTransactionID