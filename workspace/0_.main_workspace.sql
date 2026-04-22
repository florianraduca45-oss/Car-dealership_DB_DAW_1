
print 'Borrando all'
exec sp_adm_ST_DeleteAll


declare @error int =-1
/* ST 1*/
exec @error = sp_ST_Create 'car01', 'c01'
exec @error = sp_SM_Create 1, 1, 'mc01'
-- sticket, service, mecanic


/* ST 2*/
exec @error = sp_ST_Create 'car02', 'c02'
exec @error = sp_SM_Create 2, 1, 'mc01'
-- sticket, service, mecanic
exec @error = sp_SM_Create 2, 2, 'mc02'
-- sticket, service, mecanic


/* ST 3*/
exec @error = sp_ST_Create 'car03', 'c03'
exec @error = sp_SM_Create 3, 1, 'mc03'
-- sticket, service, mecanic
exec @error = sp_SM_Create 3, 2, 'mc04'
-- sticket, service, mecanic


/* ST 4*/
exec @error = sp_ST_Create 'car04', 'c04'
exec @error = sp_SM_Create 4, 3, 'mc04'
-- sticket, service, mecanic
exec @error = sp_SM_Create 4, 4, 'mc04'
-- sticket, service, mecanic


/* ST 5*/
exec @error = sp_ST_Create 'car05', 'c05'
exec @error = sp_SM_Create 5, 1, 'mc04'
-- sticket, service, mecanic
exec @error = sp_SM_Create 5, 4, 'mc04'
-- sticket, service, mecanic


/* ST 6*/
exec @error = sp_ST_Create 'car06', 'c06'


-- exec sp_ST_View 1
-- exec sp_ST_View 2
-- exec sp_ST_View 3
-- exec sp_ST_View 4
-- exec sp_ST_View 5
-- exec sp_ST_View 6


print @error

/*
   select * from v_service_tickets  (Tengo que crear la vista de cada ticket)
   exec sp_adm_InsertTestData (Crear una Procedure para insertar los datos de test)
*/