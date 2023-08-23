create database SysmexHospitalFinal;
use SysmexHospitalFinal;

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
	birthdate DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Referral (
    refID INT PRIMARY KEY NOT NULL,
    refDate DATE NOT NULL,
    healthTarget VARCHAR(3),
    daysFromRef INT,
    patAgeAtRef INT,
    patientID INT NOT NULL,
    refereeID INT NOT NULL,
    surgeonID INT NOT NULL,
    FOREIGN KEY (patientID) REFERENCES Patient (patientID),
    FOREIGN KEY (refereeID) REFERENCES Referee (refereeID),
    FOREIGN KEY (surgeonID) REFERENCES Surgeon (surgeonID)
);

CREATE TABLE IF NOT EXISTS Waitlist (
	waitlistID INT PRIMARY KEY NOT NULL,
	waitlistDate DATE NOT NULL,
	fsaDate DATE NULL,
	refID INT NOT NULL,
	FOREIGN KEY (refID) REFERENCES referral (refID)
);

-- Update daysFromRef and patAgeAtRef in the Referral table
UPDATE Referral
SET
    daysFromRef = DATEDIFF(COALESCE(
        (SELECT fsaDate FROM Waitlist WHERE refID = Referral.refID),
        CURDATE()
    ), refDate),
    patAgeAtRef = (
        SELECT YEAR(refDate) - YEAR(p.birthdate)
        FROM Patient p
        WHERE p.patientID = Referral.patientID
    )
WHERE
    daysFromRef IS NULL OR patAgeAtRef IS NULL;

Delete FROM referral where refID = 389;
Delete FROM waitlist where waitlistID = 389;

select * from waitlist;
select * from referral;

drop table waitlist;
drop table referral;

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
(waitlistID, @waitlistDate, @fsaDate, refID) -- Use @waitlistDate and @fsaDate to hold the values temporarily
SET waitlistDate = IF(@waitlistDate = '', '1970-01-01', @waitlistDate),
    fsaDate = NULLIF(@fsaDate, ''); -- Set fsaDate to NULL if @fsaDate is an empty string



