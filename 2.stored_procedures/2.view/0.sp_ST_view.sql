ALTER PROCEDURE sp_ST_view
    @service_ticket_id INTEGER
AS
BEGIN

    SELECT * FROM SERVICE_TICKETS WHERE service_ticket_id = @service_ticket_id
    SELECT * FROM SERVICE_MECHANICS WHERE service_ticket_id = @service_ticket_id
    SELECT * FROM PARTS_USED WHERE service_ticket_id = @service_ticket_id

END
GO



