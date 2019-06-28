-- Structure:
-- PACIENT (id, last name, first name, birth date)
-- CLINIC (id, adress, city, no_appointments)
-- CABINET (id_clinic, id_cabinet, speciality)
-- APPOINTMENT (id, id_clinic, id_cabinet, id_medic, id_pacient, date, time)
-- MEDIC (id, last name) 
-- Observation: Assume that table PACIENT is dependent on table CLINIC

-- Dummy data (needed only for testing, in lack of the actual database)
CREATE TABLE PACIENT (
  id number(9),
  first_name varchar2(30),
  last_name varchar2(30),
  birth_date date not null,
  CONSTRAINT pk_pacient PRIMARY KEY (id)
);

INSERT INTO PACIENT  (id, first_name, last_name, birth_date)
VALUES (1, 'John', 'Smith', '23-JUN-19');

INSERT INTO PACIENT  (id, first_name, last_name, birth_date)
VALUES (2, 'Old', 'Man', '01-JAN-30');

INSERT INTO PACIENT  (id, first_name, last_name, birth_date)
VALUES (3, 'Jane', 'Smith', '05-FEB-45');

CREATE TABLE CLINIC (
  id number(9),
  a_address varchar2(50),
  city varchar2(30),
  no_appointments number(9),
  CONSTRAINT pk_clinic PRIMARY KEY (id)
);

INSERT INTO CLINIC  (id, a_address, city, no_appointments)
VALUES (1, 'Address1', 'City1', 1);

INSERT INTO CLINIC  (id, a_address, city, no_appointments)
VALUES (2, 'Address2', 'City2', 1);

INSERT INTO CLINIC  (id, a_address, city, no_appointments)
VALUES (3, 'Address3', 'City3', 1);

CREATE TABLE CABINET (
  id_clinic number(9),
  id_cabinet number(9),
  speciality varchar2(50),
  CONSTRAINT pk_cabinet PRIMARY KEY (id_cabinet)
);

INSERT INTO CABINET  (id_clinic, id_cabinet, speciality)
VALUES (1, 1, 'Dermathology');

INSERT INTO CABINET  (id_clinic, id_cabinet, speciality)
VALUES (1, 2, 'Imagistics');

INSERT INTO CABINET  (id_clinic, id_cabinet, speciality)
VALUES (1, 3, 'Psichology');

INSERT INTO CABINET  (id_clinic, id_cabinet, speciality)
VALUES (2, 4, 'Orthopedy');

INSERT INTO CABINET  (id_clinic, id_cabinet, speciality)
VALUES (2, 5, 'Neurology');

CREATE TABLE MEDIC (
  id number(9),
  last_name varchar2(50),
  CONSTRAINT pk_medic PRIMARY KEY (id)
);

INSERT INTO MEDIC  (id, last_name)
VALUES (1, 'Medic1');

INSERT INTO MEDIC  (id, last_name)
VALUES (2, 'Medic2');


--1. Create table APPOINTMENT and its integrity constraints

CREATE TABLE APPOINTMENT (
  id number(9),
  id_clinic number(9),
  id_cabinet number(9),
  id_medic number(9),
  id_pacient number(9),
  a_date date not null,
  a_time timestamp not null,
  CONSTRAINT pk_appointment PRIMARY KEY (id),
  CONSTRAINT clinic_fk FOREIGN KEY (id_clinic) REFERENCES CLINIC(id),
  CONSTRAINT cabinet_fk FOREIGN KEY (id_cabinet) REFERENCES CABINET(id_cabinet),
  CONSTRAINT medic_fk FOREIGN KEY (id_medic) REFERENCES MEDIC(id),
  CONSTRAINT pacient_fk FOREIGN KEY (id_pacient) REFERENCES PACIENT(id)
);

--Dummy data, out of scope for point 1, required for point 2
INSERT INTO APPOINTMENT  (id, id_clinic, id_cabinet, id_medic, id_pacient, a_date, a_time)
VALUES (1, 1, 1, 1, 1, '01-JUN-19', '19.50.00');

INSERT INTO APPOINTMENT  (id, id_clinic, id_cabinet, id_medic, id_pacient, a_date, a_time)
VALUES(2, 1, 2, 2, 2, '02-JUN-19', '20.30.00');

INSERT INTO APPOINTMENT  (id, id_clinic, id_cabinet, id_medic, id_pacient, a_date, a_time)
VALUES (3, 2, 2, 2, 2, '02-MAY-19', '20.30.00');

-- 2.	Update CLINIC.no_appointments such that it contains 
-- the number of appointments from the current month, for each clinic