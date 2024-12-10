--Restricciones tabla trabajadores-----------------------------------------------------------------------------------------------------------------------------
ALTER TABLE trabajadores
ADD CONSTRAINT unique_trabajadores_celular UNIQUE(celular);

ALTER TABLE trabajadores
ADD CONSTRAINT pk_trabajadores_id_trabajador PRIMARY KEY (id_trabajador);

EXEC sp_helpconstraint trabajadores;

-- Modificaciones de la tabla trabajadores-------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE trabajadores
ADD correo VARCHAR(50) NULL;

ALTER TABLE trabajadores
ADD contraseña VARCHAR(50) NULL;