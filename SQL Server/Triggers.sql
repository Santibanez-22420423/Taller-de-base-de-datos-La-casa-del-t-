--Trigger tabla productos_compras----------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER trg_cantidad_comprados
ON productos_compras
AFTER INSERT
AS
BEGIN  
    DECLARE @id_producto INTEGER, @cantidad INTEGER, @id_lote INTEGER;

    -- Obtener el id_producto y la cantidad de la tabla inserted (productos_compras).
    SELECT @id_producto = i.id_producto, @cantidad = i.cantidad
    FROM inserted i;

    BEGIN
        -- Actualizar la existencia del producto en la tabla productos.
        UPDATE productos
        SET cantidad_stock = cantidad_stock + @cantidad
        WHERE id_producto = @id_producto;

        -- Obtener el id_lote correspondiente al producto.
        SELECT @id_lote = id_lote
        FROM productos
        WHERE id_producto = @id_producto;

        -- Actualizar la cantidad_disponible en la tabla lotes usando id_lote.
        UPDATE lotes
        SET cantidad_disponible = cantidad_disponible + @cantidad
        WHERE id_lote = @id_lote;
    END
END;

--Calcular el valor del subtotal.
  CREATE TRIGGER trg_calcular_precio
	ON productos_compras
	AFTER INSERT
	AS
	BEGIN
		-- Actualizar el subtotal en productos_compras
		UPDATE productos_compras
		SET subtotal = i.cantidad * i.unitario
		FROM productos_compras productos_compras
		JOIN inserted i ON productos_compras.id_producto = i.id_producto;
	END;

--Trigger tabla productos_ventas--------------------------------------------------------------------------------------------------------------------------------------
 -- Verificar que exista la cantidad de productos a vender.

CREATE TRIGGER trg_existencia_para_ventas
ON productos_ventas
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_producto INT;

    -- Obtener el id_producto de la tabla inserted
    SELECT @id_producto = i.id_producto
    FROM inserted i;

    -- Actualizar cantidad_stock en productos después de la venta
    UPDATE p
    SET p.cantidad_stock = p.cantidad_stock - pv.cantidad
    FROM productos_ventas pv
    INNER JOIN productos p
    ON p.id_producto = pv.id_producto
    WHERE pv.id_producto = @id_producto;
END;


-- Pasar el valor de precio de la tabla productos asignándolo a el atributo unitario de la tabla productos_ventas.

create trigger trg_DarAUnitarioValor
on productos_ventas
after insert
as
begin
    declare @id_producto integer, @unitario money;

    -- Obtener el id_producto de la tabla inserted
    select @id_producto = i.id_producto
    from inserted i;

    -- Obtener el precio actual del producto
    select @unitario = costo_venta
    from productos
    where id_producto = @id_producto;


    update productos_ventas
	set subtotal = @unitario * cantidad, unitario = @unitario
	where id_producto = @id_producto
  
  end;

--Pasar el valor de descuento de la tabla clientes a desc_porcentaje de productos_ventas, además calcular los campos de desc_pesos y subtotal_con_desc.
 CREATE TRIGGER trg_calculo_subtotal_productos_ventas
ON productos_ventas
AFTER INSERT, UPDATE
AS
BEGIN
  DECLARE @id_producto INT;

  -- Obtener el id_producto de la tabla inserted
  SELECT @id_producto = i.id_producto
  FROM inserted i;

  -- Calcular el subtotal con los campos cantidad y unitario
  UPDATE productos_ventas
  SET subtotal = cantidad * unitario
  WHERE id_producto = @id_producto;
END;
