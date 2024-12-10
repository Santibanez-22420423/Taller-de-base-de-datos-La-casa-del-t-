-------------------------------------------------------
                --Procedimientos--
-------------------------------------------------------

--1 Procedimiento para realizar una compra.
    --1.1 Realizar la orden de la compra.
    CREATE PROCEDURE realizar_compra 
        @id_proveedor NUMERIC, 
        @metodo_pago NVARCHAR(20),
        @id_compra INT OUTPUT -- Parámetro de salida para devolver el ID de la orden
    AS
    BEGIN
        -- 1. Verificar que exista el proveedor.
        IF EXISTS (SELECT 1 FROM proveedores WHERE id_proveedor = @id_proveedor)
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;
                
                -- Crear la orden de compra.
                INSERT INTO compras (id_proveedor, fecha, metodo_pago, fecha_entrega)
                VALUES (@id_proveedor, GETDATE(), @metodo_pago, DATEADD(day, 10, GETDATE()));

                -- Obtener el ID generado para la compra.
                SET @id_compra = SCOPE_IDENTITY();

                -- Confirmar la transacción.
                COMMIT TRANSACTION;
            END TRY
            BEGIN CATCH
                -- En caso de error, revertir la transacción y propagar el error.
                ROLLBACK TRANSACTION;
                SET @id_compra = NULL;
                THROW;
            END CATCH;
        END
        ELSE
        BEGIN
            -- Si el proveedor no existe, devolver NULL.
            SET @id_compra = NULL;
        END
    END;

    --1.2 Realizar los detalles de la compra.
    CREATE PROCEDURE insertar_detalles_productos_compras @id_compra_1 NUMERIC, @id_producto NUMERIC, @cantidad NUMERIC, @unitario NUMERIC
    AS
    BEGIN
        --Verificar que exista el id de la orden.
        IF EXISTS (SELECT 1 FROM compras WHERE id_compra = @id_compra_1)
        BEGIN
            IF EXISTS (SELECT 1 FROM productos WHERE id_producto = @id_producto)
            BEGIN
                BEGIN TRANSACTION
                BEGIN TRY
                        --Insertar el detalle.
                        INSERT INTO productos_compras (id_compra, id_producto, cantidad, unitario)
                        VALUES (@id_compra_1, @id_producto, @cantidad, @unitario);
                        -- Si todo está bien, confirmar la transacción
                        COMMIT TRANSACTION;
                            PRINT 'Detalle de compra creada exitosamente.';
                END TRY
                BEGIN CATCH
                    -- Manejo de errores
                    ROLLBACK TRANSACTION;
                    PRINT error_message();
                END CATCH;
            END
            ELSE
            BEGIN
                RAISERROR ('El producto no existe, puedes intentar registralo primero', 16, 1);
            END
        END
        ELSE
        BEGIN
            RAISERROR ('La orden no existe', 16, 1);
        END
    END;

--Uso de los procedimientos para realizar una compra.
    -- Declarar una variable para almacenar el ID de la compra
    DECLARE @id_compra INT;

    -- Llamar al procedimiento almacenado
    EXEC realizar_compra
        @id_proveedor = 2,       -- Reemplaza con el ID del proveedor deseado
        @metodo_pago = 'Efectivo', -- Reemplaza con el método de pago deseado
        @id_compra = @id_compra OUTPUT; -- Captura el ID generado como salida

    -- Verificar el resultado
    IF @id_compra IS NOT NULL
        PRINT 'La compra se realizó con éxito. ID de la compra: ' + CAST(@id_compra AS NVARCHAR);
    ELSE
        PRINT 'No se pudo realizar la compra. Verifica los datos.';

    --Este punto se ejecuta con tantos productos que correspondan a la compra que se realiza para esa orden.
    EXEC insertar_detalles_productos_compras @id_compra_1 = 22, @id_producto = 18, @cantidad = 2, @unitario = 89.0;

    SELECT * FROM compras;
    SELECT * FROM productos_compras;
    SELECT * FROM productos;

SELECT * FROM devoluciones_compras

--2 Procedimiento para realizar una devolución sobre compra.
CREATE PROCEDURE insertar_devolucion_compras 
    @id_compra NUMERIC,
    @id_producto NUMERIC,
    @cantidad NUMERIC
AS
BEGIN
    --Verificar que exista el id de la orden.
    IF EXISTS (SELECT 1 FROM compras WHERE id_compra = @id_compra)
    BEGIN
		IF EXISTS (SELECT 1 FROM productos WHERE id_producto = @id_producto)
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
					 --Insertar la devolución.
					 INSERT INTO devoluciones_compras (id_compra, id_producto, fecha, cantidad)
					 VALUES (@id_compra, @id_producto, getdate(), @cantidad);
					 -- Si todo está bien, confirmar la transacción
					COMMIT TRANSACTION;
						PRINT 'Devolución de compra creada exitosamente.';
			END TRY
			BEGIN CATCH
				-- Manejo de errores
				ROLLBACK TRANSACTION;
				PRINT error_message();
			END CATCH;
		END
		ELSE
		BEGIN
			RAISERROR ('El producto no existe, puedes intentar registralo primero', 16, 1);
		END
	END
	ELSE
	BEGIN
		RAISERROR ('La orden no existe', 16, 1);
	END
    END;

