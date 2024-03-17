/* SCRIPT PARA LA CREACIÓN DEL SCHEMA DEL GRUPO# */
-- USUARIO SYS DE LA BASE DE DATOS
-- SE ELIMINA EL USUARIO A UTILIZAR PARA EVITAR PROBLEMAS DE CONFLICTOS DURANTE LA EJECUCION DEL SCRIP.
--DROP USER ADMINT CASCADE;

-- CREACION DEL USUARIO, DEFINICION DEL TABLE SPACE.
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER ADMIN_TIENDA IDENTIFIED BY admin_tienda_proyecto;

ALTER USER ADMIN_TIENDA DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER USER ADMIN_TIENDA TEMPORARY TABLESPACE TEMP;

-- DAR PERMISOS AL USUARIO ADMINISTRADOR DEL SCHEMA PARA QUE PUEDA REALIZAR ACCIONES.
GRANT CONNECT TO ADMIN_TIENDA;

GRANT CREATE SESSION, CREATE VIEW, CREATE TABLE, ALTER SESSION, CREATE SEQUENCE TO ADMIN_TIENDA;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE, UNLIMITED TABLESPACE TO ADMIN_TIENDA;

-- SE PONE LA SESIÓN EN COSTA RICA Y LENGUAJE ESPAÑOL
ALTER SESSION SET NLS_LANGUAGE = 'SPANISH';
ALTER SESSION SET NLS_TERRITORY = 'COSTA RICA';

-- USUARIO ADMIN_TIENDA
-- SELECCION DEL SCHEMA CREADO
ALTER SESSION SET CURRENT_SCHEMA = ADMIN_TIENDA;

-- CREACION DE TABLAS
/* TBL_EMPLEADOS */
CREATE TABLE TBL_EMPLEADOS (
    CEDULA VARCHAR2(9) NOT NULL,
    ID_EMPLEADO VARCHAR2(6) NOT NULL,
	PRIMER_NOMBRE VARCHAR2(50) NOT NULL,
	SEGUNDO_NOMBRE VARCHAR2(50),
	PRIMER_APELLIDO VARCHAR2(50) NOT NULL,
	SEGUNDO_APELLIDO VARCHAR2(50),
	DIRECCION VARCHAR2(250) NOT NULL,
	PUESTO VARCHAR2(25) NOT NULL,
	SALARIO NUMBER NOT NULL
);

/* TBL_CLIENTES */
CREATE TABLE TBL_CLIENTES (
    CEDULA VARCHAR2(9) NOT NULL,
	PRIMER_NOMBRE VARCHAR2(50) NOT NULL,
	SEGUNDO_NOMBRE VARCHAR2(50),
	PRIMER_APELLIDO VARCHAR2(50) NOT NULL,
	SEGUNDO_APELLIDO VARCHAR2(50),
	DIRECCION VARCHAR2(250)
);

/* TBL_ROLES */
CREATE TABLE TBL_ROLES (
    ID_ROL VARCHAR2(5) NOT NULL,
	DESCRIPCION VARCHAR2(250) NOT NULL
);

/* TBL_PRODUCTOS */
CREATE TABLE TBL_PRODUCTOS (
    ID_PRODUCTO VARCHAR2(5) NOT NULL,
	DESCRIPCION VARCHAR2(250) NOT NULL,
	PRECIO NUMBER NOT NULL,
	PROOVEDOR VARCHAR2(9) NOT NULL,
	FECHA_INGRESO DATE,
	CANTIDAD NUMBER NOT NULL
);

/* TBL_PROOVEDORES */
CREATE TABLE TBL_PROOVEDORES (
    ID_PROOVEDOR VARCHAR2(5) NOT NULL,
    DESCRIPCION VARCHAR2(250) NOT NULL,
	FECHA_INGRESO DATE
);

