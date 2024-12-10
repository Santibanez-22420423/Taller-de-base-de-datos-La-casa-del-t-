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

--Triggers tabla devoluciones_compras-------------------------------------------------------------------------------------------------------------
-- Verificar que exista la cantidad a devolver de la compra realizada.

create trigger trg_cantidad_devolucion_compra
on devoluciones_compras
instead of insert
as
begin  
    declare @id_producto integer, @cantidad integer, @comprados integer, @id_compra integer;

    -- Obtener el id_producto y la cantidad de la tabla inserted que son los datos de devoluciones_compras.
    select @id_producto = i.id_producto, @cantidad = i.cantidad, @id_compra = i.id_compra
    from inserted i;


	--saca la cantidad desde la tabla de productos_compras para verificar que no sea mayor a la cantidad comprada.
    -- Obtener la cantidad de productos de la compra.
    select @comprados = cantidad
    from productos_compras
    where id_producto = @id_producto and id_compra = @id_compra;

    -- Verificar si hay suficiente existencia.
    if @cantidad <= @comprados
    begin
        -- Si hay comprados suficientes para la devolución, realizar la inserción.
        insert into devoluciones_compras ( id_compra, id_producto, fecha, cantidad, unitario)
        select id_compra, id_producto, fecha, cantidad, unitario
        from inserted;

        -- Actualizar la existencia del producto.
        update productos
        set cantidad_stock = cantidad_stock - @cantidad
        where id_producto = @id_producto;
    end
    else
    begin
        -- Si no hay suficiente cantidad de comprados para la devolución, lanzar un error.
        raiserror('No es posible realizar la devolución sobre compra: cantidad a devolver excede la cantidad comprada.', 16, 1);
    end
end;

--Calcular el valor del reembolso.
  CREATE TRIGGER trg_calcular_reembolso
	ON devoluciones_compras
	AFTER INSERT
	AS
	BEGIN
		-- Actualizar el reembolso en devoluciones_compras
		UPDATE devoluciones_compras
		SET reembolso = i.cantidad * i.unitario
		FROM devoluciones_compras
		JOIN inserted i ON devoluciones_compras.id_producto = i.id_producto;
	END;

--Pasar el valor de costo de la tabla productos asignándolo a el atributo unitario de la tabla devoluciones_compras.

CREATE TRIGGER trg_DarAUnitarioValorDevCompra
ON devoluciones_compras
AFTER INSERT
AS
BEGIN
    DECLARE @id_producto INTEGER, @unitario MONEY, @cantidad INTEGER;

    -- Obtener el id_producto y la cantidad de la tabla inserted
    SELECT @id_producto = i.id_producto, @cantidad = i.cantidad
    FROM inserted i;

    -- Obtener el costo actual del producto
    SELECT @unitario = costo_venta
    FROM productos
    WHERE id_producto = @id_producto;

    -- Actualizar la tabla devoluciones_compras con el reembolso y el unitario
    UPDATE dc
    SET dc.reembolso = @unitario * @cantidad, 
        dc.unitario = @unitario
    FROM devoluciones_compras dc
    INNER JOIN inserted i ON dc.id_devolucion_compra = i.id_devolucion_compra;
END;