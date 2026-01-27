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
    Participacion VARCHAR2(32),
    Titulo VARCHAR2(128),
    Tipo VARCHAR2(32),
    Ambito_Territorial VARCHAR2(64),
    Referencia_Oficial VARCHAR2(64),
    Boletin_Oficial VARCHAR2(32),
    CONSTRAINT ck_año CHECK (Año_Ejecucion BETWEEN 1256 AND 2025),
    CONSTRAINT ck_participacion CHECK (UPPER(Participacion) IN ('A FAVOR','EN CONTRA')),
    CONSTRAINT ck_tipo CHECK (UPPER(Tipo) IN ('LABORAL','PENAL','COMERCIAL','AMBIENTAL','CIVIL')),
    CONSTRAINT ck_boletin CHECK (UPPER(Boletin_Oficial) IN ('NACIONAL','AUTONÓMICO','PROVINCIAL','INTERNACIONAL'))
);

CREATE TABLE Administracion (
    Administracion_Id NUMBER(14) PRIMARY KEY,
    Sede_Id NUMBER(14),
    Correo VARCHAR2(64),
    Direccion VARCHAR2(128),
    Nombre VARCHAR2(64),
    Proposito VARCHAR2(128),
    Legislacion_Id NUMBER(14),
    CONSTRAINT fk_admin_sede FOREIGN KEY (Sede_Id) REFERENCES Sede(Sede_Id) ON DELETE CASCADE,
    CONSTRAINT fk_admin_leg FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);

CREATE TABLE Nacional (
    Nacional_Id NUMBER(14) PRIMARY KEY,
    BOE VARCHAR2(64),
    Administracion_Id NUMBER(14),
    CONSTRAINT fk_nacional_admin FOREIGN KEY (Administracion_Id) REFERENCES Administracion(Administracion_Id) ON DELETE CASCADE
);

CREATE TABLE Autonomica (
    Autonomica_Id NUMBER(14) PRIMARY KEY,
    BOJA VARCHAR2(64),
    Administracion_Id NUMBER(14),
    CONSTRAINT fk_autonomica_admin FOREIGN KEY (Administracion_Id) REFERENCES Administracion(Administracion_Id) ON DELETE CASCADE
);

CREATE TABLE Local (
    Local_Id NUMBER(14) PRIMARY KEY,
    BOP VARCHAR2(64),
    Administracion_Id NUMBER(14),
    CONSTRAINT fk_local_admin FOREIGN KEY (Administracion_Id) REFERENCES Administracion(Administracion_Id) ON DELETE CASCADE
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
    Empresa_Id NUMBER(14)
);

