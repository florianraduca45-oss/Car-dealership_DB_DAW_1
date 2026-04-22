
alter procedure sp_ST_close
    @service_ticket_id int
as
Begin

    declare @error INTEGER = -1

    update SERVICE_TICKETS set date_returned=GETDATE() where service_ticket_id=@service_ticket_id and date_returned is null


    if @@rowcount = 1 set @error = 0

    return @error

END
GO

declare @error int =-1
exec @error = sp_ST_close 3