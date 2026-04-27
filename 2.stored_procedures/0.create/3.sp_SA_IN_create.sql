ALTER PROCEDURE sp_SA_IN_create
    @car_id NVARCHAR(25),
    @customer_id NVARCHAR(25),
    @salesperson_id NVARCHAR(25)

as
BEGIN

    declare @error int = -1
    declare @date_returned DATETIME

    declare @invoice_id INTEGER

    SELECT 
        date_returned = @date_returned
    FROM SERVICE_TICKETS
    WHERE @car_id = car_id

    if @date_returned = NULL return @error

    -- Seleccionamos el ultimo invoice_id y le sumamos + 1 para generar el nuevo invoice_id, si el registro es NULL crea el invoice_id
    SELECT 
        @invoice_id = ISNULL(MAX(invoice_id), 0) + 1
    FROM SALES_INVOICES

    INSERT INTO SALES_INVOICES
        (invoice_id, invoice_number, date, car_id, customer_id, salesperson_id)
    VALUES
    (@invoice_id, 'IN-'+ cast(@invoice_id as nvarchar(25)), GETDATE(), @car_id, @customer_id, @salesperson_id)


    if @@rowcount = 1 set @error = 0

    return @error

-- Parámetros:

-- @car_id NVARCHAR(25)
-- @customer_id NVARCHAR(25)
-- @salesperson_id NVARCHAR(25)

/*
   declare @error int = -1
   exec @error = sp_SA_IN_create 'CAR02', 'C05', 'SP1'
   print @error


   select * from SALES_INVOICES
*/
end
GO