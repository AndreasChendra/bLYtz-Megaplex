USE bLYtz_Megaplex

--Simulate Refreshment Transaction
--1. Insert MsStaff Data
INSERT INTO MsStaff VALUES
('SF002', 'Budi Setiawan', 'setiawan.budi@gmail.com', 'Male', '2001-01-22', '+6281288994582', 'Kemanggisan Street no 29')

--2. Create Transaction in Refreshment Sale Transaction
INSERT INTO RsTransaction VALUES
('RTr005', 'SF002', '2019-12-24')

--3. Create MsRefreshment and MsRefreshmentType to include
INSERT INTO MsRefreshment VALUES
('RE010', 'RT010', 'Ice Blender', 55000, 70)

INSERT INTO MsRefreshmentType VALUES
('RT010', 'Light Snacks')

--4. Create Detail Refreshment Sale Transaction 
INSERT INTO DetailRsTransaction VALUES
('RTr001', 'RE010', 50)

--Simulate Movie Transaction
--1. Insert MsStaff and Movie Data
INSERT INTO MsStaff VALUES
('SF009', 'Andre Saputra', 'andresaputra@gmail.com', 'Male', '2001-05-25', '+6281788997592', 'Syahdan Street no 29')

INSERT INTO Movie VALUES
('MV005', 'IP Man', '2206-1945', 145)

--2. Create Transaction in Movie Sale Transaction
INSERT INTO Studio VALUES
('ST001', 'Creative Space', 55000)

INSERT INTO ScTransaction VALUES
('MS001', 'MV005', 'ST001', '2020-01-19', '19:30:15')

INSERT INTO MvsTransaction VALUES
('MTr015', 'SF009', '2019-12-10')

--3 Create Detail Movie Sale Transaction
INSERT INTO DetailMvsTransaction VALUES
('MTr015', 'MS001', 98)