/* TBL_ENCABEZADO_FACTURA */
CREATE TABLE TBL_ENCABEZADO_FACTURA (
    ID_FACTURA NUMBER NOT NULL,
    FECHA_REGISTRO DATE NOT NULL,
	ID_CLIENTE VARCHAR2(9) NOT NULL,
	ID_EMPLEADO VARCHAR2(9) NOT NULL,
	TOTAL NUMBER,
	TIPO_PAGO VARCHAR2(50) NOT NULL
);

/* TBL_DETALLE_FACTURA */
CREATE TABLE TBL_DETALLE_FACTURA (
    ID_FACTURA NUMBER NOT NULL,
    LINEA NUMBER NOT NULL,
	ID_PRODUCTO VARCHAR2(5) NOT NULL,
	PRECIO NUMBER NOT NULL,
	CANTIDAD NUMBER NOT NULL
);

/* TBL_TELEFONOS */
CREATE TABLE TBL_TELEFONOS (
    ID_USUARIO VARCHAR2(9) NOT NULL,
    TELEFONO VARCHAR2(15) NOT NULL
);

/* TBL_CORREOS */
CREATE TABLE TBL_CORREOS (
    ID_USUARIO VARCHAR2(9) NOT NULL,
    CORREO VARCHAR2(50) NOT NULL
);

/* TBL_ROLES_EMPLEADOS */
CREATE TABLE TBL_ROLES_EMPLEADOS (
    ID_EMPLEADO VARCHAR2(9) NOT NULL,
    ID_ROL VARCHAR2(5) NOT NULL
);

-- CREACION DE PRIMARY KEYS, UNIQUE COLUMNS E INDEX
/* TBL_EMPLEADOS */
ALTER TABLE TBL_EMPLEADOS
ADD (
    CONSTRAINT PK_EMPLEADOS PRIMARY KEY (CEDULA),
    CONSTRAINT UK_ID_EMPLEADOS UNIQUE (ID_EMPLEADO)
);

/* TBL_CLIENTES */
ALTER TABLE TBL_CLIENTES
ADD (
    CONSTRAINT PK_CLIENTES PRIMARY KEY (CEDULA)
);

/* TBL_ROLES */
ALTER TABLE TBL_ROLES
ADD (
    CONSTRAINT PK_ROLES PRIMARY KEY (ID_ROL)
);

/* TBL_PRODUCTOS */
ALTER TABLE TBL_PRODUCTOS
ADD (
    CONSTRAINT PK_PRODUCTOS PRIMARY KEY (ID_PRODUCTO)
);

/* TBL_PROOVEDORES */
ALTER TABLE TBL_PROOVEDORES
ADD (
    CONSTRAINT PK_PROOVEDORES PRIMARY KEY (ID_PROOVEDOR),
	CONSTRAINT UK_DESC_PROOVEDORES UNIQUE (DESCRIPCION)
);

/* TBL_ENCABEZADO_FACTURA */
ALTER TABLE TBL_ENCABEZADO_FACTURA
ADD (
    CONSTRAINT PK_ENCABEZADO_FACTURA PRIMARY KEY (ID_FACTURA)
);

/* TBL_DETALLE_FACTURA */
ALTER TABLE TBL_DETALLE_FACTURA
ADD (
    CONSTRAINT PK_DETALLE_FACTURA PRIMARY KEY (ID_FACTURA, LINEA)
);

/* TBL_TELEFONOS */
ALTER TABLE TBL_TELEFONOS
ADD (
    CONSTRAINT PK_TELEFONOS PRIMARY KEY (ID_USUARIO, TELEFONO)
);

/* TBL_CORREOS */
ALTER TABLE TBL_CORREOS
ADD (
    CONSTRAINT TBL_CORREOS PRIMARY KEY (ID_USUARIO, CORREO)
);

/* TBL_ROLES_EMPLEADOS */
ALTER TABLE TBL_ROLES_EMPLEADOS
ADD (
    CONSTRAINT PK_ROLES_EMPLEADOS PRIMARY KEY (ID_EMPLEADO, ID_ROL)
);

-- CREACION DE FOREING KEYS
/* TBL_EMPLEADOS */

/* TBL_CLIENTES */

/* TBL_ROLES */

