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
