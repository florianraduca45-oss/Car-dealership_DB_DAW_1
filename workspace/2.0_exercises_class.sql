
-- EJEMPLO DE SUBSELECT.
SELECT 
    *,
    (SELECT 
        TOP 1 make 
    FROM CARS 
    WHERE car_id = ST.car_id) AS marca_coche
FROM SERVICE_TICKETS ST;


-- EJEMPLO JOIN
SELECT 
    C.*,
    ST.*
FROM SERVICE_TICKETS ST, CARS C
WHERE C.car_id = ST.car_id


-- EJEMPLO JOIN
SELECT 
    C.car_id,
    C.make,
    C.model,
    ST.service_ticket_id
FROM SERVICE_TICKETS ST, CARS C
WHERE C.car_id = ST.car_id