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

--Restricciones tabla lotes---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE lotes
ADD CONSTRAINT pk_lotes_id_lote PRIMARY KEY (id_lote);

ALTER TABLE lotes
ADD CONSTRAINT chk_lotes_cantidad_disponible CHECK(cantidad_disponible <= cantidad_inicial);

EXEC sp_helpconstraint lotes;

--Restricciones tabla productos-----------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE productos
ADD CONSTRAINT pk_productos_id_producto PRIMARY KEY (id_producto);

ALTER TABLE productos
ADD CONSTRAINT fk_productos_id_c FOREIGN KEY (id_clasificacion) REFERENCES clasificaciones (id_clasificacion);

ALTER TABLE productos
ADD CONSTRAINT chk_productos_cantidad_stock CHECK (cantidad_stock >= 0);

ALTER TABLE productos
ADD CONSTRAINT chk_productos_costo_compra CHECK (costo_compra >= 0);

ALTER TABLE productos
ADD CONSTRAINT chk_productos_costo_venta CHECK (costo_venta >= 0);

ALTER TABLE productos
ADD CONSTRAINT fk_productos_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores (id_proveedor);

ALTER TABLE productos
ADD CONSTRAINT fk_productos_id_lote FOREIGN KEY (id_lote) REFERENCES lotes (id_lote);

EXEC sp_helpconstraint productos;

--Restricciones tabla clientes------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
alter table clientes
add constraint pk_clientes_id_cliente primary key (id_cliente);

alter table clientes
add constraint unique_clientes_telefono unique(telefono);

ALTER TABLE clientes
ADD CONSTRAINT unique_clientes_email UNIQUE(email);

ALTER TABLE clientes
ADD CONSTRAINT chk_clientes_genero CHECK(genero = 'Masculino' OR genero = 'Femenino');

exec sp_helpconstraint clientes;

--Restricciones tabla productos_compras------------------------------------------------------------------------------------------------------------------------------------
alter table productos_compras
add constraint pk_productos_compras_id_producto_compra primary key (id_producto_compra);

alter table productos_compras
add constraint fk_productos_compras_id_producto foreign key (id_producto) references productos (id_producto);

alter table productos_compras
add constraint fk_productos_compras_id_compra foreign key (id_compra) references compras (id_compra);

alter table productos_compras
add constraint chk_productos_compras_cantidad check (cantidad >= 0);

exec sp_helpconstraint productos_compras;