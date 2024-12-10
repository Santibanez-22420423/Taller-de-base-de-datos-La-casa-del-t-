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

--Restricciones de la tabla trabajadores-jornadas (workers-days)------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE trabajadores_jornadas
ADD CONSTRAINT pk_trabajadores_jornadas_id_trabajador_jornada PRIMARY KEY (id_trabajador_jornada);

ALTER TABLE trabajadores_jornadas
ADD CONSTRAINT fk_trabajadores_jornadas_id_trabajador FOREIGN KEY (id_trabajador) REFERENCES trabajadores (id_trabajador);

ALTER TABLE trabajadores_jornadas
ADD CONSTRAINT fk_trabajadores_jornadas_id_jornada FOREIGN KEY (id_jornada) REFERENCES jornadas (id_jornada);

EXEC sp_helpconstraint trabajadores_jornadas;

--Restricciones tabla clasificaciones----------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE clasificaciones
ADD CONSTRAINT pk_clasificaciones_id_clasificacion PRIMARY KEY (id_clasificacion);

EXEC sp_helpconstraint clasificaciones;

--Restricciones tabla compras --------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE compras
ADD CONSTRAINT pk_compras_id_compra PRIMARY KEY (id_compra);

ALTER TABLE compras
ADD CONSTRAINT fk_compras_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor);

ALTER TABLE compras
ADD CONSTRAINT chk_compras_metodo_pago CHECK(metodo_pago = 'Tarjeta' OR metodo_pago = 'Efectivo' OR metodo_pago = 'Mixto')

EXEC sp_helpconstraint compras;