--- Create Schema
CREATE SCHEMA Blood_Bank ;

-- Create Tables
CREATE TABLE Donor
(Donor_ID INT NOT NULL,
 Donor_Age INT CHECK(Donor_Age >= 18 AND Donor_Age <= 65),
 Donor_Blood_Type CHAR(3) CHECK(Donor_Blood_Type IN ('-A','+A','+B','-B','-AB','+AB','-O','+O')),
 Donor_Name VARCHAR(45) NOT NULL,
 Donor_File_Number INT NOT NULL UNIQUE,
 Donor_Health_Status VARCHAR(45) CHECK(Donor_Health_Status IN ('medically fit')),
 CONSTRAINT Donor_PK PRIMARY KEY (Donor_ID));
 					
CREATE TABLE Health_Care
(Healthcare_ID INT NOT NULL,
Health_Care_Name VARCHAR(30),
Health_Care_Address VARCHAR(45),
Health_Care_Telephone VARCHAR(10),
CONSTRAINT Health_Care_PK PRIMARY KEY (Healthcare_ID)
);

CREATE TABLE Employee
(Employee_ID INT NOT NULL,
Employee_Name VARCHAR(30),
Employee_Address VARCHAR(45),
Employee_Department VARCHAR(10),
CONSTRAINT Employee_PK PRIMARY KEY (Employee_ID)
);

CREATE TABLE Donation 
(Donor_ID INT NOT NULL,
Blood_ID INT NOT NULL,
Donation_Date date,
CONSTRAINT Donation_PK PRIMARY KEY (Donor_ID ,Blood_ID) ,
CONSTRAINT Donation_FK FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX(Blood_ID)
);

CREATE TABLE Blood
(Blood_ID INT NOT NULL,
 Blood_Test VARCHAR(45), CHECK(Blood_Test IN ('negative','positive','inconclusive')),
 CONSTRAINT Blood PRIMARY KEY (Blood_ID),
 CONSTRAINT Blood_FK FOREIGN KEY (Blood_ID) REFERENCES Donation(Blood_ID) ON DELETE CASCADE ON UPDATE CASCADE
 );

CREATE TABLE ComponentQuantity
(Component_Name VARCHAR(20) NOT NULL CHECK (Component_Name IN ('Red Blood Cells','Platelets','Plasma')),
Stock_Blood_Type VARCHAR(3) NOT NULL CHECK(Stock_Blood_Type IN ('-A','+A','+B','-B','-AB','+AB','-O','+O')),
Component_amount INT,
CONSTRAINT ComponentQuantity_PK PRIMARY KEY (Component_Name,Stock_Blood_Type)
);

CREATE TABLE Stock
(Component_Stock_ID INT NOT NULL,
 Stock_Blood_Type VARCHAR(3) CHECK(Stock_Blood_Type IN ('-A','+A','+B','-B','-AB','+AB','-O','+O')),
 Component_Name VARCHAR(20) NOT NULL CHECK (Component_Name IN ('Red Blood Cells','Platelets','Plasma')),
 CONSTRAINT Stock_PK PRIMARY KEY (Component_Stock_ID),
 CONSTRAINT Stock_FK FOREIGN KEY(Component_Name,Stock_Blood_Type) REFERENCES ComponentQuantity(Component_Name,Stock_Blood_Type) ON DELETE CASCADE 
 );
 

