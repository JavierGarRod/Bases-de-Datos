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