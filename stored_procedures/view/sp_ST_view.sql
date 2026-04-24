CREATE PROCEDURE sp_ST_view
    @car_id INTEGER
AS
BEGIN

    SELECT * FROM SERVICE_TICKETS WHERE service_ticket_id = @car_id
    SELECT * FROM SERVICE_MECHANICS WHERE service_ticket_id = @car_id

END
GO