CREATE TABLE componentt
(Donor_ID INT NOT NULL,
Blood_ID INT NOT NULL ,
Component_Stock_ID INT NOT NULL,
CONSTRAINT componentt_PK PRIMARY KEY (Donor_ID ,Blood_ID,Component_Stock_ID),
CONSTRAINT componentt_FK1 FOREIGN KEY (Blood_ID) REFERENCES Donation(Blood_ID) ON DELETE CASCADE ON UPDATE CASCADE ,
CONSTRAINT componentt_FK2 FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE ON UPDATE CASCADE ,
CONSTRAINT componentt_FK3 FOREIGN KEY (Component_Stock_ID) REFERENCES Stock(Component_Stock_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Blood_Request
(Healthcare_ID INT NOT NULL,
Request_Number INT NOT NULL,
CONSTRAINT Blood_Request_PK PRIMARY KEY (Healthcare_ID ,Request_Number),
CONSTRAINT Blood_Request_FK FOREIGN KEY (Healthcare_ID) REFERENCES Health_Care(Healthcare_ID) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX(Request_Number)
);

CREATE TABLE Requests 
( Request_Number INT NOT NULL,
  Request_state  VARCHAR(30) CHECK (Request_state IN ('Completed','Partially Completed','On Hold','Canceled')),
  CONSTRAINT Requests_PK PRIMARY KEY (Request_state ,Request_Number),
  CONSTRAINT Requests_FK FOREIGN KEY (Request_Number) REFERENCES Blood_Request(Request_Number) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE serve 
(Donor_ID INT NOT NULL,
Employee_ID INT NOT NULL,
CONSTRAINT serve_PK PRIMARY KEY (Donor_ID ,Employee_ID),
CONSTRAINT serve_FK2 FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE ON UPDATE CASCADE ,
CONSTRAINT serve_FK1 FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Donor_Telephone
(Donor_ID INT NOT NULL,
Donor_Telephone INT NOT NULL,
CONSTRAINT donor_Telephone_PK PRIMARY KEY (Donor_ID ,Donor_Telephone),
CONSTRAINT donor_Telephone_FK FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Request_Details
(Healthcare_ID INT NOT NULL,
Request_Number INT NOT NULL,
Blood_Component VARCHAR(45) NOT NULL CHECK (Blood_Component IN ('Red Blood Cells','Platelets','Plasma')),
Blood_Bag_No INT NOT NULL,
Blood_type VARCHAR(3) NOT NULL CHECK(Blood_Type IN ('-A','+A','+B','-B','-AB','+AB','-O','+O')),

CONSTRAINT Request_Details_PK PRIMARY KEY (Healthcare_ID ,Request_Number, Blood_Component, Blood_Bag_No, Blood_Type ),
CONSTRAINT Request_Details_FK FOREIGN KEY (Healthcare_ID ,Request_Number) REFERENCES Blood_Request (Healthcare_ID ,Request_Number)
 ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Manage
(Request_Number INT NOT NULL,
Employee_ID INT NOT NULL,
Component_Stock_ID INT NOT NULL,
CONSTRAINT Manage_PK PRIMARY KEY(Request_Number, Employee_ID, Component_Stock_ID),
CONSTRAINT Manage_FK1 FOREIGN KEY(Request_Number) REFERENCES Blood_Request (Request_Number) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT Manage_FK2 FOREIGN KEY(Employee_ID) REFERENCES Employee (Employee_ID) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT Manage_FK3 FOREIGN KEY(Component_Stock_ID) REFERENCES Stock (Component_Stock_ID)ON DELETE CASCADE ON UPDATE CASCADE
);


  -- Insert data into Tables
 INSERT INTO Donor
 VALUES (1,30,'+A','Ahmed Mansor',1000,'medically fit');
 INSERT INTO Donor
 VALUES (2,19,'+O','Khaled Radwan',1001,'medically fit');
 INSERT INTO Donor
 VALUES (3,27,'+O','Mohammed Abdullah',1002,'medically fit');
 INSERT INTO Donor
 VALUES (4,32,'-AB','Omar Hussein',1003,'medically fit');
 INSERT INTO Donor
 VALUES (5,41,'+A','Hamza Saleh ',1004,'medically fit');


INSERT INTO Health_Care
VALUES(201,'Bugshan Hospital','Prince Mohammed Bin Abdulaziz Street, Jeddah','0126691222');
INSERT INTO Health_Care
VALUES(111,'Dr.Bakhsh Hospital','Anas bin Malik-Al-Sharafiya, Jeddah','0126510666');
INSERT INTO Health_Care
VALUES(134,'Dallah Hospital','Fas, An Nakheel, Riyadh','0112995555');
INSERT INTO Health_Care
VALUES(225,'Hera General Hospital','Madinah Road, Makkah','0125203535');
INSERT INTO Health_Care
VALUES(301,'AI-Rahma Specialist Hospital','King Abdulaziz Road, Shifa, Abha','0540841114');


INSERT INTO Employee
VALUES (5013911,'Atheer','Batha Quraysh, Makkah','Lab');
INSERT INTO Employee
VALUES (5013912,'Sara','Hajj Street, Makkah','clinic');
INSERT INTO Employee
VALUES (5013913,'lubaba','Al-Nuzha , Makkah','clinic');
INSERT INTO Employee
VALUES  (5013914,'lama','Al Shawqia, Makkah','service');
INSERT INTO Employee
VALUES  (5013915,'Manar','Azizia, Makkah','Mng');


-- one of the conditions for donation is the Donor cannot donate again until 3 months have passed since his last donation so, we create trigger for this condition.
delimiter $$ 
create trigger dt_chk before insert on Donation
for each row
begin
  if exists(select Donor_ID from Donation where Donor_ID = new.Donor_ID ) then
    if datediff(new.Donation_Date, (select Donation_Date from Donation where Donor_ID = new.Donor_ID order by Donation_Date DESC limit 1)) <90 then
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Donor must complete 3 months after the last donation';
    end if;
  end if;
end $$

INSERT INTO Donation
VALUES (1,601411,'20-01-08'); 
INSERT INTO Donation
VALUES  (2,601412,'20-04-19'); 
INSERT INTO Donation
VALUES  (3,601413,'20-09-29'); 
INSERT INTO Donation
VALUES (4,601414,'20-10-01'); 
INSERT INTO Donation
VALUES  (5,601415,'20-11-18'); 
INSERT INTO Donation
VALUES  (2,601416,'20-11-19');

INSERT INTO Blood
VALUES (601411,'negative');
INSERT INTO Blood
VALUES  (601412,'negative');
INSERT INTO Blood
VALUES  (601413,'negative');
INSERT INTO Blood
VALUES  (601414,'positive');
INSERT INTO Blood
VALUES  (601415,'negative');
INSERT INTO Blood
VALUES  (601416,'negative');

-- to avoid storing unvalid blood accidently, we must get rid of it
DELETE FROM blood
WHERE blood_test IN ('positive','inconclusive');

INSERT INTO ComponentQuantity
VALUES
('Red Blood Cells','+A',null),
('Platelets','+A',null),
('Plasma','+A',null),
('Red Blood Cells','+O',null),
('Platelets','+O',null),
('Plasma','+O',null),
('Platelets','-A',null),
('Plasma','-A',null),
('Red Blood Cells','-A',null),
('Platelets','-B',null),
('Plasma','-B',null),
('Red Blood Cells','-B',null),
('Platelets','-AB',null),
('Plasma','-AB',null),
('Red Blood Cells','-AB',null),
('Platelets','-O',null),
('Plasma','-O',null),
('Red Blood Cells','-O',null),
('Platelets','+B',null),
('Plasma','+B',null),
('Red Blood Cells','+B',null),
('Platelets','+AB',null),
('Plasma','+AB',null),
('Red Blood Cells','+AB',null);
 
INSERT INTO Stock
VALUES 
(100,'+A','Red Blood Cells'),
(101,'+A','Platelets'),
(102,'+A','Plasma'),
(103,'+A','Red Blood Cells'),
(104,'+A','Platelets'),
(105,'+A','Plasma'),
(106,'+O','Red Blood Cells'),
(107,'+O','Platelets'),
(108,'+O','Plasma'),
(109,'+O','Red Blood Cells'),
(110,'+O','Platelets'),
(111,'+O','Plasma'),
(112,'+O','Red Blood Cells'),
(113,'+O','Platelets'), 
(114,'+O','Plasma'),
(-1,'-A','Platelets'),
(-2,'-A','Plasma'),
(-3,'-A','Red Blood Cells'),
(-4,'-B','Platelets'),
(-5,'-B','Plasma'),
(-6,'-B','Red Blood Cells'),
(-7,'-AB','Platelets'),
(-8,'-AB','Plasma'),
(-9,'-AB','Red Blood Cells'),
(-10,'-O','Platelets'),
(-11,'-O','Plasma'),
(-12,'-O','Red Blood Cells'),
(-13,'+A','Red Blood Cells'),
(-14,'+A','Platelets'),
(-15,'+A','Plasma'),
(-16,'+B','Platelets'),
(-17,'+B','Plasma'),
(-18,'+B','Red Blood Cells'),
(-19,'+AB','Platelets'),
(-20,'+AB','Plasma'),
(-21,'+AB','Red Blood Cells'),
(-22,'+O','Red Blood Cells'),
(-23,'+O','Platelets'),
(-24,'+O','Plasma');

-- count the number of blood bags for each component and update them in ComponentQuantity table in the Component_amount coulmn
UPDATE ComponentQuantity c
SET Component_amount =(SELECT COUNT(Component_Name) AS Component_amount
                      FROM stock WHERE Component_Stock_ID >=0
                      GROUP BY Component_Name,stock_blood_type
                      HAVING c.Component_Name=Component_Name AND  c.Stock_Blood_Type=Stock_Blood_Type );
                      
 -- Make each component Stored in negative ID with amount equal to zero                        
UPDATE componentquantity 
SET Component_amount = 0
WHERE  Component_amount IS NULL ;

INSERT INTO componentt
VALUES
(1,601411,100),
(1,601411,101),
(1,601411,102),
(5,601415,103),
(5,601415,104),
(5,601415,105),
(2,601412,106),
(2,601412,107),
(2,601412,108),
(3,601413,109),
(3,601413,110),
(3,601413,111),
(2,601416,112),
(2,601416,113),
(2,601416,114);

INSERT INTO Blood_Request
VALUES
(201,10),
(111,11),
(134,12),
(225,13),
(301,14);


INSERT INTO serve 
VALUES
(1, 5013911),
(1, 5013912),
(2, 5013911),
(3, 5013913),
(4, 5013914),
(5, 5013915),
(2, 5013915);

INSERT INTO Donor_Telephone
VALUES
(1, 0506576680),
(2, 0552302765),
(3, 0556251323),
(4, 0505524321),
(5, 0555539754);

INSERT INTO Request_Details
VALUES
(201, 10, 'Plasma',2, '+A'),
(111, 11, 'Plasma', 4,'+O'),
(134, 12,'Platelets', 1 , '-A'),
(225, 13, 'Red Blood Cells',9, '+AB'),
(301, 14, 'Platelets', 6, '-O');

INSERT INTO Requests
VALUES
(10,'On Hold'),
(11, 'On Hold'),
(12, 'On Hold'),
(13,'On Hold'),
(14,'On Hold');

INSERT INTO Manage
VALUES
(10, 5013914, 102),
(10, 5013914, 105),
(11, 5013911, 108),
(11, 5013911, 111),
(11, 5013911, -24),
(12, 5013915, -1),
(13, 5013913, -21),
(14, 5013912, -10); 

-- SQL quries using SELECT command

-- stock tables with different stock_Expiration_date computation (depending on the component shelf life)
-- plasma expired after a year
SELECT  s.component_stock_ID, Component_Name, Stock_Blood_Type, DATE_ADD(Donation_Date, INTERVAL 12 MONTH ) AS plasma_Expiration_Date
FROM  Donation d, stock s, componentt c
WHERE d.Blood_ID=c.Blood_ID AND c.component_stock_ID=s.component_stock_ID AND 
component_name = 'plasma' 
ORDER BY d.Donation_Date ASC;

-- Platelets expired after 5 days
SELECT  s.component_stock_ID, Component_Name, Stock_Blood_Type, DATE_ADD(Donation_Date, INTERVAL 5 DAY ) AS Platelets_Expiration_Date
FROM  Donation d, stock s, componentt c
WHERE d.Blood_ID=c.Blood_ID AND c.component_stock_ID=s.component_stock_ID AND 
component_name = 'Platelets'  
ORDER BY d.Donation_Date ASC;
 
-- Red Blood Cells expired after 42 day (depending on the type of anticoagulant used)
SELECT  s.component_stock_ID, Component_Name, Stock_Blood_Type, DATE_ADD(Donation_Date, INTERVAL 42 DAY ) AS RBC_Expiration_Date
FROM  Donation d, stock s, componentt c
WHERE d.Blood_ID=c.Blood_ID AND c.component_stock_ID=s.component_stock_ID AND component_name = 'Red Blood Cells' 
ORDER BY d.Donation_Date ASC;

-- Display the Donor_ID and Donation_Date for donors who have received a negative blood test arranged according to the Donation_Date 
SELECT Donor_ID , Donation_Date
FROM Donation d
WHERE Blood_ID in (SELECT Blood_ID
                 FROM Blood
                 WHERE Blood_Test='negative')
ORDER BY d.Donation_Date DESC;

-- Display Doner_Name, Doner_Age and Doner_Blood_Type for donors between the ages of 19 and 29, arranged by Donor name
SELECT  Donor_Name ,Donor_Age, Donor_Blood_Type
FROM Donor
WHERE Donor_Age>= 19 AND Donor_Age<=29
ORDER BY Donor_Name;

--  we must get rid of out-of-date components from stock.
-- get rid of out-of-date Platelets from stock.(CURDATE:2020-11-21)
DELETE FROM stock 
WHERE component_stock_ID IN( SELECT sto FROM ( SELECT s2.component_stock_ID AS sto
	                        FROM stock AS s2 
						    WHERE component_stock_ID=s2.component_stock_ID AND component_name = 'Platelets' AND component_stock_ID IN (SELECT component_stock_ID
								                         FROM componentt WHERE Blood_ID IN (SELECT Blood_ID 
								                                                            FROM Donation
																	                         WHERE DATEDIFF(DATE_ADD(Donation_Date, INTERVAL 5 DAY ),CURDATE())<0))) AS temp);
  
-- get rid of out-of-date Red Blood Cells from stock.(CURDATE:2020-11-21)
DELETE FROM stock 
WHERE component_stock_ID IN( SELECT sto FROM ( SELECT s2.component_stock_ID AS sto
	                        FROM stock AS s2 
						    WHERE component_stock_ID=s2.component_stock_ID AND component_name = 'Red Blood Cells' AND component_stock_ID IN (SELECT component_stock_ID
								                         FROM componentt WHERE Blood_ID IN (SELECT Blood_ID 
								                                                            FROM Donation
																	                         WHERE DATEDIFF(DATE_ADD(Donation_Date, INTERVAL 42 DAY ),CURDATE())<0))) AS temp);
-- get rid of out-of-date plasma from stock.(CURDATE:2020-11-21)
DELETE FROM stock 
WHERE component_stock_ID IN( SELECT sto FROM ( SELECT s2.component_stock_ID AS sto
	                        FROM stock AS s2 
						    WHERE component_stock_ID=s2.component_stock_ID AND component_name = 'plasma' AND component_stock_ID IN (SELECT component_stock_ID
								                         FROM componentt WHERE Blood_ID IN (SELECT Blood_ID 
								                                                            FROM Donation
																							WHERE DATEDIFF(DATE_ADD(Donation_Date, INTERVAL 12 MONTH ),CURDATE())<0))) AS temp);                                                                                        

-- Now show the available components and their information in stock
SELECT *
FROM stock WHERE component_stock_ID>=0;

                                                                                             
 -- Show personal info for donors
SELECT Donor_Name,Donor_Age,Donor_Telephone
FROM donor d , donor_telephone t
WHERE d.Donor_ID = t.Donor_ID
ORDER BY Donor_Age;

-- The request will be automatically updated into completed if blood_bag_no are available in stock 
UPDATE requests
SET  Request_state = 'completed'
WHERE Request_number IN (SELECT m.request_number
						FROM request_details d, manage m
                        WHERE d.request_number = m.request_number AND component_stock_ID>=0 
                        GROUP BY d.request_number , blood_bag_no
						HAVING  blood_bag_No = count(component_stock_ID)
                        );  
-- The requests will be automatically updated to Partially Completed if the request is partially available in stock          
UPDATE requests
SET  Request_state = 'partially completed'
WHERE Request_number IN (SELECT m.request_number
						FROM request_details d, manage m
                        WHERE d.request_number = m.request_number AND component_stock_ID>=0 
                        GROUP BY d.request_number , blood_bag_no
						HAVING  blood_bag_No > count(component_stock_ID) >0
                        );  

-- health care with request number 13 has canceled its request
UPDATE requests
SET  Request_state = 'Canceled'
WHERE Request_number = 13 ;		

-- List all details of the requests which is in progress 
SELECT *
FROM request_details
WHERE Request_Number IN (SELECT Request_Number
						 FROM requests
                         WHERE Request_state = 'On Hold');
 
																											
-- display all incomplete requests                    
SELECT  *
FROM  Requests
WHERE Request_state !='completed';


-- delete the requests canceled from Request_Details table
DELETE FROM Request_Details
WHERE Request_Number IN (SELECT Request_Number
FROM Requests
WHERE Request_state='Canceled');


-- display all total number of completed Requests
SELECT  COUNT(Request_Number) AS count_completed 
FROM  Requests
WHERE Request_state ='completed';

-- list of the names of Health Care whose requests not completed
SELECT  Health_Care_Name
FROM Health_Care  
where Healthcare_ID  in  (SELECT   Healthcare_ID 
FROM  Blood_Request 
where Request_Number in (SELECT   Request_Number
FROM  Requests
WHERE Request_state !='completed') )
ORDER BY Health_Care_Name ;