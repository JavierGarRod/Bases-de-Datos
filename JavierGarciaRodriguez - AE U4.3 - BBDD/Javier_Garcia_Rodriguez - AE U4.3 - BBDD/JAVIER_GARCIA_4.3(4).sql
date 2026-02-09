--CREATE TABLE

CREATE TABLE Persona (
    IdPersona NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Ap1 VARCHAR2(64),
    Ap2 VARCHAR2(64),
    Especialidad VARCHAR2(64),
    DNI VARCHAR2(9) UNIQUE NOT NULL,
    TipoPersona VARCHAR2(32),
    IdDepartamento NUMBER(14),
    CONSTRAINT fk_persona_departamento FOREIGN KEY (IdDepartamento) REFERENCES Departamento(IdDepartamento) ON DELETE CASCADE,
    CONSTRAINT ck_tipo_persona CHECK (UPPER(TipoPersona) IN ('LIDERPROYECTO','PROGRAMADOR'))
);

CREATE TABLE Equipo (
    IdEquipo NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    PresupuestoAnual NUMBER(10,2),
    Rol VARCHAR2(64),
    Componente VARCHAR2(64)
);

CREATE TABLE Departamento (
    IdDepartamento NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Direccion VARCHAR2(128),
    Tlf NUMBER(9),
    Mision VARCHAR2(256)
);

CREATE TABLE Sede (
    IdSede NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Direccion VARCHAR2(128),
    Tlf NUMBER(9),
    IdDepartamento NUMBER(14),
    CONSTRAINT fk_sede_departamento FOREIGN KEY (IdDepartamento) REFERENCES Departamento(IdDepartamento) ON DELETE CASCADE
);

CREATE TABLE Software (
    IdSoftware NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Lenguaje VARCHAR2(32),
    Version VARCHAR2(16),
    IdEquipo NUMBER(14),
    CONSTRAINT fk_software_equipo FOREIGN KEY (IdEquipo) REFERENCES Equipo(IdEquipo) ON DELETE CASCADE
);

CREATE TABLE Proyecto (
    IdProyecto NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Descripcion VARCHAR2(256),
    Objetivo VARCHAR2(128),
    Duracion NUMBER(3),
    TipoTarea VARCHAR2(32),
    IdSoftware NUMBER(14),
    CONSTRAINT fk_proyecto_software FOREIGN KEY (IdSoftware) REFERENCES Software(IdSoftware) ON DELETE CASCADE,
    CONSTRAINT ck_tipo_tarea CHECK (UPPER(TipoTarea) IN ('COMPLETADO','A EMPEZAR','EN PROCESO'))
);

CREATE TABLE Proyecto_Equipo (
    Proyecto_Id NUMBER(14),
    Equipo_Id NUMBER(14),
    CONSTRAINT pk_proyecto_equipo PRIMARY KEY (Proyecto_Id, Equipo_Id),
    CONSTRAINT fk_pe_proyecto FOREIGN KEY (Proyecto_Id) REFERENCES Proyecto(IdProyecto) ON DELETE CASCADE,
    CONSTRAINT fk_pe_equipo FOREIGN KEY (Equipo_Id) REFERENCES Equipo(IdEquipo) ON DELETE CASCADE
);

CREATE TABLE Persona_Equipo (
    Persona_Id NUMBER(14),
    Equipo_Id NUMBER(14),
    CONSTRAINT pk_persona_equipo PRIMARY KEY (Persona_Id, Equipo_Id),
    CONSTRAINT fk_pe_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(IdPersona) ON DELETE CASCADE,
    CONSTRAINT fk_pe_equipo FOREIGN KEY (Equipo_Id) REFERENCES Equipo(IdEquipo) ON DELETE CASCADE
);

CREATE TABLE Departamento_Sede (
    Departamento_Id NUMBER(14),
    Sede_Id NUMBER(14),
    CONSTRAINT pk_departamento_sede PRIMARY KEY (Departamento_Id, Sede_Id),
    CONSTRAINT fk_ds_departamento FOREIGN KEY (Departamento_Id) REFERENCES Departamento(IdDepartamento) ON DELETE CASCADE,
    CONSTRAINT fk_ds_sede FOREIGN KEY (Sede_Id) REFERENCES Sede(IdSede) ON DELETE CASCADE
);


--INSERTS

