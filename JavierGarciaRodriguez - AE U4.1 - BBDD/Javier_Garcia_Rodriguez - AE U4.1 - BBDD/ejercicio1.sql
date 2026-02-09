CREATE TABLE Sede (
    IdSede NUMBER(14) PRIMARY KEY,
    Tlf NUMBER(9),
    Direccion VARCHAR2(128) NOT NULL
);

CREATE TABLE CicloFormativo (
    IdCiclo NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Duracion NUMBER(2),
    Plazas NUMBER(4),
    Demanda NUMBER(4)
);

CREATE TABLE Sede_CicloFormativo (
    Sede_Id NUMBER(14),
    CicloFormativo_Id NUMBER(14),
    CONSTRAINT pk_sede_ciclo PRIMARY KEY (Sede_Id, CicloFormativo_Id),
    CONSTRAINT fk_sede FOREIGN KEY (Sede_Id) REFERENCES Sede(IdSede) ON DELETE CASCADE,
    CONSTRAINT fk_ciclo FOREIGN KEY (CicloFormativo_Id) REFERENCES CicloFormativo(IdCiclo) ON DELETE CASCADE
);

CREATE TABLE Persona (
    IdPersona NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Ap1 VARCHAR2(64),
    Ap2 VARCHAR2(64),
    DNI VARCHAR2(9) UNIQUE NOT NULL,
    Trayectoria VARCHAR2(128),
    Contacto VARCHAR2(64),
    Direccion VARCHAR2(128)
);

CREATE TABLE Alumno (
    IdAlumno NUMBER(14) PRIMARY KEY,
    TipoAcceso VARCHAR2(32),
    TipoAlumno VARCHAR2(32),
    Curso_Cursado NUMBER(2),
    Persona_Id NUMBER(14),
    CONSTRAINT fk_alumno_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(IdPersona) ON DELETE CASCADE,
    CONSTRAINT ck_tipo_acceso CHECK (UPPER(TipoAcceso) IN ('BACHILLER','GRADO_MEDIO','PRUEBA_ACCESO')),
    CONSTRAINT ck_tipo_alumno CHECK (UPPER(TipoAlumno) IN ('REPETIDOR','PROMOCIONA_CURSO'))
);

CREATE TABLE Docente (
    IdDocente NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    DNI VARCHAR2(9) UNIQUE NOT NULL,
    Apellido VARCHAR2(64),
    Materia VARCHAR2(64),
    Persona_Id NUMBER(14),
    CONSTRAINT fk_docente_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(IdPersona) ON DELETE CASCADE
);

CREATE TABLE Modulo (
    IdModulo NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Curso NUMBER(2),
    CicloFormativo_Id NUMBER(14),
    Modulo_Id NUMBER(14),
    Docente_Id NUMBER(14),
    CONSTRAINT fk_modulo_ciclo FOREIGN KEY (CicloFormativo_Id) REFERENCES CicloFormativo(IdCiclo) ON DELETE CASCADE,
    CONSTRAINT fk_modulo_docente FOREIGN KEY (Docente_Id) REFERENCES Docente(IdDocente) ON DELETE CASCADE
);

CREATE TABLE Matricula (
    IdMatricula NUMBER(14) PRIMARY KEY,
    IdAlumno NUMBER(14),
    AñoAcademico VARCHAR2(9),
    Nota NUMBER(4,2),
    CONSTRAINT fk_matricula_alumno FOREIGN KEY (IdAlumno) REFERENCES Alumno(IdAlumno) ON DELETE CASCADE
);

CREATE TABLE Matricula_Modulo (
    Matricula_Id NUMBER(14),
    Modulo_Id NUMBER(14),
    CONSTRAINT pk_matricula_modulo PRIMARY KEY (Matricula_Id, Modulo_Id),
    CONSTRAINT fk_mm_matricula FOREIGN KEY (Matricula_Id) REFERENCES Matricula(IdMatricula) ON DELETE CASCADE,
    CONSTRAINT fk_mm_modulo FOREIGN KEY (Modulo_Id) REFERENCES Modulo(IdModulo) ON DELETE CASCADE
);