/* TBL_PRODUCTOS */
ALTER TABLE TBL_PRODUCTOS
ADD (
    CONSTRAINT FK_PRODUCTOS_PROOVEDOR FOREIGN KEY (PROOVEDOR) REFERENCES TBL_PROOVEDORES (ID_PROOVEDOR)
);

/* TBL_PROOVEDORES */

/* TBL_ENCABEZADO_FACTURA */
ALTER TABLE TBL_ENCABEZADO_FACTURA
ADD (
    CONSTRAINT FK_FACTURA_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES TBL_CLIENTES (CEDULA),
	CONSTRAINT FK_FACTURA_EMPLEADO FOREIGN KEY (ID_EMPLEADO) REFERENCES TBL_EMPLEADOS (CEDULA)
);

/* TBL_DETALLE_FACTURA */
ALTER TABLE TBL_DETALLE_FACTURA
ADD (
    CONSTRAINT FK_ENCABEZADO_DETALLE FOREIGN KEY (ID_FACTURA) REFERENCES TBL_ENCABEZADO_FACTURA (ID_FACTURA),
	CONSTRAINT FK_FACTURA_PRODUCTO FOREIGN KEY (ID_PRODUCTO) REFERENCES TBL_PRODUCTOS (ID_PRODUCTO)
);

/* TBL_TELEFONOS */
ALTER TABLE TBL_TELEFONOS
ADD (
    CONSTRAINT FK_TELEFONO_CLIENTE FOREIGN KEY (ID_USUARIO) REFERENCES TBL_CLIENTES (CEDULA)
);

/* TBL_CORREOS */
ALTER TABLE TBL_CORREOS
ADD (
    CONSTRAINT FK_CORREO_CLIENTE FOREIGN KEY (ID_USUARIO) REFERENCES TBL_CLIENTES (CEDULA)
);

/* TBL_ROLES_EMPLEADOS */
ALTER TABLE TBL_ROLES_EMPLEADOS
ADD (
    CONSTRAINT FK_ROL_EMPLEADO FOREIGN KEY (ID_EMPLEADO) REFERENCES TBL_EMPLEADOS (CEDULA),
	CONSTRAINT FK_ROL_ASOCIADO FOREIGN KEY (ID_ROL) REFERENCES TBL_ROLES (ID_ROL)
);

-- LLENAR TABLA DE ROLES
INSERT INTO TBL_ROLES
VALUES ('ADMIN','Administrador de empleados');
INSERT INTO TBL_ROLES
VALUES ('CAJAS','Empleado en cajas');
INSERT INTO TBL_ROLES
VALUES ('REPAR','Repartidor');
INSERT INTO TBL_ROLES
VALUES ('REPON','Reponedor');

-- FUNCIONES
/* GENERAR CODIGO EMPLEADO */
CREATE OR REPLACE FUNCTION FUN_CODIGO_EMPLEADO RETURN VARCHAR2 IS
    NUEVO_CODIGO VARCHAR2(6);
    NUMERO_ACTUAL NUMBER;
BEGIN
    -- OBTENER ULTIMO EMPLEADO
    SELECT MAX(SUBSTR(ID_EMPLEADO, 4)) INTO NUMERO_ACTUAL
    FROM TBL_EMPLEADOS;

    -- INCREMENTAR UN EMPLEADO
	IF NUMERO_ACTUAL IS NULL THEN
		NUMERO_ACTUAL := 1;
	ELSE
		NUMERO_ACTUAL := NUMERO_ACTUAL + 1;
	END IF;
	
    -- GENERAR CODIGO
    NUEVO_CODIGO := 'EMP' || LPAD(NUMERO_ACTUAL, 3, '0');

    -- RETORNAR CODIGO
    RETURN NUEVO_CODIGO;
END;
/

/* Funcion que valida la factura con el monto mas alto */
CREATE OR REPLACE FUNCTION ValidarMontoMasAltoCliente RETURN SYS_REFCURSOR IS
    factura_cursor SYS_REFCURSOR;