CREATE SEQUENCE seqDepartamento START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Departamento VALUES (seqDepartamento.NEXTVAL,'Desarrollo','Calle Central 1',911111111,'Crear software');
INSERT INTO Departamento VALUES (seqDepartamento.NEXTVAL,'Sistemas','Calle Norte 2',922222222,'Infraestructura TI');
INSERT INTO Departamento VALUES (seqDepartamento.NEXTVAL,'Soporte','Calle Sur 3',933333333,'Atención técnica');

CREATE SEQUENCE seqPersona START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Persona VALUES (seqPersona.NEXTVAL,'Juan','Pérez','Gómez','Backend','11111111A','PROGRAMADOR',1);
INSERT INTO Persona VALUES (seqPersona.NEXTVAL,'Laura','Martín','Ruiz','Frontend','22222222B','PROGRAMADOR',1);
INSERT INTO Persona VALUES (seqPersona.NEXTVAL,'Carlos','Sánchez','López','Gestión','33333333C','LIDERPROYECTO',2);

CREATE SEQUENCE seqEquipo START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Equipo VALUES (seqEquipo.NEXTVAL,'Equipo Alpha',50000,'Desarrollo','Backend');
INSERT INTO Equipo VALUES (seqEquipo.NEXTVAL,'Equipo Beta',60000,'Infraestructura','Sistemas');
INSERT INTO Equipo VALUES (seqEquipo.NEXTVAL,'Equipo Gamma',45000,'Soporte','Helpdesk');

CREATE SEQUENCE seqSede START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Sede VALUES (seqSede.NEXTVAL,'Sede Central','Madrid',911111111,1);
INSERT INTO Sede VALUES (seqSede.NEXTVAL,'Sede Norte','Bilbao',922222222,2);
INSERT INTO Sede VALUES (seqSede.NEXTVAL,'Sede Sur','Sevilla',933333333,3);

CREATE SEQUENCE seqSoftware START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Software VALUES (seqSoftware.NEXTVAL,'ERP Corporativo','Java','1.0',1);
INSERT INTO Software VALUES (seqSoftware.NEXTVAL,'Sistema Red','Python','2.1',2);
INSERT INTO Software VALUES (seqSoftware.NEXTVAL,'App Soporte','PHP','1.5',3);

CREATE SEQUENCE seqProyecto START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Proyecto VALUES (seqProyecto.NEXTVAL,'Proyecto Alpha','ERP empresa','Automatizar procesos',12,'EN PROCESO',1);
INSERT INTO Proyecto VALUES (seqProyecto.NEXTVAL,'Proyecto Beta','Red interna','Mejorar seguridad',8,'COMPLETADO',2);
INSERT INTO Proyecto VALUES (seqProyecto.NEXTVAL,'Proyecto Gamma','App soporte','Atención clientes',6,'A EMPEZAR',3);

INSERT INTO Proyecto_Equipo VALUES (1,1);
INSERT INTO Proyecto_Equipo VALUES (2,2);
INSERT INTO Proyecto_Equipo VALUES (3,3);

INSERT INTO Persona_Equipo VALUES (1,1);
INSERT INTO Persona_Equipo VALUES (2,1);
INSERT INTO Persona_Equipo VALUES (3,2);

INSERT INTO Departamento_Sede VALUES (1,1);
INSERT INTO Departamento_Sede VALUES (2,2);
INSERT INTO Departamento_Sede VALUES (3,3);


--DROPS

DROP SEQUENCE seqDepartamento;
DROP SEQUENCE seqPersona;
DROP SEQUENCE seqEquipo;
DROP SEQUENCE seqSede;
DROP SEQUENCE seqSoftware;
DROP SEQUENCE seqProyecto;

DROP TABLE Departamento_Sede CASCADE CONSTRAINTS;
DROP TABLE Persona_Equipo CASCADE CONSTRAINTS;
DROP TABLE Proyecto_Equipo CASCADE CONSTRAINTS;
DROP TABLE Proyecto CASCADE CONSTRAINTS;
DROP TABLE Software CASCADE CONSTRAINTS;
DROP TABLE Sede CASCADE CONSTRAINTS;
DROP TABLE Persona CASCADE CONSTRAINTS;
DROP TABLE Equipo CASCADE CONSTRAINTS;
DROP TABLE Departamento CASCADE CONSTRAINTS;