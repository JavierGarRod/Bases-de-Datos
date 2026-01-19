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