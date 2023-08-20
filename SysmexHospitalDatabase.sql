create database SysmexHospital;
use SysmexHospital;

CREATE TABLE IF NOT EXISTS Referee (
	refereeID INT PRIMARY KEY NOT NULL,
	firstName VARCHAR(25) NOT NULL,
	lastName VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS Department (
	departmentID INT PRIMARY KEY NOT NULL,
    department varchar(20)
);

CREATE TABLE IF NOT EXISTS Surgeon (
	  surgeonID INT PRIMARY KEY NOT NULL,
	  firstName VARCHAR(25) NOT NULL,
	  lastName VARCHAR(25) NOT NULL,
	  departmentID INT,
	  FOREIGN KEY (departmentID) REFERENCES department (departmentID)
);

CREATE TABLE IF NOT EXISTS Patient (
	patientID INT PRIMARY KEY NOT NULL,
	NHI CHAR(7),
	firstName VARCHAR(25) NOT NULL,
	lastName VARCHAR(25) NOT NULL,
	birthdate DATE NOT NULL,
	patAgeAtRef INT NOT NULL,
	gender VARCHAR(6)
);

CREATE TABLE IF NOT EXISTS Referral (
    refID INT PRIMARY KEY NOT NULL,
    refDate DATE NOT NULL,
    healthTarget VARCHAR(3),
    refFrom VARCHAR(20),
    patientID INT NOT NULL,
    refereeID INT NOT NULL,
    surgeonID INT NOT NULL,
    FOREIGN KEY (patientID) REFERENCES patient (patientID),
    FOREIGN KEY (refereeID) REFERENCES referee (refereeID),
    FOREIGN KEY (surgeonID) REFERENCES surgeon (surgeonID)
);

CREATE TABLE IF NOT EXISTS Waitlist (
	waitlistID INT PRIMARY KEY NOT NULL,
	waitlistDate DATE NOT NULL,
	fsaDate DATE NULL,
	daysWaitingFromRef INT,
	refID INT NOT NULL,
	FOREIGN KEY (refID) REFERENCES referral (refID)
);

LOAD DATA INFILE 'C:/Temp/RefereeData.csv'
INTO TABLE referee
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/Temp/DepartmentData.csv'
INTO TABLE department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/Temp/SurgeonData.csv'
INTO TABLE surgeon
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/Temp/PatientData.csv'
INTO TABLE patient
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/Temp/ReferralData.csv'
INTO TABLE referral
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/Temp/WaitlistData.csv'
INTO TABLE waitlist
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(waitlistID, waitlistDate, @fsaDate, @daysWaitingFromRef, refID) -- Use @daysWaitingFromRef to hold the value temporarily
SET fsaDate = NULLIF(@fsaDate, ''), -- Set fsaDate to NULL if @fsaDate is an empty string
    daysWaitingFromRef = NULLIF(@daysWaitingFromRef, ''); -- Set daysWaitingFromRef to NULL if @daysWaitingFromRef is an empty string

drop table waitlist;
drop table referral;
drop table patient;
drop table surgeon;
drop table department;
drop table referee;
