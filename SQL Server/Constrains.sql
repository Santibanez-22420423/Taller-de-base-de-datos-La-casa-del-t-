--Restricciones tabla trabajadores-----------------------------------------------------------------------------------------------------------------------------
--Restricciones de la tabla trabajdores (workers)------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE trabajadores
ADD CONSTRAINT pk_trabajadores_id_trabajador PRIMARY KEY (id_trabajador);

ALTER TABLE trabajadores
ADD CONSTRAINT unique_trabajadores_telefono UNIQUE(telefono);

ALTER TABLE trabajadores
ADD CONSTRAINT unique_trabajadores_email UNIQUE(email);

ALTER TABLE trabajadores
ADD CONSTRAINT unique_trabajadores_curp UNIQUE(curp);

ALTER TABLE trabajadores
ADD CONSTRAINT unique_trabajadores_numero_seguro_social UNIQUE(numero_seguro_social);

ALTER TABLE trabajadores
ADD CONSTRAINT chk_trabajadores_genero CHECK(genero = 'Masculino' OR genero = 'Femenino');

ALTER TABLE trabajadores
ADD CONSTRAINT chk_trabajadores_puesto CHECK(puesto = 'Jefe' OR puesto = 'Gerente' OR puesto = 'Vendedor' OR puesto = 'Cajero');

ALTER TABLE trabajadores
ADD CONSTRAINT chk_trabajadores_tipo_contrato CHECK(tipo_contrato = 'Mensual' OR tipo_contrato = 'Temporal' OR tipo_contrato = 'Trimestral' 
    OR tipo_contrato = 'Anual' OR tipo_contrato = 'Permanente');

EXEC sp_helpconstraint trabajadores;

--Restricciones de la tabla proveedores (suppliers)------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE proveedores
ADD CONSTRAINT pk_proveedores_id_proveedor PRIMARY KEY (id_proveedor);

ALTER TABLE proveedores
ADD CONSTRAINT unique_proveedores_phone UNIQUE(telefono);

ALTER TABLE proveedores
ADD CONSTRAINT unique_proveedores_email UNIQUE(email);

EXEC sp_helpconstraint proveedores;

--Restricciones de la tabla jornadas (days)------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE jornadas
ADD CONSTRAINT pk_jornadas_id_jornada PRIMARY KEY (id_jornada);

ALTER TABLE jornadas
ADD CONSTRAINT chk_jornadas_tipo CHECK(tipo = 'Matutino' OR tipo = 'Vespertino' OR tipo = 'Tiempo completo' OR tipo = 'Mixto');

EXEC sp_helpconstraint jornadas;