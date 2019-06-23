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
  adate date not null,
  atime timestamp not null,
  CONSTRAINT pk_ibd PRIMARY KEY (id),
  CONSTRAINT clinic_fk FOREIGN KEY (id_clinic) REFERENCES CLINIC(id),
  CONSTRAINT cabinet_fk FOREIGN KEY (id_cabinet) REFERENCES CABINET(id),
  CONSTRAINT medic_fk FOREIGN KEY (id_medic) REFERENCES MEDIC(id),
  CONSTRAINT pacient_fk FOREIGN KEY (id_pacient) REFERENCES PACIENT(id)
  );