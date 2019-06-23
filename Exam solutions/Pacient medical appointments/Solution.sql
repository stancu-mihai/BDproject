-- Structure:
-- PACIENT (id, last name, first name, birth date)
-- CLINIC (id, adress, city, no_appointments)
-- CABINET (id_clinic, id_cabinet, speciality)
-- APPOINTMENT (id, id_clinic, id_cabinet, id_medic, id_pacient, date, time)
-- MEDIC (id, last name) 
-- Observation: Assume that table PACIENT is dependent on table CLINIC

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

-- Dependent tables (needed only for testing, in lack of the actual database)
CREATE TABLE PACIENT (
  id number(9),
  first_name varchar2(30),
  last_name varchar2(30),
  birth_date date not null,
  CONSTRAINT pk_pacient PRIMARY KEY (id)
);

CREATE TABLE CLINIC (
  id number(9),
  a_address varchar2(50),
  city varchar2(30),
  no_appointments number(9),
  CONSTRAINT pk_clinic PRIMARY KEY (id)
);

CREATE TABLE CABINET (
  id_clinic number(9),
  id_cabinet number(9),
  speciality varchar2(50),
  CONSTRAINT pk_cabinet PRIMARY KEY (id_cabinet)
);

CREATE TABLE MEDIC (
  id number(9),
  last_name varchar2(50),
  CONSTRAINT pk_medic PRIMARY KEY (id)
);