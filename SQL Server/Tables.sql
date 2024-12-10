CREATE DATABASE	la_casa_del_te;

USE la_casa_del_te;

--Creación de la tabla trabajadores-------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE trabajadores(
	id_trabajador INTEGER IDENTITY(1,1),
	nombre VARCHAR(20) NOT NULL,
	apellido_paterno VARCHAR(20) NOT NULL,
	apellido_materno VARCHAR(20),
	curp VARCHAR(20),
	fecha_nacimiento DATE NOT NULL,
	genero VARCHAR(10),
	estado_civil VARCHAR(20),
	calle VARCHAR(25) NOT NULL,
	numero INTEGER NOT NULL, 
	colonia VARCHAR (20),
	ciudad VARCHAR (20) NOT NULL,
	estado VARCHAR(20),
	pais VARCHAR (20),
	codigo_postal VARCHAR (10),
	nivel_educativo VARCHAR(20),
	fecha_contratacion DATE NOT NULL,
	puesto VARCHAR(15),
	salario_base REAL,
	tipo_contrato VARCHAR(20),
	fecha_despido DATE,
	motivo_despido VARCHAR(50),
	telefono VARCHAR(10) NOT NULL,
	email VARCHAR(30) NOT NULL,
	referencias VARCHAR(100),
	estatus BIT,
	numero_seguro_social VARCHAR(15),
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

--Creación de la tabla  jornadas------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE jornadas(
	id_jornada INTEGER IDENTITY(1,1),
	hora_inicio TIME(0) NOT NULL,
	hora_fin TIME(0) NOT NULL,
	duracion REAL,
	tipo VARCHAR(20),
	estado VARCHAR(20) NOT NULL,
	descanso REAL,
	notas VARCHAR(100)
)

--Creación de la tabla  trabajadores-jornadas------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE trabajadores_jornadas(
	id_trabajador_jornada INTEGER IDENTITY(1,1) NOT NULL,
	id_trabajador INTEGER NOT NULL,
	id_jornada INTEGER NOT NULL,
	fecha DATE NOT NULL
)

