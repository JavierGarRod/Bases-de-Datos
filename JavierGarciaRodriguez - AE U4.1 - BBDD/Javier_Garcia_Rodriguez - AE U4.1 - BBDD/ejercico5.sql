CREATE TABLE Persona (
    IdPersona NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Ap1 VARCHAR2(64),
    Ap2 VARCHAR2(64),
    Tlf NUMBER(9),
    DNI VARCHAR2(9) UNIQUE NOT NULL
);

CREATE TABLE Cliente (
    IdCliente NUMBER(14) PRIMARY KEY,
    LicenciaConducir VARCHAR2(32),
    Persona_Id NUMBER(14),
    CONSTRAINT fk_cliente_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(IdPersona) ON DELETE CASCADE
);

CREATE TABLE Sede (
    IdSede NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Direccion VARCHAR2(128),
    Tlf NUMBER(9),
    TipoSede VARCHAR2(32),
    CONSTRAINT ck_tipo_sede CHECK (UPPER(TipoSede) IN ('FÍSICA','ON-LINE'))
);

CREATE TABLE Empleado (
    IdEmpleado NUMBER(14) PRIMARY KEY,
    Contrato VARCHAR2(64),
    Funcion VARCHAR2(64),
    Persona_Id NUMBER(14),
    Sede_Id NUMBER(14),
    CONSTRAINT fk_empleado_persona FOREIGN KEY (Persona_Id) REFERENCES Persona(IdPersona) ON DELETE CASCADE,
    CONSTRAINT fk_empleado_sede FOREIGN KEY (Sede_Id) REFERENCES Sede(IdSede) ON DELETE CASCADE
);

CREATE TABLE Marca (
    IdMarca NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    Historia VARCHAR2(256),
    SitioWeb VARCHAR2(128)
);

CREATE TABLE Modelo (
    IdModelo NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(64) NOT NULL,
    FechaFabricacion DATE,
    LugarFabricacion VARCHAR2(64),
    TipoCombustible VARCHAR2(32),
    Precio NUMBER(8,2),
    CONSTRAINT ck_tipo_combustible CHECK (UPPER(TipoCombustible) IN ('GASOLINA','HÍBRIDO','ELÉCTRICO'))
);

CREATE TABLE Vehiculo (
    IdVehiculo NUMBER(14) PRIMARY KEY,
    Color VARCHAR2(32),
    Año NUMBER(4),
    NumeroSerie VARCHAR2(64) UNIQUE,
    IdMarca NUMBER(14),
    IdModelo NUMBER(14),
    IdOficina NUMBER(14),
    CONSTRAINT fk_vehiculo_marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca) ON DELETE CASCADE,
    CONSTRAINT fk_vehiculo_modelo FOREIGN KEY (IdModelo) REFERENCES Modelo(IdModelo) ON DELETE CASCADE
);

CREATE TABLE Alquiler (
    IdAlquiler NUMBER(14) PRIMARY KEY,
    FechaInicio DATE DEFAULT SYSDATE,
    FechaFin DATE,
    IdCliente NUMBER(14),
    IdEmpleado NUMBER(14),
    Sede_Id NUMBER(14),
    CONSTRAINT fk_alquiler_cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente) ON DELETE CASCADE,
    CONSTRAINT fk_alquiler_empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado) ON DELETE CASCADE,
    CONSTRAINT fk_alquiler_sede FOREIGN KEY (Sede_Id) REFERENCES Sede(IdSede) ON DELETE CASCADE
);