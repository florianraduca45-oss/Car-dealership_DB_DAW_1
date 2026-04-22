ALTER PROCEDURE sp_ST_create
    @car_id NVARCHAR(25),
    @customer_id NVARCHAR(25)

as
BEGIN

    declare @error int = -1

    declare @comments NVARCHAR(255)='Hazme la revisión'
    declare @service_ticket_id INTEGER

    select 
        @service_ticket_id = ISNULL(MAX(service_ticket_id), 0) + 1
    from SERVICE_TICKETS

    INSERT INTO SERVICE_TICKETS
        (service_ticket_id, service_ticket_number, car_id, customer_id, date_received, comments)
    VALUES
        (@service_ticket_id, 'STN-' + cast(@service_ticket_id as nvarchar(25)), @car_id, @customer_id, getdate(), @comments)

    if @@rowcount = 1 set @error = 0

    return @error

/*
    car_id
    customer_id

   declare @error int = -1
   exec @error = sp_ST_create 'CAR05', 'C06'
   print @error

   select * from SERVICE_TICKETS
*/
end
GO


-- -- INSERT HARDCODE para hacer prueba de insercion de datos en la tabla SERVICE_TICKETS.
-- INSERT INTO SERVICE_TICKETS
--     (service_ticket_id, service_ticket_number, car_id, customer_id, date_received, comments, date_returned)
-- VALUES
--     ('1', 'ST001', 'CAR03', 'C01', '2026-03-24', 'Reparación 1: Cambio de aceite', NULL )
