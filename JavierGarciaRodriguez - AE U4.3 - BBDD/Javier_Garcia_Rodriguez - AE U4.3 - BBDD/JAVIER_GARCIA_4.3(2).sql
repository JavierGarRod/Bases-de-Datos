-- CREATE TABLES

CREATE TABLE Alumno(
	CodAlum number(16) PRIMARY KEY,
	DNI varchar2(9),
	Nombre varchar2(64),
	PrimerAp varchar2(32),
	SegundoAp varchar2(32)
);

CREATE TABLE Departamento	(
	CodDep number(16) PRIMARY KEY,
	Nombre varchar2(64),
	Abreviatura varchar2(5)
);

CREATE TABLE CicloFormativo	(
	CodCF number(16) PRIMARY KEY,
	Nombre varchar2(64),
	Abreviatura varchar2(5)
);

CREATE TABLE Docente(
	CodDocente number(16) PRIMARY KEY,
	DNI varchar2(9),
	Nombre varchar2(64),
	PrimerAp varchar2(32),
	SegundoAp varchar2(32),
	CodDep number(16),   
  CONSTRAINT fk_docente_dep FOREIGN KEY (CodDep) REFERENCES Departamento(CodDep) ON DELETE CASCADE
);

CREATE TABLE Asignatura(
CodAsig number(16) PRIMARY KEY,
CodCF number(16) ,
NumHoras number(3),
Nombre varchar2(50) NOT NULL,
Abreviatura varchar2(6),
Curso varchar2(10),
CONSTRAINT fk_asig_ciclo FOREIGN KEY (CodCF) REFERENCES CicloFormativo (CodCF)
);


CREATE TABLE DocAsig(
	CodDocente number(16),
	CodAsig number(16),
	PerAcademico varchar(5),
  CONSTRAINT pk_DocAsig PRIMARY KEY(CodDocente, CodAsig, PerAcademico),
  CONSTRAINT fk_DocAsig_doc FOREIGN KEY (CodDocente) REFERENCES Docente(CodDocente) ON DELETE CASCADE,
  CONSTRAINT fk_DocAsig_asi FOREIGN KEY (CodAsig) REFERENCES Asignatura(CodAsig) ON DELETE CASCADE
);


CREATE TABLE Matricula(
	CodAlumno number (16),
  CodAsig number (16),
  PerAcademico varchar2 (5),
  Nota number (2),
  CONSTRAINT pk_Matricula PRIMARY KEY(CodAlumno, CodAsig, PerAcademico),
  CONSTRAINT fk_CodAlumno_matric FOREIGN KEY (CodAlumno) REFERENCES Alumno(CodAlum) ON DELETE CASCADE,
  CONSTRAINT fk_CodAsig_matric FOREIGN KEY (CodAsig) REFERENCES Asignatura(CodAsig) ON DELETE CASCADE
);

-- INSERTS

-- Creamos las secuencia del CodAlum
CREATE SEQUENCE seqAlumno START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

-- Insertamos valores al Alumno
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'12121212D','Rosa','Blanco','Montero');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'23232323R','Concepción','García','Ramos');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'12121212T','Ángel','Luque','Nieto');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'23232323E','Juan','Muñoz','Sanz');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'12121212V','Jose María','López','Gómez');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'23232323W','Antonio','Domínguez','López');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'12121212X','María','Cea','Ruíz');
INSERT INTO Alumno VALUES (seqAlumno.NEXTVAL,'23232323Y','Elizabeth','Fournie','');

-- Creamos las secuencia del CodDep
CREATE SEQUENCE seqDepartamento START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

-- Insertamos valores al Departamento
INSERT INTO Departamento VALUES (seqDepartamento.NEXTVAL,'Tecnología de la Información y Comunicación','TIC');
INSERT INTO Departamento VALUES (seqDepartamento.NEXTVAL,'Administración y Finanzas','AYF');

-- Creamos las secuencia del CodCF
CREATE SEQUENCE seqCF START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