--INSERTS

INSERT INTO Sede VALUES (1, 954123456, 'Avda. de Andalucía 15, Sevilla');
INSERT INTO Sede VALUES (2, 956987654, 'C/ Mayor 22, Cádiz');
INSERT INTO Sede VALUES (3, 955456789, 'C/ Real 10, Huelva');

INSERT INTO CicloFormativo VALUES (1, 'Desarrollo de Aplicaciones Web', 2, 30, 45);
INSERT INTO CicloFormativo VALUES (2, 'Desarrollo de Aplicaciones Multiplataforma', 2, 30, 50);
INSERT INTO CicloFormativo VALUES (3, 'Administración de Sistemas Informáticos en Red', 2, 25, 40);

INSERT INTO Sede_CicloFormativo VALUES (1, 1);
INSERT INTO Sede_CicloFormativo VALUES (1, 2);
INSERT INTO Sede_CicloFormativo VALUES (2, 3);
INSERT INTO Sede_CicloFormativo VALUES (3, 1);

INSERT INTO Persona VALUES (1, 'Rosa', 'Blanco', 'Montero', '12121212D', 'Estudiante', 'rosa@email.com', 'C/ Luna 3');
INSERT INTO Persona VALUES (2, 'Juan', 'Muñoz', 'Sanz', '23232323E', 'Estudiante', 'juan@email.com', 'C/ Sol 8');
INSERT INTO Persona VALUES (3, 'Javier', 'Prada', 'Oliva', '11111111Y', 'Docente TIC', 'javier@email.com', 'Avda. Paz 12');
INSERT INTO Persona VALUES (4, 'María', 'Pastor', NULL, '44444444I', 'Docente FOL', 'maria@email.com', 'C/ Olivo 6');

INSERT INTO Alumno VALUES (1, 'BACHILLER', 'PROMOCIONA_CURSO', 1, 1);
INSERT INTO Alumno VALUES (2, 'GRADO_MEDIO', 'REPETIDOR', 2, 2);
INSERT INTO Alumno VALUES (3, 'PRUEBA_ACCESO', 'PROMOCIONA_CURSO', 1, 1);

INSERT INTO Docente VALUES (1, 'Javier', '11111111Y', 'Prada', 'Programación', 3);
INSERT INTO Docente VALUES (2, 'María', '44444444I', 'Pastor', 'FOL', 4);
INSERT INTO Docente VALUES (3, 'Daniel', '22222222H', 'Muñiz', 'Bases de Datos', 3);

INSERT INTO Modulo VALUES (1, 'Programación', 1, 1, NULL, 1);
INSERT INTO Modulo VALUES (2, 'Bases de Datos', 1, 1, NULL, 3);
INSERT INTO Modulo VALUES (3, 'Formación y Orientación Laboral', 1, 2, NULL, 2);

INSERT INTO Matricula VALUES (1, 1, '21/22', 7.50);
INSERT INTO Matricula VALUES (2, 2, '21/22', 5.00);
INSERT INTO Matricula VALUES (3, 3, '21/22', NULL);

INSERT INTO Matricula_Modulo VALUES (1, 1);
INSERT INTO Matricula_Modulo VALUES (1, 2);
INSERT INTO Matricula_Modulo VALUES (2, 2);
INSERT INTO Matricula_Modulo VALUES (3, 3);

--DROPS

DROP TABLE ALUMNO CASCADE CONSTRAINT PURGE;
DROP TABLE CICLOFORMATIVO CASCADE CONSTRAINT PURGE;
DROP TABLE DOCENTE CASCADE CONSTRAINT PURGE;
DROP TABLE MATRICULA CASCADE CONSTRAINT PURGE;
DROP TABLE MATRICULA_MODULO CASCADE CONSTRAINT PURGE;
DROP TABLE MODULO CASCADE CONSTRAINT PURGE;
DROP TABLE PERSONA CASCADE CONSTRAINT PURGE;
DROP TABLE SEDE CASCADE CONSTRAINT PURGE;
DROP TABLE SEDE_CICLOFORMATIVO CASCADE CONSTRAINT PURGE;