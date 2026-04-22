ALTER PROCEDURE sp_SM_create
    @service_ticket_id INTEGER,
    @service_id INTEGER,
    @mechanic_id NVARCHAR(25)

as
BEGIN

    declare @error int = -1

    declare @service_mechanic_id INTEGER
    declare @comment NVARCHAR(25)= 'SIN COMENTARIOS.'
    declare @rate FLOAT
    declare @hours FLOAT= NULL 

    -- Generamos el service_mechanid_id
    SELECT 
        @service_mechanic_id = ISNULL(MAX(service_mechanic_id) ,0) + 1
    FROM SERVICE_MECHANICS

    SELECT 
        @hours = service_ticket_id * 2
    FROM SERVICE_MECHANICS
    

    -- Validamos que el service_id exista, si introducimos un servicio que no exista en la base de datos, darà un error.
    IF @service_id IS NULL
        BEGIN
        PRINT 'ERROR: Servicio no existe'
        RETURN @error
    END

    INSERT INTO SERVICE_MECHANICS
        (service_mechanic_id, service_ticket_id, service_id, mechanic_id, hours, comment, rate)
    VALUES
    (@service_mechanic_id, @service_ticket_id, @service_id, @mechanic_id, @hours, @comment, @rate)


    if @@rowcount = 1 set @error = 0

    return @error

-- Paràmetres:

-- service_ticket_id 
-- service_id
-- mechanic_id 
-- hours 

/*
   declare @error int =-1
   exec @error = sp_SM_create 3, 2, 'MC04' 
   print @error

   select * from SERVICE_MECHANICS
*/
end
GO

-- INSERT INTO [dbo].[SERVICE_MECHANICS]
--     ([service_mechanic_id], [service_ticket_id], [service_id], [mechanic_id], [hours], [comment], [rate])
-- VALUES
--     (1, 1, 1, N'MC01', CAST(2 AS DECIMAL(5, 2)), N'hola', CAST(100 AS DECIMAL(10, 2)))




UPDATE SERVICE_MECHANICS
SET rate = rate + 10



SELECT
    DISTINCT(service_ticket_id),
    SUM(hours * rate)
FROM SERVICE_MECHANICS
GROUP BY service_ticket_id

GO
CREATE VIEW v_tickets_cost
AS
SELECT 
    service_ticket_id,
    SUM(hours * rate) AS total_cost
FROM SERVICE_MECHANICS
GROUP BY service_ticket_id
GO


SELECT * FROM v_tickets_cost;