-- Insertamos valores al CicloFormativo
INSERT INTO CicloFormativo VALUES (seqCF.NEXTVAL,'Desarrollo de Aplicaciones Web','DAW');
INSERT INTO CicloFormativo VALUES (seqCF.NEXTVAL,'Desarrollo de Aplicaciones Multiplataforma','DAM');
INSERT INTO CicloFormativo VALUES (seqCF.NEXTVAL,'Administración de Sistemas Informáticos en Red','ASIR');

-- Creamos las secuencia del CodDocente
CREATE SEQUENCE seqDocente START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Docente VALUES (seqDocente.NEXTVAL,'11111111Y','Javier','Prada','Oliva',1);
INSERT INTO Docente VALUES (seqDocente.NEXTVAL,'222222H','Daniel','Muñiz','Amian',1);
INSERT INTO Docente VALUES (seqDocente.NEXTVAL,'333333K','Soraya','López','',1);
INSERT INTO Docente VALUES (seqDocente.NEXTVAL,'44444444I','María','Pastor','',2);

-- Creamos las secuencia del CodAsig
CREATE SEQUENCE seqAsignatura START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Base de datos', 'BBDD', 165,	'Primero',1);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Lenguajes de Marcas', 'LDM', 120, 'Primero',	1);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Sistemas Informáticos', 'SI','', 'Primero',1);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Entornos de Desarrollo', 'EDD','', 'Primero',1);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Programación', 'PROG', 190, 'Primero', 1);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Formación y Orientación Laboral', 'FOL', 90, 'Primero',1);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Base de datos', 'BBDD', 165, 'Primero',2);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Lenguajes de Marcas', 'LDM', 120, 'Primero',2);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Sistemas Informáticos', 'SI','', 'Primero',2);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'Programación', 'PROG', 190, 'Primero', 2);
INSERT INTO Asignatura(CodAsig, Nombre,Abreviatura, NumHoras, Curso, CodCF) VALUES (seqAsignatura.NEXTVAL,'IPE I', 'FOL', 90, 'Primero', 3);

INSERT INTO DocAsig VALUES (1,1,'21/22');
INSERT INTO DocAsig VALUES (1,2,'21/22');
INSERT INTO DocAsig VALUES (1,7,'21/22');
INSERT INTO DocAsig VALUES (1,8,'21/22');
INSERT INTO DocAsig VALUES (2,3,'21/22');
INSERT INTO DocAsig VALUES (2,4,'21/22');
INSERT INTO DocAsig VALUES (2,9,'21/22');
INSERT INTO DocAsig VALUES (3,5,'21/22');
INSERT INTO DocAsig VALUES (3,10,'21/22');
INSERT INTO DocAsig VALUES (4,6,'21/22');
INSERT INTO DocAsig VALUES (4,11,'21/22');

INSERT INTO Matricula VALUES (1,1,'21/22',4);
INSERT INTO Matricula VALUES (1,2,'21/22',5);
INSERT INTO Matricula VALUES (1,3,'21/22','');
INSERT INTO Matricula VALUES (1,4,'21/22','');
INSERT INTO Matricula VALUES (2,1,'21/22',8);
INSERT INTO Matricula VALUES (2,2,'21/22','');
INSERT INTO Matricula VALUES (2,3,'21/22','');
INSERT INTO Matricula VALUES (3,1,'21/22',5);
INSERT INTO Matricula VALUES (3,2,'21/22',6);
INSERT INTO Matricula VALUES (4,1,'21/22',9);
INSERT INTO Matricula VALUES (4,2,'21/22',3);


-- DROP SEQUENCES

DROP SEQUENCE seqAsignatura;
DROP SEQUENCE seqDocente;
DROP SEQUENCE seqCF;
DROP SEQUENCE seqDepartamento;
DROP SEQUENCE seqAlumno;

-- DROP TABLE

DROP TABLE Matricula CASCADE CONSTRAINTS PURGE;
DROP TABLE DocAsig CASCADE CONSTRAINTS PURGE;
DROP TABLE Asignatura CASCADE CONSTRAINTS PURGE;
DROP TABLE Docente CASCADE CONSTRAINTS PURGE;
DROP TABLE CicloFormativo CASCADE CONSTRAINTS PURGE;
DROP TABLE Departamento CASCADE CONSTRAINTS PURGE;
DROP TABLE Alumno CASCADE CONSTRAINTS PURGE;