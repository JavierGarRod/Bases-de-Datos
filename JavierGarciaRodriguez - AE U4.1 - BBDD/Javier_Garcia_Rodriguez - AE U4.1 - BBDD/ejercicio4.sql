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