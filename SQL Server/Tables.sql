CREATE DATABASE	la_casa_del_te;

USE la_casa_del_te;

--Tabla trabajadores-------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE trabajadores(
	id_trabajador INTEGER IDENTITY(1,1),
	nombre VARCHAR(20) NOT NULL,
	apellido VARCHAR(30) NOT NULL,
	fecha_contratacion DATE NOT NULL,
	fecha_despido DATE,
	direccion VARCHAR(50) NOT NULL,
	celular VARCHAR(10) NOT NULL,
	referencias VARCHAR(100)
)

-- Creación de la tabla proveedores (suppliers) -----------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE proveedores(
	id_proveedor INTEGER IDENTITY (1,1),
	nombre VARCHAR(20) NOT NULL,
	apellido_paterno VARCHAR (20) NOT NULL,
	apellido_materno VARCHAR (20),
	telefono VARCHAR (10) NOT NULL,
	email VARCHAR (30) NOT NULL,
	calle VARCHAR (25) NOT NULL,
	numero INTEGER NOT NULL, 
	colonia VARCHAR (20),
	ciudad VARCHAR (20) NOT NULL,
	estado VARCHAR(20),
	pais VARCHAR (20),
	codigo_postal VARCHAR (10),
	observaciones VARCHAR(100),
	URL_sitio_web VARCHAR (100),
	nombre_compañia VARCHAR (40) NOT NULL,
	estatus VARCHAR(5)
)