EXEC  insertar_devolucion_compras @id_compra  = 22, @id_producto = 18, @cantidad = 1;

--3 Simulación del carrito de los clientes.
    --Tabla carrito
    create table carritos(
        id_carrito integer identity(1,1) primary key (id_carrito),
        id_cliente integer not null,
        id_producto integer not null,
        cantidad integer not null,
        unitario money null,
        subtotal money null,
        desc_porcentaje integer null,
        desc_pesos money null,
        subtotal_con_desc money null,
    );

    create trigger trg_pasar_valores_carrito
    on carritos
    after insert
    as
    begin
        declare @id_producto integer, @unitario money, @id_carrito integer, @desc_porcentaje integer, @id_cliente integer;

        -- Obtener el id_producto de la tabla inserted
        select @id_producto = i.id_producto, @id_carrito = i.id_carrito, @id_cliente = i.id_cliente
        from inserted i;

        -- Obtener el precio actual del producto
        select @unitario = precio
        from productos
        where id_producto = @id_producto;

        select @desc_porcentaje = descuento
        from clientes
        where id_cliente = @id_cliente;

        begin
        update carritos
        set subtotal = @unitario * cantidad, unitario = @unitario, desc_porcentaje = @desc_porcentaje
        where id_producto = @id_producto and id_carrito = @id_carrito;
        end
        begin
        update carritos
            set desc_pesos = subtotal * desc_porcentaje / 100
            where id_producto = @id_producto and id_carrito = @id_carrito;
        end
        begin
        update carritos
            set subtotal_con_desc = subtotal - desc_pesos
            where id_producto = @id_producto and id_carrito = @id_carrito;
        end
    end;


    select * from clientes
    select * from productos
    select * from carritos

    insert into carritos (id_cliente, id_producto, cantidad)
    values (1, 1, 1);
    insert into carritos (id_cliente, id_producto, cantidad)
    values (1, 17, 1);
    insert into carritos (id_cliente, id_producto, cantidad)
    values (1, 15, 5);

------------------------------------------------------------------------------------------------------------------------------------------
--4 Procedimiento para realizar una venta.
create procedure realizar_venta @id_cliente numeric, @id_trabajador numeric, @metodo_pago nvarchar(20)
as
begin

	-- 1. Verificar que exista el cliente.
	if exists (select 1 from clientes where id_cliente = @id_cliente)
	begin
		if exists (select 1 from trabajadores where id_trabajador = @id_trabajador)
		begin
			begin transaction;

			begin try
				-- 2. Crear la orden de venta.
				insert into ventas (id_cliente,id_trabajador, fecha, metodo_pago)
				values (@id_cliente, @id_trabajador, getdate(), @metodo_pago);

				-- Si todo está bien, confirmar la transacción
				commit transaction;
				print 'Orden de venta creada exitosamente.';
			end try
			begin catch
				-- Manejo de errores
				rollback transaction;
				print error_message();
			end catch;
		end
		else
		begin
			raiserror ('El trabajador no existe.', 16, 1);
		end
	end
	else
	begin
		raiserror ('El proveedor no existe.', 16, 1);
		end
end;

--5 Procedimiento para realizar la inserción en la tabla productos_ventas con los datos de carrito.

exec realizar_venta @id_cliente = 1, @id_trabajador = 2, @metodo_pago = 'Contado'
select * from trabajadores
select * from ventas

create or alter procedure sp_insertar_productos_ventas @id_venta numeric, @id_cliente numeric
as
declare @cantidad integer, @id_producto integer;
begin
		--Buscar los datos del cliente.
		if exists (select 1 from clientes where id_cliente = @id_cliente)
		begin
		begin transaction
		begin try
			select  top (1) @cantidad = cantidad, @id_producto = id_producto from carritos where id_cliente = @id_cliente;
			--Obtener los productos de la tabla carrito que pertenecen al cliente.
			insert into productos_ventas (id_venta, id_producto, cantidad)
			values (@id_venta, @id_producto, @cantidad);
			--Eliminar los productos del carrito pertenecientes al cliente.
			delete from carritos where id_cliente = @id_cliente and id_producto = @id_producto;
		commit transaction
		end try
		begin catch
			rollback transaction;
			print error_message();
		end catch;
		end
		else
		begin
			raiserror( 'El cliente no existe', 16, 1);
		end
	end;

	exec sp_insertar_productos_ventas @id_venta = 16, @id_cliente = 1;
