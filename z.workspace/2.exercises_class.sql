
-- EJEMPLO DE SUBSELECT.
SELECT 
    ST.service_ticket_id,
    (SELECT 
        TOP 1 make 
    FROM CARS 
    WHERE car_id = ST.car_id) AS marca_coche
FROM SERVICE_TICKETS ST;


-- EJEMPLO JOIN MI MANERA
SELECT 
    ST.service_ticket_id,
    C.make
FROM SERVICE_TICKETS ST 
LEFT JOIN CARS C
    ON C.car_id = ST.car_id


-- EJEMPLO JOIN (MALA PRÁCTICA, SI TE DEJAS EL WHERE LA HAS C4G4DO)
SELECT 
    ST.service_ticket_id,
    C.make
FROM SERVICE_TICKETS ST, CARS C
WHERE C.car_id = ST.car_id
