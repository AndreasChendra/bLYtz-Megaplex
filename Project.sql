CREATE DATABASE bLYtz_Megaplex

USE bLYtz_Megaplex

CREATE TABLE MsStaff(
	StaffID CHAR(5) PRIMARY KEY CHECK(StaffID LIKE 'SF[0-9][0-9][0-9]'),
	StaffName VARCHAR(50) CHECK(LEN(StaffName) >= 7 AND LEN(StaffName) <= 30),
	StaffEmail VARCHAR(50),
	StaffGender VARCHAR(10) CHECK(StaffGender LIKE 'Male' OR StaffGender LIKE 'Female'),
	StaffDOB DATE CHECK(CAST(DATEDIFF(DAY, StaffDOB,GETDATE()) AS INT)/365 >= 18),
	StaffPhone VARCHAR(15) CHECK(StaffPhone LIKE '+62%'),
	StaffAddress VARCHAR(100)
)

CREATE TABLE Movie(
	MovieID CHAR(5) PRIMARY KEY CHECK(MovieID LIKE 'MV[0-9][0-9][0-9]'),
	MovieName VARCHAR(50),
	MovieLicense VARCHAR(50),
	MovieDuration INT CHECK(MovieDuration <= 240)
)

CREATE TABLE Studio(
	StudioID CHAR(5) PRIMARY KEY CHECK(StudioID LIKE 'ST[0-9][0-9][0-9]'),
	StudioName VARCHAR(50),
	StudioPrice INT CHECK(StudioPrice >= 35000 AND StudioPrice <= 65000)
)

