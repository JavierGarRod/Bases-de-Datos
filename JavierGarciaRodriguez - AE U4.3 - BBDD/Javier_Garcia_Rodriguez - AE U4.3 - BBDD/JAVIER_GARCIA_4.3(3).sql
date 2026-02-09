--CREATE TABLE

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

--INSERTS

CREATE SEQUENCE seqProveedor START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Proveedor VALUES (seqProveedor.NEXTVAL,'Proveedor Uno','A11111111','Calle Mayor 1','prov1@mail.com',600111111,'ES1111');
INSERT INTO Proveedor VALUES (seqProveedor.NEXTVAL,'Proveedor Dos','B22222222','Calle Sol 2','prov2@mail.com',600222222,'ES2222');
INSERT INTO Proveedor VALUES (seqProveedor.NEXTVAL,'Proveedor Tres','C33333333','Calle Luna 3','prov3@mail.com',600333333,'ES3333');

CREATE SEQUENCE seqTienda START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Tienda VALUES (seqTienda.NEXTVAL,'Tienda Online','T11111111','Web','online@mail.com',NULL,'ES4444','On-line');
INSERT INTO Tienda VALUES (seqTienda.NEXTVAL,'Tienda Centro','T22222222','Avda Centro','centro@mail.com',611111111,'ES5555','Física');
INSERT INTO Tienda VALUES (seqTienda.NEXTVAL,'Tienda Norte','T33333333','Avda Norte','norte@mail.com',622222222,'ES6666','Física');

CREATE SEQUENCE seqProducto START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Producto VALUES (seqProducto.NEXTVAL,'iPhone 14','SKU001','Apple','14',899,'Móviles','P',SYSDATE);
INSERT INTO Producto VALUES (seqProducto.NEXTVAL,'Galaxy S23','SKU002','Samsung','S23',799,'Móviles','P',SYSDATE);
INSERT INTO Producto VALUES (seqProducto.NEXTVAL,'Cargador USB','SKU003','Xiaomi','USB-C',19,'Cargadores','B',SYSDATE);

CREATE SEQUENCE seqCompra START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Compra VALUES (seqCompra.NEXTVAL,1,1,'01/02/23');
INSERT INTO Compra VALUES (seqCompra.NEXTVAL,2,2,'05/02/23');
INSERT INTO Compra VALUES (seqCompra.NEXTVAL,3,3,'10/02/23');

CREATE SEQUENCE seqLineaCompra START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO LineaCompra VALUES (seqLineaCompra.NEXTVAL,1,1,1,1,10,21,0,800,8000,9680);
INSERT INTO LineaCompra VALUES (seqLineaCompra.NEXTVAL,2,2,2,2,5,21,5,750,3562.5,4310.62);
INSERT INTO LineaCompra VALUES (seqLineaCompra.NEXTVAL,3,3,3,3,20,10,0,18,360,396);

CREATE SEQUENCE seqCliente START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Cliente VALUES (seqCliente.NEXTVAL,'Juan','Pérez','Gómez','11111111A',600000001,'Premium');
INSERT INTO Cliente VALUES (seqCliente.NEXTVAL,'María','López','Ruiz','22222222B',600000002,'Normal');
INSERT INTO Cliente VALUES (seqCliente.NEXTVAL,'Ana','Martín','Sanz','33333333C',600000003,'Empresa');

INSERT INTO TipoRequisito VALUES ('Premium',1);
INSERT INTO TipoRequisito VALUES ('Normal',2);
INSERT INTO TipoRequisito VALUES ('Empresa',3);

CREATE SEQUENCE seqEmpleado START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Empleado VALUES (seqEmpleado.NEXTVAL,'Carlos','Sánchez','',611111111,'emp1@mail.com','Vendedor');
INSERT INTO Empleado VALUES (seqEmpleado.NEXTVAL,'Laura','Díaz','',622222222,'emp2@mail.com','Cajero');
INSERT INTO Empleado VALUES (seqEmpleado.NEXTVAL,'Pedro','Romero','',633333333,'emp3@mail.com','Gerente');

CREATE SEQUENCE seqMarca START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Marca VALUES (seqMarca.NEXTVAL,'Apple','Apple Inc.','USA',900);
INSERT INTO Marca VALUES (seqMarca.NEXTVAL,'Samsung','Samsung Corp.','Corea',800);
INSERT INTO Marca VALUES (seqMarca.NEXTVAL,'Xiaomi','Xiaomi Ltd.','China',500);

CREATE SEQUENCE seqModelo START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Modelo VALUES (seqModelo.NEXTVAL,'iPhone 14','01/09/22','Promo lanzamiento',899,'Elegante');
INSERT INTO Modelo VALUES (seqModelo.NEXTVAL,'Galaxy S23','01/02/23','Descuento inicial',799,'Moderno');
INSERT INTO Modelo VALUES (seqModelo.NEXTVAL,'Redmi 12','01/01/23','',199,'Sencillo');

CREATE SEQUENCE seqMovil START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Movil VALUES (seqMovil.NEXTVAL,'128GB',899,1,1);
INSERT INTO Movil VALUES (seqMovil.NEXTVAL,'256GB',999,1,1);
INSERT INTO Movil VALUES (seqMovil.NEXTVAL,'128GB',799,2,2);

CREATE SEQUENCE seqVenta START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Venta VALUES (seqVenta.NEXTVAL,1200,'Pedido001','Tarjeta',1,1);
INSERT INTO Venta VALUES (seqVenta.NEXTVAL,800,'Pedido002','Efectivo',2,2);
INSERT INTO Venta VALUES (seqVenta.NEXTVAL,500,'Pedido003','Transferencia',3,3);

CREATE SEQUENCE seqStock START WITH 1 INCREMENT BY 1 MAXVALUE 9999999999999999 NOCYCLE;

INSERT INTO Stock VALUES (seqStock.NEXTVAL,'01/02/23',700,'Disponible',1,1);
INSERT INTO Stock VALUES (seqStock.NEXTVAL,'03/02/23',750,'Vendido',2,2);
INSERT INTO Stock VALUES (seqStock.NEXTVAL,'05/02/23',450,'Disponible',3,3);


--DROPS

DROP TABLE LineaCompra CASCADE CONSTRAINTS;
DROP TABLE Compra CASCADE CONSTRAINTS;
DROP TABLE Stock CASCADE CONSTRAINTS;
DROP TABLE Venta CASCADE CONSTRAINTS;
DROP TABLE Movil CASCADE CONSTRAINTS;
DROP TABLE Modelo CASCADE CONSTRAINTS;
DROP TABLE Marca CASCADE CONSTRAINTS;
DROP TABLE TipoRequisito CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Empleado CASCADE CONSTRAINTS;
DROP TABLE Producto CASCADE CONSTRAINTS;
DROP TABLE Tienda CASCADE CONSTRAINTS;
DROP TABLE Proveedor CASCADE CONSTRAINTS;

DROP SEQUENCE seqProveedor;
DROP SEQUENCE seqTienda;
DROP SEQUENCE seqProducto;
DROP SEQUENCE seqCompra;
DROP SEQUENCE seqLineaCompra;
DROP SEQUENCE seqCliente;
DROP SEQUENCE seqEmpleado;
DROP SEQUENCE seqMarca;
DROP SEQUENCE seqModelo;
DROP SEQUENCE seqMovil;
DROP SEQUENCE seqVenta;
DROP SEQUENCE seqStock;

