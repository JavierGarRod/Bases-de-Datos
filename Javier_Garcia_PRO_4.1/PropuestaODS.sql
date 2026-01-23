CREATE TABLE Sede (
    Sede_Id NUMBER(14) PRIMARY KEY,
    Tlf NUMBER(9),
    Correo VARCHAR2(64),
    Direccion VARCHAR2(128),
    Codigo_Postal VARCHAR2(10)
);

CREATE TABLE Legislacion (
    Legislacion_Id NUMBER(14) PRIMARY KEY,
    Año_Ejecucion NUMBER(4),
    Ley_Que_La_Recoge VARCHAR2(128),
    Sancion VARCHAR2(128),
    Participacion VARCHAR2(16),
    Titulo VARCHAR2(128),
    Tipo VARCHAR2(32),
    Ambito_Territorial VARCHAR2(64),
    Referencia_Oficial VARCHAR2(64),
    Boletin_Oficial VARCHAR2(32),
    CONSTRAINT ck_año_ejecucion CHECK (Año_Ejecucion BETWEEN 1256 AND 2025),
    CONSTRAINT ck_participacion CHECK (UPPER(Participacion) IN ('A FAVOR','EN CONTRA')),
    CONSTRAINT ck_tipo_legislacion CHECK (UPPER(Tipo) IN ('LABORAL','PENAL','COMERCIAL','AMBIENTAL','CIVIL')),
    CONSTRAINT ck_boletin CHECK (UPPER(Boletin_Oficial) IN ('NACIONAL','AUTONÓMICO','PROVINCIAL','INTERNACIONAL'))
);

CREATE TABLE Organismo (
    Organismo_Id NUMBER(14) PRIMARY KEY,
    Sede_Id NUMBER(14),
    Correo VARCHAR2(64),
    Direccion VARCHAR2(128),
    Nombre VARCHAR2(64),
    Proposito VARCHAR2(128),
    Legislacion_Id NUMBER(14),
    CONSTRAINT fk_organismo_sede FOREIGN KEY (Sede_Id) REFERENCES Sede(Sede_Id) ON DELETE CASCADE,
    CONSTRAINT fk_organismo_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);

CREATE TABLE Inspector (
    Inspector_Id NUMBER(14) PRIMARY KEY,
    Formacion VARCHAR2(128),
    Nombre VARCHAR2(64) NOT NULL,
    DNI VARCHAR2(9) UNIQUE NOT NULL,
    Edad NUMBER(3),
    Especialidad VARCHAR2(64),
    Condicion VARCHAR2(64),
    Organizacion VARCHAR2(64),
    Registro_Inspeccion_Id NUMBER(14),
    CONSTRAINT fk_inspector_registro FOREIGN KEY (Registro_Inspeccion_Id) REFERENCES Registro_Inspeccion(Registro_Inspeccion_Id) ON DELETE CASCADE
);

CREATE TABLE Formacion (
    Formacion_Id NUMBER(14) PRIMARY KEY,
    Inspector_Id NUMBER(14),
    CONSTRAINT fk_formacion_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

CREATE TABLE Especialidad (
    Especialidad_Id NUMBER(14) PRIMARY KEY,
    Inspector_Id NUMBER(14),
    CONSTRAINT fk_especialidad_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

CREATE TABLE Organizacion_ITSS (
    Organizacion_Id NUMBER(14) PRIMARY KEY,
    Historial VARCHAR2(256),
    Inspector_Id NUMBER(14),
    CONSTRAINT fk_organizacion_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

CREATE TABLE Inspeccion (
    Inspeccion_Id NUMBER(14) PRIMARY KEY,
    Organizacion_Id NUMBER(14),
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    Num_Inspeccion VARCHAR2(32),
    Inspector_Id NUMBER(14),
    Legislacion_Id NUMBER(14),
    Inspeccion_Origen_Id NUMBER(14),
    CONSTRAINT fk_inspeccion_organizacion FOREIGN KEY (Organizacion_Id) REFERENCES Organizacion_ITSS(Organizacion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_inspeccion_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE,
    CONSTRAINT fk_inspeccion_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_inspeccion_origen FOREIGN KEY (Inspeccion_Origen_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE
);

CREATE TABLE Registro_Inspeccion (
    Registro_Inspeccion_Id NUMBER(14) PRIMARY KEY,
    Fecha_Inicio DATE,
    Fecha_Final DATE,
    Inspeccion_Id NUMBER(14),
    Observacion VARCHAR2(256),
    CONSTRAINT fk_registro_inspeccion FOREIGN KEY (Inspeccion_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE
);

CREATE TABLE Observacion (
    Observacion_Id NUMBER(14) PRIMARY KEY,
    Registro_Inspeccion_Id NUMBER(14),
    CONSTRAINT fk_observacion_registro FOREIGN KEY (Registro_Inspeccion_Id) REFERENCES Registro_Inspeccion(Registro_Inspeccion_Id) ON DELETE CASCADE
);

CREATE TABLE Certificado (
    Certificado_Id NUMBER(14) PRIMARY KEY,
    Inspeccion_Id NUMBER(14),
    Legislacion_Id NUMBER(14),
    Estado_Certificacion VARCHAR2(32),
    Tipo_Inspeccion VARCHAR2(64),
    Numero_Referencia VARCHAR2(32),
    Fecha_Emision DATE,
    Fecha_Caducidad DATE,
    CONSTRAINT fk_certificado_inspeccion FOREIGN KEY (Inspeccion_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_certificado_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE,
    CONSTRAINT ck_estado_certificacion CHECK (UPPER(Estado_Certificacion) IN ('APROBADO','DENEGADO'))
);

CREATE TABLE Legislacion_Inspector (
    Legislacion_Id NUMBER(14),
    Inspector_Id NUMBER(14),
    CONSTRAINT pk_legislacion_inspector PRIMARY KEY (Legislacion_Id, Inspector_Id),
    CONSTRAINT fk_li_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_li_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

CREATE TABLE Legislacion_Certificado (
    Certificado_Id NUMBER(14),
    Legislacion_Id NUMBER(14),
    CONSTRAINT pk_legislacion_certificado PRIMARY KEY (Certificado_Id, Legislacion_Id),
    CONSTRAINT fk_lc_certificado FOREIGN KEY (Certificado_Id) REFERENCES Certificado(Certificado_Id) ON DELETE CASCADE,
    CONSTRAINT fk_lc_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);

CREATE TABLE Inspeccion_Legislacion (
    Inspeccion_Id NUMBER(14),
    Legislacion_Id NUMBER(14),
    CONSTRAINT pk_inspeccion_legislacion PRIMARY KEY (Inspeccion_Id, Legislacion_Id),
    CONSTRAINT fk_il_inspeccion FOREIGN KEY (Inspeccion_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_il_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);

CREATE TABLE Sancion (
    Sancion_Id NUMBER(14) PRIMARY KEY,
    Legislacion_Id NUMBER(14),
    CONSTRAINT fk_sancion_legislacion FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);