BEGIN
    OPEN factura_cursor FOR
        SELECT e.id_cliente, e.total
        FROM TBL_ENCABEZADO_FACTURA e
        WHERE e.total = (SELECT MAX(total) FROM TBL_ENCABEZADO_FACTURA);

    RETURN factura_cursor;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron facturas en la base de datos.');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar validar el monto más alto: ' || SQLERRM);
        RETURN NULL;
END ValidarMontoMasAltoCliente;

-- PROCESOS ALMACENADOS
/* Registar nuevo proveedor */	
CREATE OR REPLACE PROCEDURE AgregarProveedor(
    p_ID_PROVEEDOR IN VARCHAR2,
    p_DESCRIPCION IN VARCHAR2,
    p_FECHA_INGRESO IN DATE
)
IS
BEGIN
    INSERT INTO TBL_PROOVEDORES (ID_PROOVEDOR, DESCRIPCION, FECHA_INGRESO)
    VALUES (p_ID_PROVEEDOR, p_DESCRIPCION, p_FECHA_INGRESO);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proveedor agregado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al intentar agregar el proveedor: ' || SQLERRM);
END AgregarProveedor;
/* Registar nuevo producto */
CREATE OR REPLACE PROCEDURE RegistrarProducto(
    P_ID_PRODUCTO IN VARCHAR2,
    p_DESCRIPCION IN VARCHAR2,
    p_PRECIO IN NUMBER,
    P_PROOVEDOR IN VARCHAR2,
    P_FECHA_INGRESO IN DATE,
    P_CANTIDAD IN NUMBER
)
IS
BEGIN
    INSERT INTO TBL_PRODUCTOS (ID_PRODUCTO, DESCRIPCION, PRECIO, PROOVEDOR, FECHA_INGRESO, CANTIDAD)
    VALUES (P_ID_PRODUCTO, p_DESCRIPCION, p_PRECIO,P_PROOVEDOR,P_FECHA_INGRESO,P_CANTIDAD);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Producto registrado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al intentar registrar el producto: ' || SQLERRM);
END RegistrarProducto;

/* Consultar productos general */
CREATE OR REPLACE PROCEDURE ConsultarProductos
IS
    CURSOR productos_cursor IS
        SELECT ID_PRODUCTO, DESCRIPCION, PRECIO, PROOVEDOR, CANTIDAD
        FROM TBL_PRODUCTOS;
BEGIN
    FOR producto IN productos_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || producto.ID_PRODUCTO ||', Descripción: ' || producto.descripcion || ', Precio: ' || producto.precio ||',  Cantidad: ' || producto.cantidad);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar consultar los productos: ' || SQLERRM);
END ConsultarProductos;

/* Consultar productos con stock menores a 10 */
CREATE OR REPLACE FUNCTION ProductosMenorA10 RETURN SYS_REFCURSOR IS
    productos_cursor SYS_REFCURSOR;
BEGIN
    OPEN productos_cursor FOR
        SELECT ID_PRODUCTO, DESCRIPCION, PRECIO, PROOVEDOR, CANTIDAD
        FROM TBL_PRODUCTOS
        WHERE CANTIDAD < 10;

    RETURN productos_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar obtener los productos: ' || SQLERRM);
        RETURN NULL;
END ProductosMenorA10;

/* SP que permite disminuir la cantidad de productos dependiendo del id y la cantidad*/
CREATE OR REPLACE PROCEDURE SP_DisminuirCantidadProducto(
    p_id_producto IN VARCHAR2,
    p_cantidad_comprada IN NUMBER
)
IS
    cantidad_actual NUMBER;
BEGIN
    SELECT cantidad
    INTO cantidad_actual
    FROM TBL_PRODUCTOS
    WHERE id_producto = p_id_producto;

    IF cantidad_actual >= p_cantidad_comprada THEN
        UPDATE TBL_PRODUCTOS
        SET cantidad = cantidad_actual - p_cantidad_comprada
        WHERE id_producto = p_id_producto;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Cantidad de producto actualizada exitosamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No hay suficiente cantidad del producto en stock.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el producto con el ID proporcionado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al intentar actualizar la cantidad del producto: ' || SQLERRM);
