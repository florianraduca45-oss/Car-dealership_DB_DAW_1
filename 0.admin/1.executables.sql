-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- sp_adm_ST_DeleteAll.
-- Borrar todos los tickets. --

Tablas: SERVICE_TICKETS, SERVICE_MECHANICS y PARTS_USED

DECLARE @ERROR INTEGER = -1
EXEC sp_adm_ST_DeleteAll
PRINT @@ERROR
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- sp_ST_view.
-- Ver los tickets y su información asociada. --

Tablas: SERVICE_TICKETS, SERVICE_MECHANICS Y PARTS_USED
NECESITA: service_ticket_id.

EXEC sp_ST_view 1
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- sp_ST_close.
-- Cerrar un ticket, cuando sale del taller. --

Tablas: SERVICE_TICKETS
NECESITA: service_ticket_id

DECLARE @ERROR INTEGER = -1
EXEC sp_ST_close 3
PRINT @ERROR
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- sp_view_1
-- Ver toda la información de SERVICE_TICKETS, SERVICE_MECHANICS y PARTS_USED

Tablas: SERVICE_TICKETS, SERVICE_MECHANICS y PARTS_USED

EXEC sp_view_1
*/