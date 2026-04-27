/*
======================================================================================================================================================================
EJERCICIOS PARA PRACTICAR QUERIES.
======================================================================================================================================================================

*********************************************************************************************************************************************************************
1.- Lista detallada de los tickets con los dias que han pasado desde la apertura del ticket.
*********************************************************************************************************************************************************************
SELECT 
    service_ticket_id,
    date_received,
    date_returned,
    DATEDIFF(DAY, date_received, ISNULL(date_returned, GETUTCDATE())) AS "Dias Transcurridos",
    CASE 
        WHEN date_returned IS NULL 
        THEN 'EN TALLER' 
        ELSE 'ENTREGADO' 
    END AS Estado
FROM SERVICE_TICKETS
ORDER BY date_received DESC;

-- """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- Si queremos la diferencia realista mejor en minutos. Ejemplo: un coche entra al taller a las 10:55 y sale a las 11:05.
--     SELECT 
--         DATEDIFF(MINUTE, date_received, date_returned) / 60.0 AS Horas_Reales
--     FROM SERVICE_TICKETS;
-- """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

-- DATEDIFF usa 3 parametros:
--    (formato de salida, fecha_inicio, fecha_fin) y devuelve un valor numerico.
--    (HOUR, date_received, ISNULL(date_returned, GETUTCDATE())) 
--    horas -- date_recived -- si el date_returned es NULL, toma como fecha la de hoy.

-- TEST ------------------------------------------------------------------------------------------------------------------------------------------------

-- FECHA EN date_recived.

-- Creo fechas al azar en el date_recived mediante generación aleatoria de un numero de dias, como máximo un año atrás.
-- DATEADD( [Qué vamos a cambiar] , [Cuánto le vamos a sumar/restar] , [A qué fecha se lo aplicamos] )
-- DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETUTCDATE())

UPDATE SERVICE_TICKETS
SET date_received = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETUTCDATE())

-- NEWID(): Genera un identificador único global (GUID), algo como 5A8B9C.... Como siempre es distinto, lo usamos como semilla para nuestro número aleatorio.
-- CHECKSUM(...): Convierte ese texto raro del GUID en un número entero (que puede ser positivo o negativo).
-- ABS(...): Transforma ese número a su Valor Absoluto, asegurándose de que siempre sea positivo.

-- 1.Genero algo aleatorio → NEWID()
-- 2.Lo convierto en número → CHECKSUM()
-- 3.Evito negativos → ABS()
-- 4.Limito rango → % 365
-- 5.Lo hago “hacia atrás” → -
-- 6.Lo aplico a una fecha base → DATEADD(..., GETUTCDATE())


-- FECHA EN date_returned.

WITH TicketsAleatorios AS (
    -- 1. Elegimos qué porcentaje de tickets queremos cerrar (ej. 80%)
    SELECT TOP (60) PERCENT 
        date_received, 
        date_returned
    FROM SERVICE_TICKETS
    WHERE date_returned IS NULL
    ORDER BY NEWID() -- Esto es lo que elige los tickets completamente al azar
)
-- 2. Actualizamos SOLO esos tickets seleccionados
UPDATE TicketsAleatorios
SET date_returned = DATEADD(HOUR, (ABS(CHECKSUM(NEWID())) % 120) + 1, date_received);


-- Poner a NULL date_recived y date_returned.
UPDATE SERVICE_TICKETS
SET date_received = NULL;

UPDATE SERVICE_TICKETS
SET date_returned = NULL;

SELECT * FROM SERVICE_TICKETS;

*********************************************************************************************************************************************************************
2.- Lista de tickets con el número de mecánicos implicados.
*********************************************************************************************************************************************************************
SELECT
    ST.service_ticket_number,
    COUNT(DISTINCT SM.mechanic_id) AS "Numero de Mecánicos"
FROM SERVICE_TICKETS ST
    LEFT JOIN SERVICE_MECHANICS SM 
    ON ST.service_ticket_id = SM.service_ticket_id
GROUP BY ST.service_ticket_number

*********************************************************************************************************************************************************************
3.- Lista de tickets con el número de servicios por ticket
*********************************************************************************************************************************************************************
SELECT
    ST.service_ticket_id,
    COUNT(DISTINCT SM.service_id) AS "Numero de servicios asociados"
FROM SERVICE_TICKETS ST
LEFT JOIN SERVICE_MECHANICS SM 
    ON ST.service_ticket_id = SM.service_ticket_id
GROUP BY 
    ST.service_ticket_id;

-- Partimos de la tabla SERVICE_TICKETS, aunque en la tabla SERVICE_MECHANICS tenemos el service_ticket_id y el service_id, si un ticket no tien un servicio asociado no saldria en la consulta. Para que salgan todos, vamos a buscar la información a la tabla SERVICE_MECHANICS y hacemos un LEFT JOIN que trae toda la información que haga match con la tabla principal en este caso SERVICE_TICKETS y donde no haya match en las dos tablas devolvera un 0. Si el taller permite que distintos mecanicos trabajen en el mismo servicio de un mismo ticket usamos DISTINCT a la hora de contar los servicios asociados al ticket para no repetirlos.

*********************************************************************************************************************************************************************
4- Lista de tickets por cada mecánico
*********************************************************************************************************************************************************************
SELECT 
    M.mechanic_id,
    M.first_name,
    M.last_name,
    COUNT(DISTINCT SM.service_ticket_id) AS "Número de tickets asociados"
FROM MECHANICS M
LEFT JOIN SERVICE_MECHANICS SM 
    ON M.mechanic_id = SM.mechanic_id
GROUP BY 
    M.mechanic_id,
    M.first_name,
    M.last_name;

-- Partimos de la tabla MECHANICS porque queremos ver TODOS los mecánicos que hay en la BD. Nos traemos la información de la tabla SERVICE_MECHANICS que es donde tenemos la información identificativa de los tickets y los mecánicos que es la información que necesitamos mostrar. En este caso COUNT() devuelve un valor 0 porque responde a la pregunta "Cuántos?", si tuviesemos la función AVG(), MAX(), etc. devolvería NULL, para evitarlo, usamos ISNULL(AVG(), 0) de esta forma cuando encuentre un NULL le ñuscará un 0.

*********************************************************************************************************************************************************************
5.- Lista de la cantidad de servicios diferentes realizados por cada mecánico
*********************************************************************************************************************************************************************
SELECT
    COUNT(DISTINCT SM.service_id) AS "Cantidad de servicios distintos",
    M.mechanic_id,
    M.last_name,
    M.first_name
FROM MECHANICS M
    LEFT JOIN SERVICE_MECHANICS SM
    ON M.mechanic_id = SM.mechanic_id
GROUP BY 
    M.mechanic_id,
    M.last_name,
    M.first_name;

-- Partimos de la tabla MECHANICS ya que queremos ver todos los mecánicos. Unimos por la derecha de la tabla principal, MECHANICS, la tabla SERVICE_MECHANICS para acceder a la información de los servicios que ha hecho un mecánico, contamos las ocurrencias de 

*********************************************************************************************************************************************************************
6.- Numero de tickets en cada dia de la semana
*********************************************************************************************************************************************************************
WITH DiasSemana AS (
    -- Creamos nuestra propia lista de los 7 días
    SELECT 1 AS Numero, 'Domingo' AS Nombre UNION ALL
    SELECT 2, 'Lunes' UNION ALL
    SELECT 3, 'Martes' UNION ALL
    SELECT 4, 'Miércoles' UNION ALL
    SELECT 5, 'Jueves' UNION ALL
    SELECT 6, 'Viernes' UNION ALL
    SELECT 7, 'Sábado'
)
SELECT 
    D.Nombre AS "Día de la semana",
    COUNT(S.service_ticket_id) AS "Total de tickets"
FROM DiasSemana D
LEFT JOIN SERVICE_TICKETS S 
    ON DATEPART(WEEKDAY, S.date_received) = D.Numero
GROUP BY 
    D.Nombre, 
    D.Numero
ORDER BY 
    D.Numero;  

-- Creo una tabla virtual con dos columnas, el numero de día y el nombre del día. A partir de aqui utilizo el LEFT JOIN para traerme la información de la tabla SERVICE_TICKETS donde tengo date_recived, quiero saber el número de tickets que entran es decir el volumen de trabajo que tengo cada día de la semana por eso uso el date_recived. La condición del LEFT JOIN es que, mediante la función DATEPART la cual necesita 2 parámetros, el tipo de dato y la columna donde extraer ese dato, coincida con el valor del numero creado en la tabla temporal DiasSemana. SQL Server por defecto cuando hacemos esto cuenta el Domingo como 1 y el Sábado como 7. Como hemos creado una tabla temporal donde hay 7 registros con valores del 1 al 7, el 1 siendo Domingo y 7 siendo Sábado para respetar la metodología del motor de BD, SQL extrae el numero del dia de la semana correspondiente al resultado de la función DATEPART por el WEEKDAY y lo compara a la tabla virtual, cuando encuentra coincidencias lo añade y gracias a eso hace el COUNT.

-- Esta select es para ver como funciona DATEPART, cogemos la columna date_recived de nuestra tabla y le aplicamos el DATEPART para ver el numero del dia que corresponde a la fecha de entrada del ticket.
SELECT
    date_received,
    DATEPART(WEEKDAY, date_received) AS 'Día de la semana'
FROM SERVICE_TICKETS

*********************************************************************************************************************************************************************
7.- Lista de tickets sin servicio asignado
*********************************************************************************************************************************************************************
SELECT
    ST.service_ticket_id
FROM SERVICE_TICKETS ST
LEFT JOIN SERVICE_MECHANICS SM 
    ON ST.service_ticket_id = SM.service_ticket_id
WHERE SM.service_id IS NULL

-- Partimos de la tabla SERVICE_TICKETS porque queremos traernos TODOS los tickets, le adjuntamos la tabla SERVICE_MECHANICS porque en esta tabla estan los tickets que tienen asociado un servicio, service_id. Lo que hacemos con el LEFT JOIN es pegar la tabla SERVICE_MECHANICS por la derecha de la tabla SERVICE_TICKETS con la condicion de que el service_ticket_id coincidan. Si en la tabla SERVICE_MECHANICS no encuentra algun service_ticket_id asociado le pondrá NULL. Por último, filtramos toda la select para atrapar únicamente aquellos service_ticket_id que pegando la tabla SERVICE_MECHANICS al lado tenga valor NULL.
*/

