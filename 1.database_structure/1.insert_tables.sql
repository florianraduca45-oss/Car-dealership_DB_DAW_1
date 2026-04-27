--------------------------------------------
-- MECHANICS (50)
--------------------------------------------
INSERT INTO MECHANICS
    (mechanic_id, last_name, first_name)
SELECT TOP 10
    CONCAT('MC', FORMAT(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '00')),
    CONCAT('MechanicLast', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('MechanicFirst', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM sys.objects;

--------------------------------------------
-- CARS (300)
--------------------------------------------
INSERT INTO CARS
    (car_id, serial_number, make, model, colour, year, car_for_sale)
SELECT TOP 25
    CONCAT('CAR', FORMAT(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '00')),
    CONCAT('SN', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CHOOSE((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 5)+1, 'Toyota','Ford','BMW','Audi','Honda'),
    CONCAT('Model', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 10),
    CHOOSE((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 5)+1, 'Red','Blue','Black','White','Gray'),
    2015 + (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 10),
    CASE WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 2 = 0 THEN 'Y' ELSE 'N' END
FROM sys.objects;

--------------------------------------------
-- SALESPEOPLE (100)
--------------------------------------------
INSERT INTO SALESPEOPLE
    (salesperson_id, last_name, first_name)
SELECT TOP 5
    CONCAT('SP', FORMAT(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '0')),
    CONCAT('Last', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('First', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM sys.objects;

--------------------------------------------
-- CUSTOMERS (500)
--------------------------------------------
INSERT INTO CUSTOMERS
    (customer_id, last_name, first_name, phone_number, address, city, state_province, country, postal_code)
SELECT TOP 25
    CONCAT('C', FORMAT(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '00')),
    CONCAT('Last', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('First', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('600', FORMAT(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '000000')),
    CONCAT(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), ' Main St'),
    CONCAT('City', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 20),
    CONCAT('State', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 10),
    'Country',
    CONCAT('ZIP', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM sys.objects a CROSS JOIN sys.objects b;

--------------------------------------------
-- SERVICES (10)
--------------------------------------------
INSERT INTO SERVICES
    (service_id, service_name, hourly_rate)
VALUES
    (1, 'Oil Change', 50),
    (2, 'Brakes', 80),
    (3, 'Diagnostics', 100),
    (4, 'Transmission', 120),
    (5, 'Battery', 60),
    (6, 'Tires', 70),
    (7, 'Alignment', 90),
    (8, 'Cooling System', 110),
    (9, 'Suspension', 95),
    (10, 'Electrical', 105);


INSERT INTO PARTS
    (parts_id, part_number, description, purchase_price, retail_price)
SELECT TOP 100
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
    CONCAT('P', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('Part ', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    (ABS(CHECKSUM(NEWID())) % 50) + 5,
    (ABS(CHECKSUM(NEWID())) % 100) + 20
FROM sys.objects;