CREATE TABLE ScTransaction(
	TransactionID CHAR(5) PRIMARY KEY CHECK(TransactionID LIKE 'MS[0-9][0-9][0-9]'),
	MovieID CHAR(5) NOT NULL,
	StudioID CHAR(5) NOT NULL,
	ShowDate DATE CHECK(DATEDIFF(DAY, GETDATE(), ShowDate) >= 7),
	ShowTime TIME,
	
	FOREIGN KEY(MovieID) REFERENCES Movie(MovieID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(StudioID) REFERENCES Studio(StudioID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE MsRefreshmentType(
	RefreshmentTypeID CHAR(5) PRIMARY KEY CHECK(RefreshmentTypeID LIKE 'RT[0-9][0-9][0-9]'),
	RefreshmentTypeName VARCHAR(50) 
)

CREATE TABLE MsRefreshment(
	RefreshmentID CHAR(5) PRIMARY KEY CHECK(RefreshmentID LIKE 'RE[0-9][0-9][0-9]'),
	RefreshmentTypeID CHAR(5) NOT NULL,
	RefreshmentName VARCHAR(50),
	RefreshmentPrice INT,
	RefreshmentStock INT CHECK(RefreshmentStock > 50),

	FOREIGN KEY(RefreshmentTypeID) REFERENCES MsRefreshmentType(RefreshmentTypeID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE MvsTransaction(
	MvsTransactionID CHAR(6) PRIMARY KEY CHECK(MvsTransactionID LIKE 'MTr[0-9][0-9][0-9]'),
	StaffID CHAR(5) NOT NULL,
	MvsTransactionDate DATE,

	FOREIGN KEY(StaffID) REFERENCES MsStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE RsTransaction(
	RsTransactionID CHAR(6) PRIMARY KEY CHECK(RsTransactionID LIKE 'RTr[0-9][0-9][0-9]'),
	StaffID CHAR(5) NOT NULL,
	RsTransactionDate DATE,

	FOREIGN KEY(StaffID) REFERENCES MsStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE DetailMvsTransaction(
	MvsTransactionID CHAR(6) NOT NULL,
	TransactionID CHAR(5) NOT NULL,
	QtySeatSold INT,

	FOREIGN KEY(MvsTransactionID) REFERENCES MvsTransaction(MvsTransactionID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(TransactionID) REFERENCES ScTransaction(TransactionID) ON UPDATE CASCADE ON DELETE CASCADE,

	PRIMARY KEY(MvsTransactionID, TransactionID)
)

CREATE TABLE DetailRsTransaction(
	RsTransactionID CHAR(6) NOT NULL,
	RefreshmentID CHAR(5) NOT NULL,
	QtyRefreshmentSold INT,

	FOREIGN KEY(RsTransactionID) REFERENCES RsTransaction(RsTransactionID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(RefreshmentID) REFERENCES MsRefreshment(RefreshmentID) ON UPDATE CASCADE ON DELETE CASCADE,

	PRIMARY KEY(RsTransactionID, RefreshmentID)
)

INSERT INTO MsStaff VALUES
('SF001', 'Andreas Chendra', 'andreas.chendra@gmail.com', 'Male', '2001-01-22', '+6282288994882', 'Kebon Jeruk Street no 12'),
('SF002', 'Ricky Nelson', 'rickynelson614@gmail.com', 'Male', '1997-12-20', '+6281277874312', 'Senayan Street no 100'),
('SF003', 'Ivan Chandra', 'ivancandrag7@gmail.com', 'Male', '2001-02-13', '+6282279854633', 'Syahdan Street No.110'),
('SF004', 'Fransisca Mei', 'fransmeisis@gmail.com', 'Female', '2000-10-25', '+6285234562389', 'Warung Buncit Street no 5'),
('SF005', 'Desy Agustin', 'desyagustin@gmail.com', 'Female', '2000-08-17', '+6289783458912', 'Mampang Prapatan Street no 20'),
('SF006', 'Cynthia', 'cynthiaa@gmail.com', 'Female', '1990-07-23', '+6285469083029', 'Senayan Street no 35'),
('SF007', 'Ricco Wijaya Huang', 'riccowijaya46@gmail.com', 'Male', '2000-09-29', '+6286789582321', 'Kwitang Street no 49'),
('SF008', 'Kevin Kho', 'kevkevkho@gmail.com', 'Male', '1999-05-18', '+6280989987733', 'Menteng Street no 203'),
('SF009', 'Albert Zasura', 'alalbertt@gmail.com', 'Male', '2001-02-05', '+6281134908574', 'Kebayoran Lama Street no 109'),
('SF010', 'Rivaldo', 'rivaldotandra@gmail.com', 'Male', '1990-03-19', '+6285478654321', 'Lebak Bulus Street no 55'),
('SF011', 'Aulia Heynicha Sihombing', 'auliaheynicha@gmail.com', 'Female', '2001-01-12', '+6283498765674', 'Kebagusan Street no 180'),
('SF012', 'Dewi Ratna', 'ratnaiwed@gmail.com', 'Female', '1999-08-23', '+6282398765432', 'Ragunan Street no 34'),
('SF013', 'Silviani', 'anisilvia@gmail.com', 'Female', '2001-01-15', '+6289123847582', 'Cawang Street no 234'),
('SF014', 'Hocky Jeksen', 'jeksenliverpool@gmail.com', 'Male', '2000-07-27', '+6283465127698', 'Daan Mogot Street no 54'),
('SF015', 'Chandra Gunawan Saputra', 'gunawansaputra@gmail.com', 'Male', '2001-05-13', '+6289345781290', 'Veteran Street no 149')

INSERT INTO Movie VALUES
('MV001', 'Jumanji', '2201-1901', 135),
('MV002', 'Knives Out', '2201-1902', 90),
('MV003', 'Parasite', '2201-1903', 126),
('MV004', 'The Irishman', '2201-1904', 220),
('MV005', 'Little Women', '2201-1905', 195),
('MV006', 'Avengers', '2201-1906', 99),
('MV007', 'Frozen', '2201-1907', 105),
('MV008', 'Star Wars', '2201-1908', 178),
('MV009', 'Joker', '2201-1909', 199),
('MV010', 'Pain and Glory', '2201-1910', 87),
('MV011', 'Booksmart', '2201-1911', 143),
('MV012', 'The Souvenir', '2201-1912', 112),
('MV013', 'Atlantics', '2201-1913', 189),
('MV014', 'Captain Marvel', '2201-1914', 212),
('MV015', 'Gemini Man', '2201-1915', 141)

INSERT INTO Studio VALUES
('ST001', 'Creative Space', 55000),
('ST002', 'On Display', 47000),
('ST003', 'Silent Study', 49500),
('ST004', 'Energy of Art', 37500),
('ST005', 'Satin to Start', 45750),
('ST006', 'Making Mastery', 61250),
('ST007', 'Space Race', 65000),
('ST008', 'Work in Wonder', 62000),
('ST009', 'Prostudio', 60000),
('ST010', 'Studiogo', 50000),
('ST011', 'Call for Creativity', 52500),
('ST012', 'Splattered Space', 55300),
('ST013', 'Grow Studio', 46000),
('ST014', 'Mastery Displayed', 48000),
('ST015', 'Mindset Matters', 47500)

INSERT INTO MsRefreshmentType VALUES
('RT001', 'Coffee'),
('RT002', 'Soda'),
('RT003', 'Juice'),
('RT004', 'Tea'),
('RT005', 'Other Beverages'),
('RT006', 'Western Food'),
('RT007', 'Heavy Snacks'),
('RT008', 'Traditional Food'),
('RT009', 'Eastern Food'),
('RT010', 'Light Snacks')

INSERT INTO MsRefreshment VALUES
('RE001', 'RT001', 'Ice Blend', 50000, 65),
('RE002', 'RT002', 'Ice Drink', 45000, 70),
('RE003', 'RT003', 'Milk Shake', 25000, 94),
('RE004', 'RT004', 'Milk Tea', 37500, 55),
('RE005', 'RT005', 'Flavoured Tea', 46000, 98),
('RE006', 'RT006', 'Smoothie', 89000, 79),
('RE007', 'RT007', 'Macchiato', 92500, 67),
('RE008', 'RT008', 'Hot Chocolate', 45200, 88),
('RE009', 'RT009', 'Yogurt', 57800, 99),
('RE010', 'RT010', 'Yakult', 78500, 80)

INSERT INTO RsTransaction VALUES
('RTr001', 'SF001', '2019-01-12'),
('RTr002', 'SF002', '2019-02-12'),
('RTr003', 'SF003', '2019-03-13'),
('RTr004', 'SF004', '2019-04-15'),
('RTr005', 'SF005', '2019-05-19'),
('RTr006', 'SF006', '2019-09-18'),
('RTr007', 'SF007', '2019-08-28'),
('RTr008', 'SF008', '2019-09-25'),
('RTr009', 'SF009', '2019-09-25'),
('RTr010', 'SF010', '2019-10-14'),
('RTr011', 'SF011', '2019-10-29'),
('RTr012', 'SF012', '2019-11-12'),
('RTr013', 'SF013', '2019-11-13'),
('RTr014', 'SF014', '2019-12-19'),
('RTr015', 'SF015', '2019-12-22')

INSERT INTO MvsTransaction VALUES
('MTr001', 'SF001', '2019-01-12'),
('MTr002', 'SF002', '2019-01-25'),
('MTr003', 'SF003', '2019-02-08'),
('MTr004', 'SF004', '2019-02-23'),
('MTr005', 'SF005', '2019-03-10'),
('MTr006', 'SF006', '2019-04-14'),
('MTr007', 'SF007', '2019-04-24'),
('MTr008', 'SF008', '2019-05-16'),
('MTr009', 'SF009', '2019-06-26'),
('MTr010', 'SF010', '2019-07-18'),
('MTr011', 'SF011', '2019-08-28'),
('MTr012', 'SF012', '2019-09-09'),
('MTr013', 'SF013', '2019-10-19'),
('MTr014', 'SF014', '2019-11-29'),
('MTr015', 'SF015', '2019-12-10')

INSERT INTO ScTransaction VALUES
('MS001', 'MV001', 'ST001', '2020-01-19', '19:30:15'),
('MS002', 'MV002', 'ST002', '2020-02-02', '20:25:28'),
('MS003', 'MV003', 'ST003', '2020-02-15', '21:20:53'),
('MS004', 'MV004', 'ST004', '2020-03-02', '22:10:45'),
('MS005', 'MV005', 'ST005', '2020-03-17', '23:15:34'),
('MS006', 'MV006', 'ST006', '2020-04-21', '18:35:24'),
('MS007', 'MV007', 'ST007', '2021-05-01', '19:45:16'),
('MS008', 'MV008', 'ST008', '2021-05-23', '20:55:15'),
('MS009', 'MV009', 'ST009', '2022-07-03', '19:50:13'),
('MS010', 'MV010', 'ST010', '2022-07-25', '21:40:57'),
('MS011', 'MV011', 'ST011', '2023-09-05', '22:15:55'),
('MS012', 'MV012', 'ST012', '2020-09-16', '23:55:34'),
('MS013', 'MV013', 'ST013', '2021-10-26', '22:45:25'),
('MS014', 'MV014', 'ST014', '2022-12-06', '21:40:24'),
('MS015', 'MV015', 'ST015', '2023-12-17', '20:35:50')

INSERT INTO DetailMvsTransaction VALUES
('MTr001', 'MS001', 98),
('MTr002', 'MS002', 60),
('MTr003', 'MS003', 75),
('MTr004', 'MS004', 89),
('MTr005', 'MS005', 100),
('MTr006', 'MS006', 120),
('MTr007', 'MS007', 50),
('MTr008', 'MS008', 57),
('MTr009', 'MS009', 78),
('MTr010', 'MS010', 90),
('MTr011', 'MS011', 95),
('MTr012', 'MS012', 115),
('MTr013', 'MS013', 110),
('MTr014', 'MS014', 79),
('MTr015', 'MS015', 69),
('MTr012', 'MS001', 95),
('MTr011', 'MS003', 115),
('MTr010', 'MS004', 110),
('MTr004', 'MS006', 49),
('MTr006', 'MS015', 59),
('MTr008', 'MS005', 95),
('MTr005', 'MS014', 118),
('MTr009', 'MS011', 114),
('MTr012', 'MS009', 67),
('MTr011', 'MS007', 59)
 
INSERT INTO DetailRsTransaction VALUES
('RTr001', 'RE001', 50),
('RTr001', 'RE003', 33),
('RTr001', 'RE005', 83),
('RTr002', 'RE007', 76),
('RTr002', 'RE002', 65),
('RTr003', 'RE003', 75),
('RTr004', 'RE004', 90),
('RTr004', 'RE002', 42),
('RTr005', 'RE005', 95),
('RTr005', 'RE006', 56),
('RTr006', 'RE004', 67),
('RTr007', 'RE006', 68),
('RTr008', 'RE005', 68),
('RTr009', 'RE009', 98),
('RTr009', 'RE006', 72),
('RTr010', 'RE010', 99),
('RTr010', 'RE008', 79),
('RTr011', 'RE001', 78),
('RTr011', 'RE005', 67),
('RTr012', 'RE002', 82),
('RTr012', 'RE010', 49),
('RTr013', 'RE003', 73),
('RTr013', 'RE008', 68),
('RTr014', 'RE004', 61),
('RTr015', 'RE005', 60)

DROP DATABASE bLYtz_Megaplex

SELECT * FROM MsStaff
SELECT * FROM Movie
SELECT * FROM Studio
SELECT * FROM MsRefreshmentType
SELECT * FROM MsRefreshment
SELECT * FROM MvsTransaction
SELECT * FROM RsTransaction
SELECT * FROM ScTransaction
SELECT * FROM DetailMvsTransaction
SELECT * FROM DetailRsTransaction

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