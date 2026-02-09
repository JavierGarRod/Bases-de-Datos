--CREATE TABLE

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


--INSERTS

INSERT INTO Sede VALUES (1, 912345678, 'madrid@itss.gob.es', 'Paseo de la Castellana 63, Madrid', '28046');
INSERT INTO Sede VALUES (2, 954123456, 'sevilla@itss.gob.es', 'Avda. República Argentina 21, Sevilla', '41011');
INSERT INTO Sede VALUES (3, 933987654, 'barcelona@itss.gob.es', 'Carrer de la Ciutat de Granada 123, Barcelona', '08018');

INSERT INTO Legislacion VALUES
(1, 2015, 'Ley de Prevención de Riesgos Laborales', 'Multa grave', 'A FAVOR',
 'Prevención laboral', 'LABORAL', 'NACIONAL', 'BOE-A-2015-1234', 'NACIONAL');

INSERT INTO Legislacion VALUES
(2, 2020, 'Código Penal', 'Sanción penal', 'EN CONTRA',
 'Delitos contra trabajadores', 'PENAL', 'NACIONAL', 'BOE-A-2020-5678', 'NACIONAL');

INSERT INTO Legislacion VALUES
(3, 2018, 'Ley de Medio Ambiente', 'Multa administrativa', 'A FAVOR',
 'Protección ambiental', 'AMBIENTAL', 'AUTONÓMICO', 'BOJA-2018-4321', 'AUTONÓMICO');

INSERT INTO Administracion VALUES
(1, 1, 'admin.madrid@itss.gob.es', 'Madrid', 'ITSS Madrid',
 'Control laboral', 1);

INSERT INTO Administracion VALUES
(2, 2, 'admin.sevilla@itss.gob.es', 'Sevilla', 'ITSS Andalucía',
 'Inspección autonómica', 3);

INSERT INTO Administracion VALUES
(3, 3, 'admin.bcn@itss.gob.es', 'Barcelona', 'ITSS Cataluña',
 'Supervisión empresarial', 2);

INSERT INTO Nacional VALUES (1, 'BOE 34/2015', 1);
INSERT INTO Nacional VALUES (2, 'BOE 78/2020', 3);
INSERT INTO Nacional VALUES (3, 'BOE 12/2018', 1);

INSERT INTO Autonomica VALUES (1, 'BOJA 45/2018', 2);
INSERT INTO Autonomica VALUES (2, 'BOJA 12/2020', 2);
INSERT INTO Autonomica VALUES (3, 'BOJA 78/2021', 2);

INSERT INTO Local VALUES (1, 'BOP Madrid 2020/34', 1);
INSERT INTO Local VALUES (2, 'BOP Sevilla 2019/21', 2);
INSERT INTO Local VALUES (3, 'BOP Barcelona 2021/11', 3);

INSERT INTO Inspeccion VALUES
(1, 1, DATE '2024-01-10', DATE '2024-01-15', 'INS-001', 1, 1, NULL, 101);

INSERT INTO Inspeccion VALUES
(2, 2, DATE '2024-02-01', DATE '2024-02-10', 'INS-002', 2, 3, 1, 102);

INSERT INTO Inspeccion VALUES
(3, 3, DATE '2024-03-05', DATE '2024-03-12', 'INS-003', 3, 2, NULL, 103);

INSERT INTO Registro_Inspeccion VALUES
(1, DATE '2024-01-10', DATE '2024-01-15', 1, 'Inspección sin incidencias');

INSERT INTO Registro_Inspeccion VALUES
(2, DATE '2024-02-01', DATE '2024-02-10', 2, 'Deficiencias leves');

INSERT INTO Registro_Inspeccion VALUES
(3, DATE '2024-03-05', DATE '2024-03-12', 3, 'Infracción grave detectada');

INSERT INTO Prueba VALUES (1, 'APTO', 'Guardia Civil', 1);
INSERT INTO Prueba VALUES (2, 'NO APTO', 'Policía Autonómica', 2);
INSERT INTO Prueba VALUES (3, 'APTO', 'Técnicos externos', 3);

INSERT INTO Inspector VALUES
(1, 'Derecho Laboral', 'Juan Pérez', '12345678A', 45,
 'Laboral', 'Funcionario', 1, 1, 1);

INSERT INTO Inspector VALUES
(2, 'Derecho Penal', 'María López', '87654321B', 38,
 'Penal', 'Funcionaria', 2, 2, 2);

INSERT INTO Inspector VALUES
(3, 'Ingeniería Ambiental', 'Carlos Ruiz', '11223344C', 50,
 'Ambiental', 'Funcionario', 3, 3, 3);

INSERT INTO Organizacion_ITSS VALUES (1, 'Historial limpio', 1);
INSERT INTO Organizacion_ITSS VALUES (2, 'Varias sanciones', 2);
INSERT INTO Organizacion_ITSS VALUES (3, 'Seguimiento especial', 3);

INSERT INTO Observacion VALUES (1, 1);
INSERT INTO Observacion VALUES (2, 2);
INSERT INTO Observacion VALUES (3, 3);

INSERT INTO Colaboradores VALUES (1, 1);
INSERT INTO Colaboradores VALUES (2, 2);
INSERT INTO Colaboradores VALUES (3, 3);

INSERT INTO Certificado VALUES
(1, 1, 1, 'APROBADO', 'Laboral', 'CERT-001', DATE '2024-01-20', DATE '2026-01-20');

INSERT INTO Certificado VALUES
(2, 2, 3, 'DENEGADO', 'Ambiental', 'CERT-002', DATE '2024-02-20', DATE '2025-02-20');

INSERT INTO Certificado VALUES
(3, 3, 2, 'APROBADO', 'Penal', 'CERT-003', DATE '2024-03-20', DATE '2026-03-20');

INSERT INTO Legislacion_Inspector VALUES (1,1);
INSERT INTO Legislacion_Inspector VALUES (2,2);
INSERT INTO Legislacion_Inspector VALUES (3,3);

INSERT INTO Legislacion_Certificado VALUES (1,1);
INSERT INTO Legislacion_Certificado VALUES (2,3);
INSERT INTO Legislacion_Certificado VALUES (3,2);

INSERT INTO Inspeccion_Legislacion VALUES (1,1);
INSERT INTO Inspeccion_Legislacion VALUES (2,3);
INSERT INTO Inspeccion_Legislacion VALUES (3,2);

INSERT INTO Prueba_Inspector VALUES (1,1);
INSERT INTO Prueba_Inspector VALUES (2,2);
INSERT INTO Prueba_Inspector VALUES (3,3);


--DROPS

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