CREATE TABLE Registro_Inspeccion (
    Registro_Inspeccion_Id NUMBER(14) PRIMARY KEY,
    Fecha_Inicio DATE,
    Fecha_Final DATE,
    Inspeccion_Id NUMBER(14),
    Observacion VARCHAR2(256),
    CONSTRAINT fk_registro_inspeccion FOREIGN KEY (Inspeccion_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE
);

CREATE TABLE Prueba (
    Prueba_Id NUMBER(14) PRIMARY KEY,
    Tipo_Prueba VARCHAR2(32),
    Colaboradores VARCHAR2(128),
    Registro_Inspeccion_Id NUMBER(14),
    CONSTRAINT fk_prueba_registro FOREIGN KEY (Registro_Inspeccion_Id) REFERENCES Registro_Inspeccion(Registro_Inspeccion_Id) ON DELETE CASCADE,
    CONSTRAINT ck_tipo_prueba CHECK (UPPER(Tipo_Prueba) IN ('APTO','NO APTO'))
);

CREATE TABLE Inspector (
    Inspector_Id NUMBER(14) PRIMARY KEY,
    Formacion VARCHAR2(128),
    Nombre VARCHAR2(64),
    DNI VARCHAR2(9) UNIQUE,
    Edad NUMBER(3),
    Especialidad VARCHAR2(64),
    Condicion VARCHAR2(64),
    Registro_Inspeccion_Id NUMBER(14),
    Prueba_Id NUMBER(14),
    Administracion_Id NUMBER(14),
    CONSTRAINT fk_inspector_registro FOREIGN KEY (Registro_Inspeccion_Id) REFERENCES Registro_Inspeccion(Registro_Inspeccion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_inspector_prueba FOREIGN KEY (Prueba_Id) REFERENCES Prueba(Prueba_Id) ON DELETE CASCADE,
    CONSTRAINT fk_inspector_admin FOREIGN KEY (Administracion_Id) REFERENCES Administracion(Administracion_Id) ON DELETE CASCADE
);

CREATE TABLE Organizacion_ITSS (
    Organizacion_Id NUMBER(14) PRIMARY KEY,
    Historial VARCHAR2(256),
    Inspector_Id NUMBER(14),
    CONSTRAINT fk_org_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

CREATE TABLE Observacion (
    Observacion_Id NUMBER(14) PRIMARY KEY,
    Registro_Inspeccion_Id NUMBER(14),
    CONSTRAINT fk_obs_registro FOREIGN KEY (Registro_Inspeccion_Id) REFERENCES Registro_Inspeccion(Registro_Inspeccion_Id) ON DELETE CASCADE
);

CREATE TABLE Colaboradores (
    Colaboradores_Id NUMBER(14) PRIMARY KEY,
    Registro_Inspeccion_Id NUMBER(14),
    CONSTRAINT fk_colab_registro FOREIGN KEY (Registro_Inspeccion_Id) REFERENCES Registro_Inspeccion(Registro_Inspeccion_Id) ON DELETE CASCADE
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
    CONSTRAINT fk_cert_inspeccion FOREIGN KEY (Inspeccion_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_cert_leg FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE,
    CONSTRAINT ck_estado_cert CHECK (UPPER(Estado_Certificacion) IN ('APROBADO','DENEGADO'))
);

CREATE TABLE Legislacion_Inspector (
    Legislacion_Id NUMBER(14),
    Inspector_Id NUMBER(14),
    CONSTRAINT pk_leg_ins PRIMARY KEY (Legislacion_Id, Inspector_Id),
    CONSTRAINT fk_li_leg FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_li_ins FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

CREATE TABLE Legislacion_Certificado (
    Certificado_Id NUMBER(14),
    Legislacion_Id NUMBER(14),
    CONSTRAINT pk_leg_cert PRIMARY KEY (Certificado_Id, Legislacion_Id),
    CONSTRAINT fk_lc_cert FOREIGN KEY (Certificado_Id) REFERENCES Certificado(Certificado_Id) ON DELETE CASCADE,
    CONSTRAINT fk_lc_leg FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);

CREATE TABLE Inspeccion_Legislacion (
    Inspeccion_Id NUMBER(14),
    Legislacion_Id NUMBER(14),
    CONSTRAINT pk_ins_leg PRIMARY KEY (Inspeccion_Id, Legislacion_Id),
    CONSTRAINT fk_il_ins FOREIGN KEY (Inspeccion_Id) REFERENCES Inspeccion(Inspeccion_Id) ON DELETE CASCADE,
    CONSTRAINT fk_il_leg FOREIGN KEY (Legislacion_Id) REFERENCES Legislacion(Legislacion_Id) ON DELETE CASCADE
);

CREATE TABLE Prueba_Inspector (
    Prueba_Id NUMBER(14),
    Inspector_Id NUMBER(14),
    CONSTRAINT pk_prueba_ins PRIMARY KEY (Prueba_Id, Inspector_Id),
    CONSTRAINT fk_pi_prueba FOREIGN KEY (Prueba_Id) REFERENCES Prueba(Prueba_Id) ON DELETE CASCADE,
    CONSTRAINT fk_pi_inspector FOREIGN KEY (Inspector_Id) REFERENCES Inspector(Inspector_Id) ON DELETE CASCADE
);

DROP TABLE Autonomica CASCADE CONSTRAINT PURGE;
DROP TABLE Certificado CASCADE CONSTRAINT PURGE;
DROP TABLE Colaboradores CASCADE CONSTRAINT PURGE;
DROP TABLE Inspeccion CASCADE CONSTRAINT PURGE;
DROP TABLE Inspeccion_Legislacion CASCADE CONSTRAINT PURGE;
DROP TABLE Inspector CASCADE CONSTRAINT PURGE;
DROP TABLE Legislacion CASCADE CONSTRAINT PURGE;
DROP TABLE Legislacion_Certificado CASCADE CONSTRAINT PURGE;
DROP TABLE Legislacion_Inspector CASCADE CONSTRAINT PURGE;
DROP TABLE Local CASCADE CONSTRAINT PURGE;
DROP TABLE Nacional CASCADE CONSTRAINT PURGE;
DROP TABLE Observacion CASCADE CONSTRAINT PURGE;
DROP TABLE Organizacion_ITSS CASCADE CONSTRAINT PURGE;
DROP TABLE Prueba CASCADE CONSTRAINT PURGE;
DROP TABLE Prueba_Inspector CASCADE CONSTRAINT PURGE;
DROP TABLE Registro_Inspeccion CASCADE CONSTRAINT PURGE;
DROP TABLE Sede CASCADE CONSTRAINT PURGE;
DROP TABLE Administracion CASCADE CONSTRAINT PURGE;