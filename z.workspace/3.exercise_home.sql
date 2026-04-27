
/*
OPERATIVA:
----------
Le he pasado a Gemini este prompt:
Teniendo en cuenta la estructura de la base de datos que te he dado, y teniendo en cuenta que no tengo ningun dato en SERVICE_TICKETS, SERVICE_MECHANICS, PARTS_USED. NO TENGAS EN CUENTA LA TABLA SALES_INVOICES.
Dame datos de prueba y después ponme 20 preguntas para hacer selects:
- Complejas.
- Con funciones, 10 distintas.
- Subselects/Joins.
*/

-- ********************************************************************************************************************************************************************
-- RESPUESTA:

-- ==========================================
-- 1. POBLAR SERVICE_TICKETS
-- ==========================================
INSERT INTO SERVICE_TICKETS 
    (service_ticket_id, service_ticket_number, car_id, customer_id, date_received, comments, date_returned)
VALUES 
    (1, 'TK-1001', 'CAR01', 'C01', '2023-10-01 08:30:00', 'Revisión general', '2023-10-02 17:00:00'),
    (2, 'TK-1002', 'CAR02', 'C02', '2023-10-03 09:15:00', 'Frenos hacen ruido', '2023-10-03 12:30:00'),
    (3, 'TK-1003', 'CAR03', 'C03', '2023-10-05 16:00:00', 'Problema eléctrico mayor', '2023-10-10 10:00:00'),
    (4, 'TK-1004', 'CAR04', 'C04', '2023-10-15 08:00:00', 'Coche no arranca', NULL), -- Abierto
    (5, 'TK-1005', 'CAR01', 'C01', '2023-10-20 11:45:00', 'Vuelve por pinchazo', '2023-10-21 16:00:00'),
    (6, 'TK-1006', 'CAR05', 'C05', '2023-10-22 14:00:00', 'Cambio de aceite', NULL), -- Abierto
    (7, 'TK-1007', 'CAR02', 'C02', '2023-10-25 09:00:00', 'Problema de transmisión', '2023-10-26 11:00:00'),
    (8, 'TK-1008', 'CAR06', 'C06', '2023-10-28 10:30:00', 'Alineación', NULL); -- Abierto y sin servicios asignados aún

-- ==========================================
-- 2. POBLAR SERVICE_MECHANICS (Asignación)
-- ==========================================
INSERT INTO SERVICE_MECHANICS 
    (service_mechanic_id, service_ticket_id, service_id, mechanic_id, hours, comment, rate)
VALUES
    (1, 1, 1, 'MC01', 1.5, 'Cambio de aceite rápido', 50.00),
    (2, 1, 6, 'MC02', 2.0, 'Cambio de neumáticos', 70.00), -- Ticket 1 atendido por 2 mecánicos
    (3, 2, 2, 'MC03', 3.0, 'Cambio de pastillas', 80.00),
    (4, 3, 10, 'MC01', 8.5, 'Revisión cableado complejo', 105.00),
    (5, 4, 3, 'MC02', 1.5, 'Diagnóstico inicial', 100.00),
    (6, 5, 6, 'MC04', 1.0, 'Parche de rueda', 70.00),
    (7, 6, 1, 'MC01', 0.5, 'Aceite vaciado', 50.00),
    (8, 7, 4, 'MC05', 6.0, 'Ajuste de caja', 120.00);
    -- Ticket 8 a propósito no tiene mecánicos (Huérfano)

-- ==========================================
-- 3. POBLAR PARTS_USED (Piezas consumidas)
-- ==========================================
INSERT INTO PARTS_USED 
    (parts_used_id, part_id, service_ticket_id, number_used, price)
VALUES
    (1, 15, 1, 4, 12.50),  -- 4 piezas en ticket 1
    (2, 42, 1, 1, 45.00),
    (3, 8, 2, 2, 110.00),  -- 2 piezas caras ticket 2
    (4, 99, 3, 1, 250.00), 
    (5, 12, 5, 1, 15.00),
    (6, 55, 7, 3, 85.00); 
    -- Tickets 4, 6 y 8 no tienen piezas

-- ********************************************************************************************************************************************************************
/*
-- Bloque A: Fechas, Tiempos y Rendimiento
1. Tiempo de resolución: Muestra el service_ticket_number y calcula la cantidad de días exactos (DATEDIFF) que tardó en completarse cada ticket cerrado.
*/

SELECT
    service_ticket_number,
    DATEDIFF(DAY, date_received, date_returned) AS Días
FROM SERVICE_TICKETS
WHERE date_returned IS NOT NULL
ORDER BY Días ASC;

/*
2. Tickets estancados: Para los tickets abiertos (sin fecha de retorno), calcula cuántas horas llevan en el taller usando GETDATE().
*/

SELECT
    service_ticket_id,
    DATEDIFF(HOUR, date_received, ISNULL(date_returned, GETUTCDATE())) AS Horas_en_el_taller
