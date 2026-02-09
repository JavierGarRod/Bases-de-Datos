CREATE TABLE Sede (
    Sede_Id NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Direccion VARCHAR2(128) NOT NULL,
    TLF NUMBER(9),
    Email VARCHAR2(64),
    Capacidad NUMBER(5),
    Codigo_Postal VARCHAR2(10),
    TipoSede VARCHAR2(32),
    CONSTRAINT ck_tipo_sede CHECK (UPPER(TipoSede) IN ('BIBLIOTECA','PLATAFORMAWEB'))
);

CREATE TABLE Persona (
    Persona_Id NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Ap1 VARCHAR2(64),
    Ap2 VARCHAR2(64),
    Tlf NUMBER(9),
    Direccion VARCHAR2(128),
    DNI VARCHAR2(9) UNIQUE NOT NULL
);

CREATE TABLE Alumno (
    IdAlumno NUMBER(14) PRIMARY KEY,
    TipoCurso VARCHAR2(32),
    Persona_Id NUMBER(14),
    CONSTRAINT fk_alumno_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(Persona_Id) ON DELETE CASCADE
);

CREATE TABLE Material (
    Material_Id NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    NumCopias NUMBER(4) DEFAULT 1,
    Modelo VARCHAR2(64),
    Estado VARCHAR2(32),
    TipoMaterial VARCHAR2(32),
    Descripcion VARCHAR2(256),
    CONSTRAINT ck_tipo_material CHECK (UPPER(TipoMaterial) IN ('LIBRO','CAMARA')),
    CONSTRAINT ck_estado_material CHECK (UPPER(Estado) IN ('NUEVO','ACEPTABLE','VIEJO','ROTO'))
);

CREATE TABLE Prestamo (
    Prestamo_Id NUMBER(14) PRIMARY KEY,
    IdAlumno NUMBER(14),
    IdMaterial NUMBER(14),
    FechaRetiro DATE DEFAULT SYSDATE,
    FechaDevolucion DATE,
    Estado VARCHAR2(32),
    TiempoPrestamo NUMBER(3),
    CONSTRAINT fk_prestamo_alumno FOREIGN KEY (IdAlumno) REFERENCES Alumno(IdAlumno) ON DELETE CASCADE,
    CONSTRAINT fk_prestamo_material FOREIGN KEY (IdMaterial) REFERENCES Material(Material_Id) ON DELETE CASCADE,
    CONSTRAINT ck_estado_prestamo CHECK (UPPER(Estado) IN ('DENEGADO','ACEPTADO'))
);

CREATE TABLE Personal (
    Personal_Id NUMBER(14) PRIMARY KEY,
    Puesto VARCHAR2(64),
    Persona_Id NUMBER(14),
    Prestamo_Id NUMBER(14),
    CONSTRAINT fk_personal_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(Persona_Id) ON DELETE CASCADE,
    CONSTRAINT fk_personal_prestamo FOREIGN KEY (Prestamo_Id) REFERENCES Prestamo(Prestamo_Id) ON DELETE CASCADE
);

--INSERTS

INSERT INTO Sede VALUES (1, 'Biblioteca Central', 'Avda. Constitución 10', 954111222, 'central@biblio.es', 250, '41001', 'BIBLIOTECA');
INSERT INTO Sede VALUES (2, 'Biblioteca Norte', 'C/ Sierra Nevada 5', 954333444, 'norte@biblio.es', 120, '41015', 'BIBLIOTECA');
INSERT INTO Sede VALUES (3, 'Plataforma Online', 'https://plataforma.biblio.es', NULL, 'online@biblio.es', 10000, '00000', 'PLATAFORMAWEB');

INSERT INTO Persona VALUES (1, 'Rosa', 'Blanco', 'Montero', 600111222, 'C/ Luna 3', '12121212D');
INSERT INTO Persona VALUES (2, 'Juan', 'Muñoz', 'Sanz', 600333444, 'C/ Sol 8', '23232323E');
INSERT INTO Persona VALUES (3, 'María', 'Pastor', NULL, 600555666, 'Avda. Paz 12', '44444444I');
INSERT INTO Persona VALUES (4, 'Javier', 'Prada', 'Oliva', 600777888, 'C/ Olivo 6', '11111111Y');

INSERT INTO Alumno VALUES (1, 'PRESENCIAL', 1);
INSERT INTO Alumno VALUES (2, 'ONLINE', 2);
INSERT INTO Alumno VALUES (3, 'SEMIPRESENCIAL', 1);

INSERT INTO Material VALUES (1, 'Introducción a SQL', 5, '3ª Edición', 'NUEVO', 'LIBRO', 'Manual básico de bases de datos');
INSERT INTO Material VALUES (2, 'Cámara Canon EOS', 2, 'EOS 250D', 'ACEPTABLE', 'CAMARA', 'Cámara réflex para prácticas');
INSERT INTO Material VALUES (3, 'Programación en Java', 3, '2ª Edición', 'VIEJO', 'LIBRO', 'Libro avanzado de Java');

INSERT INTO Prestamo VALUES (1, 1, 1, SYSDATE-5, SYSDATE+10, 'ACEPTADO', 15);
INSERT INTO Prestamo VALUES (2, 2, 2, SYSDATE-2, SYSDATE+5, 'ACEPTADO', 7);
INSERT INTO Prestamo VALUES (3, 3, 3, SYSDATE, NULL, 'DENEGADO', 0);

INSERT INTO Personal VALUES (1, 'Bibliotecario', 3, 1);
INSERT INTO Personal VALUES (2, 'Auxiliar', 4, 2);
INSERT INTO Personal VALUES (3, 'Administrador Plataforma', 3, 3);

--DROPS

DROP TABLE ALUMNO CASCADE CONSTRAINT PURGE;
DROP TABLE MATERIAL CASCADE CONSTRAINT PURGE;
DROP TABLE PERSONAL CASCADE CONSTRAINT PURGE;
DROP TABLE PERSONA CASCADE CONSTRAINT PURGE;
DROP TABLE PRESTAMO CASCADE CONSTRAINT PURGE;
DROP TABLE SEDE CASCADE CONSTRAINT PURGE;