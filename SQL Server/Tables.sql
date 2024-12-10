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


