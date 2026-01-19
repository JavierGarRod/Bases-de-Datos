CREATE TABLE Proveedor(
	IDProveedor number(14) PRIMARY KEY,
	Nombre varchar2(32) NOT NULL,
	CIF varchar2(32) NOT NULL UNIQUE,
	Direccion varchar2(128) NOT NULL,
	Correo varchar2(32) NOT NULL UNIQUE,
    Telefono number(9),
    CuentaBancaria varchar2(36)
);
CREATE TABLE Tienda(
	IDTienda number(14) PRIMARY KEY,
	Nombre varchar2(32) NOT NULL,
	CIF varchar2(32) NOT NULL UNIQUE,
	Direccion varchar2(128) NOT NULL,
	Correo varchar2(32) NOT NULL UNIQUE,
    Telefono number(9),
    CuentaBancaria varchar2(36),
    Tipo varchar2(14) NOT NULL,
    CONSTRAINT ck_tipo_tienda CHECK(Tipo IN('On-line','Física'))
);

CREATE TABLE Producto(
	IdProducto number(14) PRIMARY KEY,
	Nombre varchar2(32) NOT NULL,
	SKU varchar2(32) NOT NULL UNIQUE,
	Marca varchar2(32) NOT NULL,
	Modelo varchar2(32) NOT NULL,
    -- Precio estándar de 6 dígitos + 2 decimales
	Precio number(6,2),
    Categoria varchar2(32) DEFAULT 'Móviles',
    -- Los estados posibles son: 'B' Borrador (por defecto), 'P' Publicado y 'E' Eliminado
    Estado char(1) DEFAULT 'B',
    UltimaModificacion DATE DEFAULT SYSDATE,
    CONSTRAINT ck_CategoriaProducto CHECK(Categoria IN('Móviles','Carcasas','Cargadores','Tarjetas SIM', 'Accesorios')),
    CONSTRAINT ck_EstadoProducto CHECK(Estado IN('B','P','E'))
);

CREATE TABLE Compra (
    IdCompra number(14),
    IdProveedor number(14),
    IdTienda number(14),
    Fecha DATE DEFAULT SYSDATE,
    CONSTRAINT pk_compra PRIMARY KEY (IdCompra,IdProveedor, IdTienda),
    CONSTRAINT fk_CompraProveedor FOREIGN KEY(IdProveedor) REFERENCES Proveedor(IdProveedor) ON DELETE CASCADE,
    CONSTRAINT fk_CompraTienda FOREIGN KEY(IdTienda) REFERENCES Tienda(IdTienda) ON DELETE CASCADE    
);

CREATE TABLE LineaCompra(
   IdLinComp number(14) NOT NULL,
   IdCompra number(14) NOT NULL,
   IdProveedor number(14) NOT NULL,
   IdTienda number(14) NOT NULL,
   IdProducto number(14) NOT NULL,
   Cantidad number(5) DEFAULT 0,
   IVA number(2) DEFAULT 21,
   Descuento number(3),
   PrecioUnitario number(6,2),
   -- PrecioUnitario- (Precio Unitario * (Descuento/100)) * Cantidad
   TotalLinea number(6,2),
   TotalIVALinea number(6,2),
   CONSTRAINT pk_lineaCompra PRIMARY KEY(IdLinComp, IdCompra, IdProducto),
   CONSTRAINT fk_compra FOREIGN KEY (IdCompra,IdProveedor,IdTienda) REFERENCES Compra(IdCompra,IdProveedor,IdTienda) ON DELETE CASCADE,
   CONSTRAINT fk_producto FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto) ON DELETE CASCADE,
   CONSTRAINT ck_IVA CHECK (IVA IN (0,4,10,21))
);

CREATE TABLE Cliente (
    IdCliente NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(32) NOT NULL,
    Ap1 VARCHAR2(32),
    Ap2 VARCHAR2(32),
    DNI VARCHAR2(9) UNIQUE NOT NULL,
    Telefono NUMBER(9),
    TipoRequisito VARCHAR2(32)
);

CREATE TABLE TipoRequisito (
    TipoRequisito VARCHAR2(32) PRIMARY KEY,
    IdCliente NUMBER(14),
    CONSTRAINT fk_tipoRequisito_cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente) ON DELETE CASCADE
);

CREATE TABLE Empleado (
    IdEmpleado NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(32) NOT NULL,
    Ap1 VARCHAR2(32),
    Ap2 VARCHAR2(32),
    Telefono NUMBER(9),
    Email VARCHAR2(64) UNIQUE,
    TipoFuncion VARCHAR2(32)
);

CREATE TABLE Marca (
    IdMarca NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(32) NOT NULL,
    Fabricante VARCHAR2(64),
    Localizacion VARCHAR2(64),
    Precio NUMBER(6,2)
);

CREATE TABLE Modelo (
    IdModelo NUMBER(14) PRIMARY KEY,
    Nombre VARCHAR2(32) NOT NULL,
    FechaLanzamiento DATE,
    PromoLanzamiento VARCHAR2(64),
    Precio NUMBER(6,2),
    Estetica VARCHAR2(64)
);

CREATE TABLE Movil (
    IdMovil NUMBER(14) PRIMARY KEY,
    CapacidadAlmacenamiento VARCHAR2(32),
    PrecioVentaRecomendado NUMBER(6,2),
    IdMarca NUMBER(14),
    IdModelo NUMBER(14),
    CONSTRAINT fk_movil_marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca),
    CONSTRAINT fk_movil_modelo FOREIGN KEY (IdModelo) REFERENCES Modelo(IdModelo)
);

CREATE TABLE Venta (
    IdVenta NUMBER(14) PRIMARY KEY,
    PrecioTotal NUMBER(8,2),
    Pedidos VARCHAR2(64),
    MetodoPago VARCHAR2(32),
    IdCliente NUMBER(14),
    IdEmpleado NUMBER(14),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE Stock (
    IdStock NUMBER(14) PRIMARY KEY,
    FechaRecepcion DATE DEFAULT SYSDATE,
    CostoUnitario NUMBER(6,2),
    Estado VARCHAR2(32),
    IdMovil NUMBER(14),
    IdTienda NUMBER(14),
    CONSTRAINT fk_stock_movil FOREIGN KEY (IdMovil) REFERENCES Movil(IdMovil),
    CONSTRAINT fk_stock_tienda FOREIGN KEY (IdTienda) REFERENCES Tienda(IdTienda)
);