FROM SERVICE_TICKETS
WHERE date_returned IS NULL;

/*
3. Análisis mensual: Muestra el nombre del mes (DATENAME) en el que se recibieron los tickets y cuántos tickets se abrieron en cada mes.
*/

SELECT
    DATENAME(MONTH, date_received) AS Mes,
    COUNT(date_received) AS tickets_recibidos
FROM SERVICE_TICKETS
GROUP BY DATENAME(MONTH, date_received)

/*
4. Cierre rápido: Muestra los tickets (ID y número) que se cerraron el mismo día que ingresaron (la diferencia de días es 0).
*/

SELECT
    service_ticket_id,
    service_ticket_number
    -- DATEDIFF(DAY, date_received, date_returned) AS dias_en_taller
FROM SERVICE_TICKETS
WHERE date_returned IS NOT NULL -- Aseguramos que se haya cerrado
    AND DATEDIFF(DAY, date_received, date_returned) = 0;

/*
5. Día más concurrido: Muestra qué día de la semana (DATENAME) ha registrado más entradas de coches al taller en toda la historia.
*/

WITH DiasSemana AS 
    (
        SELECT 1 AS Numero, 'Domingo' AS Nombre UNION ALL
        SELECT 2, 'Lunes' UNION ALL
        SELECT 3, 'Martes' UNION ALL
        SELECT 4, 'Miércoles' UNION ALL
        SELECT 5, 'Jueves' UNION ALL
        SELECT 6, 'Viernes' UNION ALL
        SELECT 7, 'Sábado'
    )
SELECT TOP 1
    D.Nombre AS Dia_Semana,
    COUNT(S.service_ticket_id) AS Total_Entradas
FROM DiasSemana D
JOIN SERVICE_TICKETS S 
    ON D.Numero = DATEPART(WEEKDAY, S.date_received) -- Aquí está la clave
GROUP BY 
    D.Nombre, 
    D.Numero
ORDER BY Total_Entradas DESC;

-- ********************************************************************************************************************************************************************
/*
Bloque B: Costes, Piezas y Facturación
Coste total de piezas por ticket: Muestra todos los tickets y la suma del coste total en piezas (number_used * price). Si un ticket no usó piezas, debe mostrar 0.00 usando ISNULL().

Ingresos por mano de obra: Calcula el ingreso generado por mano de obra por cada ticket (multiplicando hours por rate en la tabla SERVICE_MECHANICS).

Factura global: Crea una consulta que muestre en una sola fila por ticket cerrado: El número de ticket, el costo total de piezas y el costo total de mano de obra. (Requiere subconsultas o sumar tras agrupar).

Filtro de alto valor: Muestra los IDs de los tickets cuyo gasto total en piezas sea estrictamente mayor al promedio (AVG()) de gasto en piezas de todo el taller.

Inventario inactivo: Encuentra las piezas (tabla PARTS) que nunca se han utilizado en ningún ticket (Anti-Join).


-- ********************************************************************************************************************************************************************
Bloque C: Productividad de los Mecánicos
Horas trabajadas: Muestra el nombre y apellido de cada mecánico y el total de horas que han facturado. Los mecánicos que no han trabajado deben mostrar 0.

Mecánicos sin trabajo: Muestra únicamente a los mecánicos registrados en la base de datos que no tienen asignado ningún servicio en SERVICE_MECHANICS.

Trabajo en equipo: Muestra los service_ticket_number que han requerido la intervención de más de un mecánico diferente (COUNT con HAVING).

El más rápido: ¿Qué mecánico (mechanic_id) ha registrado el servicio con la menor cantidad de horas en un solo registro? (Usa subconsulta o TOP 1).

Productividad por servicio: Muestra el nombre del servicio (service_name de SERVICES) y la cantidad de horas totales que todos los mecánicos han invertido en él históricamente.


-- ********************************************************************************************************************************************************************
Bloque D: Clientes, Coches y Formateo (Cadenas)
Historial de clientes: Muestra el nombre completo del cliente (CONCAT(first_name, ' ', last_name)) y cuántos tickets ha abierto en el taller.

Coches conflictivos: Muestra la marca (make) y el modelo (model) de los coches que han entrado al taller más de una vez.

Reporte estandarizado: Genera una sola columna de texto que diga exactamente: "El coche [MARCA EN MAYÚSCULAS] del cliente [Apellido] ingresó por un problema de: [comentarios]". (Usa UPPER() y CONCAT()).

El coche que más gastó: Muestra la matrícula (car_id) del coche que ha generado el ticket con el costo de piezas más alto de la base de datos (Usa MAX en una subconsulta).

Auditoría de tickets: Muestra los tickets que han sido recibidos, pero que no tienen ningún servicio asignado ni piezas consumidas (Tu reporte definitivo de tareas pendientes).
*/
