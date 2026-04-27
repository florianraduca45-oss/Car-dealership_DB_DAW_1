ALTER PROCEDURE sp_PA_US_create
    @part_id INTEGER,
    @service_ticket_id INTEGER,
    @number_used INTEGER

as
BEGIN

    declare @error int = -1

    declare @parts_used_id INTEGER
    declare @parts_id INTEGER
    declare @price DECIMAL (10,2)

    -- Primero de TODO, validamos que la pieza exista en la base de datos
    IF @parts_id IS NULL
            BEGIN
        PRINT 'ERROR: La pieza no existe'
        RETURN @error
    END

    IF @service_ticket_id IS NULL
            BEGIN
        PRINT 'ERROR: Ticket de servicio no existe'
        RETURN @error
    END

        -- Generamos el parts_used_id
    SELECT
        @parts_used_id = ISNULL(MAX(parts_used_id), 0) + 1
    FROM PARTS_USED

    INSERT INTO PARTS_USED
        (parts_used_id, part_id, service_ticket_id, number_used, price)
    VALUES
    (@parts_used_id, @parts_id, @service_ticket_id, @number_used, (@number_used*@price))

    if @@rowcount = 1 set @error = 0

    return @error

-- Paràmetres:

-- @part_id INTEGER,
-- @service_ticket_id INTEGER,
-- @number_used INTEGER

/*
   declare @error int =-1
   exec @error = sp_PA_US_create '4', '2', 2
   print @error


   select * from PARTS_USED
*/
end
GO