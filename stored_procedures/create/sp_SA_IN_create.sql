CREATE PROCEDURE sp_SA_IN_create
    @car_id NVARCHAR(25),
    @customer_id NVARCHAR(25),
    @salesperson_id NVARCHAR(25)

as
BEGIN

    declare @error int = -1

    declare @invoice_id INTEGER

    -- Seleccionamos el ultimo invoice_id y le sumamos + 1 para generar el nuevo invoice_id
    SELECT TOP 1
        @invoice_id = invoice_id + 1
    FROM SALES_INVOICES
    ORDER BY invoice_id DESC

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


INSERT INTO [dbo].[SALES_INVOICES]
    ([invoice_id], [invoice_number], [date], [car_id], [customer_id], [salesperson_id])
VALUES
    (1, N'IN-1', N'2026-03-29 00:00:00', N'CAR03', N'C01', N'SP5')