END DisminuirCantidadProducto;

/* AGREGAR CLIENTE */
CREATE OR REPLACE PROCEDURE SP_AGREGAR_CLIENTE (
    CEDULA IN VARCHAR2,
	CORREO IN VARCHAR2,
	TELEFONO IN VARCHAR2,
	PRIMER_NOMBRE IN VARCHAR2,
	SEGUNDO_NOMBRE IN VARCHAR2,
	PRIMER_APELLIDO IN VARCHAR2,
	SEGUNDO_APELLIDO IN VARCHAR2,
	DIRECCION IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
    -- INSERTAR CLIENTE
	INSERT INTO TBL_CLIENTES
	VALUES (CEDULA, PRIMER_NOMBRE, SEGUNDO_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, DIRECCION);
	-- INSERTAR TELEFONO
	INSERT INTO TBL_TELEFONOS
	VALUES (CEDULA, TELEFONO);
	-- INSERTAR CORREO
	INSERT INTO TBL_CORREOS 
	VALUES (CEDULA, CORREO);
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Cliente agregado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Cliente no agregado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* AGREGAR CORREO CLIENTE */
CREATE OR REPLACE PROCEDURE SP_AGREGAR_CORREO (
    CEDULA IN VARCHAR2,
	CORREO IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- INSERTAR CORREO
	INSERT INTO TBL_CORREOS 
	VALUES (CEDULA, CORREO);
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Correo agregado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Correo no agregado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* ACTUALIZAR CORREO CLIENTE */
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_CORREO (
    CEDULA IN VARCHAR2,
	VIEJO_CORREO IN VARCHAR2,
	NUEVO_CORREO IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- MODIFICAR CORREO
	UPDATE TBL_CORREOS 
	SET CORREO = NUEVO_CORREO
	WHERE ID_USUARIO = CEDULA AND CORREO = VIEJO_CORREO;
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Correo modificado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Correo no modificado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* BORRAR CORREO CLIENTE */
CREATE OR REPLACE PROCEDURE SP_BORRAR_CORREO (
    CEDULA IN VARCHAR2,
	USUARIO_CORREO IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- BORRAR CORREO
	DELETE FROM TBL_CORREOS 
	WHERE ID_USUARIO = CEDULA AND CORREO = USUARIO_CORREO;
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Correo eliminado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Correo no eliminado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* AGREGAR TELEFONO CLIENTE */
CREATE OR REPLACE PROCEDURE SP_AGREGAR_TELEFONO (
    CEDULA IN VARCHAR2,
	TELEFONO IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- INSERTAR TELEFONO
	INSERT INTO TBL_TELEFONOS
	VALUES (CEDULA, TELEFONO);
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Telefonno agregado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Telefonno no agregado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* ACTUALIZAR TELEFONO CLIENTE */
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_TELEFONO (
    CEDULA IN VARCHAR2,
	VIEJO_TELEFONO IN VARCHAR2,
	NUEVO_TELEFONO IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- MODIFICAR TELEFONO
	UPDATE TBL_TELEFONOS
	SET TELEFONO = NUEVO_TELEFONO
	WHERE ID_USUARIO = CEDULA AND TELEFONO = VIEJO_TELEFONO;
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Telefonno modificado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Telefonno no modificado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* BORRAR TELEFONO CLIENTE */
CREATE OR REPLACE PROCEDURE SP_BORRAR_TELEFONO (
    CEDULA IN VARCHAR2,
	VIEJO_TELEFONO IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- MODIFICAR TELEFONO
	DELETE FROM TBL_TELEFONOS
	WHERE ID_USUARIO = CEDULA AND TELEFONO = VIEJO_TELEFONO;
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Telefonno eliminado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Telefonno eliminado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* AGREGAR EMPLEADO */
CREATE OR REPLACE PROCEDURE SP_AGREGAR_EMPLEADO (
    CEDULA IN VARCHAR2,
	PRIMER_NOMBRE IN VARCHAR2,
	SEGUNDO_NOMBRE IN VARCHAR2,
	PRIMER_APELLIDO IN VARCHAR2,
	SEGUNDO_APELLIDO IN VARCHAR2,
	DIRECCION IN VARCHAR2,
	ROL IN VARCHAR2,
	PUESTO IN VARCHAR2,
	SALARIO NUMBER,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
	ID_EMPLEADO VARCHAR2(6);
BEGIN
	ID_EMPLEADO := FUN_CODIGO_EMPLEADO();
    -- INSERTAR CLIENTE
	INSERT INTO TBL_EMPLEADOS
	VALUES (CEDULA, ID_EMPLEADO, PRIMER_NOMBRE, SEGUNDO_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, DIRECCION, PUESTO, SALARIO);
	-- INSERTAR ROL
	INSERT INTO TBL_ROLES_EMPLEADOS
	VALUES (CEDULA, ROL);
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Empleado agregado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Empleado no agregado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* AGREGAR ROLES EMPLEADO */
CREATE OR REPLACE PROCEDURE SP_AGREGAR_ROL (
    CEDULA IN VARCHAR2,
	ROL IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- INSERTAR ROL
	INSERT INTO TBL_ROLES_EMPLEADOS
	VALUES (CEDULA, ROL);
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Rol agregado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Rol no agregado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* ACTUALIZAR ROLES EMPLEADO */
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ROL (
    CEDULA IN VARCHAR2,
	VIEJO_ROL IN VARCHAR2,
	NUEVO_ROL IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- ACTUALIZAR ROL
	UPDATE TBL_ROLES_EMPLEADOS
	SET ID_ROL = NUEVO_ROL
	WHERE ID_EMPLEADO = CEDULA AND ID_ROL = VIEJO_ROL;
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Rol actualizado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Rol no actualizado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

/* BORRAR ROLES EMPLEADO */
CREATE OR REPLACE PROCEDURE SP_BORRAR_ROL (
    CEDULA IN VARCHAR2,
	VIEJO_ROL IN VARCHAR2,
    MSJ_SALIDA OUT VARCHAR2
)
AS
    --
BEGIN
	-- BORRAR ROL
	DELETE FROM TBL_ROLES_EMPLEADOS
	WHERE ID_EMPLEADO = CEDULA AND ID_ROL = VIEJO_ROL;
	COMMIT;
	-- MENSAJE SALIDA
	MSJ_SALIDA := 'Rol borrado exitosamente.';
EXCEPTION
    -- Capturar cualquier excepción y enviar mensaje de error
	WHEN OTHERS THEN
		MSJ_SALIDA := 'Rol no borrado debido a la falla: ' || SQLCODE || '-' || SQLERRM || '.';
END;
/

-- VISTAS
/* DATOS CLIENTE */
CREATE VIEW VST_CLIENTE AS
SELECT C.CEDULA, C.PRIMER_NOMBRE || ' ' || C.PRIMER_APELLIDO AS NOMBRE, C.DIRECCION, CO.CORREO AS CORREOS, T.TELEFONO AS TELEFONOS
FROM TBL_CLIENTES C FULL JOIN
     TBL_CORREOS CO ON C.CEDULA = CO.ID_USUARIO FULL JOIN
     TBL_TELEFONOS T ON C.CEDULA = T.ID_USUARIO;

/* DATOS EMPLEADO */
CREATE VIEW VST_EMPLEADO AS
SELECT E.CEDULA, E.ID_EMPLEADO, E.PRIMER_NOMBRE || ' ' || E.PRIMER_APELLIDO AS NOMBRE, E.DIRECCION, E.PUESTO, E.SALARIO, R.DESCRIPCION AS ROL
FROM TBL_EMPLEADOS E FULL JOIN
     TBL_ROLES_EMPLEADOS RE ON E.CEDULA = RE.ID_EMPLEADO JOIN
     TBL_ROLES R ON RE.ID_ROL = R.ID_ROL;

-- TRIGGERS

-- CURSORES
