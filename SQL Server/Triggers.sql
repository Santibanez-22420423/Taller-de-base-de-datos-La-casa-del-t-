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
