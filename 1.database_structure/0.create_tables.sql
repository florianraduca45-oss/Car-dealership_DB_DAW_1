CREATE DATABASE AURELIANO;

USE AURELIANO;

-- =========================
-- TABLE: SALESPERSON
-- =========================
CREATE TABLE SALESPEOPLE 
(
    salesperson_id      NVARCHAR(50)    PRIMARY KEY,
    last_name           NVARCHAR(50),
    first_name          NVARCHAR(50),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255))
);

-- =========================
-- TABLE: CUSTOMER
-- =========================
CREATE TABLE CUSTOMERS
(
    customer_id         NVARCHAR(50)    PRIMARY KEY,
    last_name           NVARCHAR(50),
    first_name          NVARCHAR(50),
    phone_number        NVARCHAR(20),
    address             NVARCHAR(100),
    city                NVARCHAR(50),
    state_province      NVARCHAR(50),
    country             NVARCHAR(50),
    postal_code         NVARCHAR(20),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255))
);

-- =========================
-- TABLE: CAR
-- =========================
CREATE TABLE CARS
(
    car_id              NVARCHAR(50) PRIMARY KEY,
    serial_number       NVARCHAR(50) UNIQUE,
    make                NVARCHAR(50),
    model               NVARCHAR(50),
    colour              NVARCHAR(30),
    year                INT,
    car_for_sale        CHAR(1) CHECK (car_for_sale IN ('Y','N')),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255))
);

-- =========================
-- TABLE: SALES_INVOICE
-- =========================
CREATE TABLE SALES_INVOICES
(
    invoice_id          INT          PRIMARY KEY,
    invoice_number      NVARCHAR(50) UNIQUE,
    date                DATETIME,
    car_id              NVARCHAR(50) UNIQUE,
    customer_id         NVARCHAR(50),
    salesperson_id      NVARCHAR(50),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255)),

    FOREIGN KEY (car_id) REFERENCES CARS(car_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id),
    FOREIGN KEY (salesperson_id) REFERENCES SALESPEOPLE(salesperson_id)
);

-- =========================
-- TABLE: MECHANIC
-- =========================
CREATE TABLE MECHANICS
(
    mechanic_id         NVARCHAR(50) PRIMARY KEY,
    last_name           NVARCHAR(50),
    first_name          NVARCHAR(50),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255))
);

-- =========================
-- TABLE: SERVICE
-- =========================
CREATE TABLE SERVICES
(
    service_id          INT PRIMARY KEY,
    service_name        NVARCHAR(100),
    hourly_rate         DECIMAL(10,2),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255))
);

-- =========================
-- TABLE: SERVICE_TICKET
-- =========================
CREATE TABLE SERVICE_TICKETS
(
    service_ticket_id   INT PRIMARY KEY,
    service_ticket_number NVARCHAR(50),
    car_id              NVARCHAR(50),
    customer_id         NVARCHAR(50),
    date_received       DATETIME, 
    comments            NVARCHAR(MAX),
    date_returned       DATETIME,
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255)),

    FOREIGN KEY (car_id) REFERENCES CARS(car_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);

-- =========================
-- TABLE: SERVICE_MECHANIC
-- =========================
CREATE TABLE SERVICE_MECHANICS
(
    service_mechanic_id  INT PRIMARY KEY,
    service_ticket_id   INT,
    service_id          INT,
    mechanic_id         NVARCHAR(50),
    hours               DECIMAL(5,2),
    comment             NVARCHAR(MAX),
    rate                DECIMAL(10,2),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255)),

    FOREIGN KEY (service_ticket_id) REFERENCES SERVICE_TICKETS(service_ticket_id),
    FOREIGN KEY (service_id) REFERENCES SERVICES(service_id),
    FOREIGN KEY (mechanic_id) REFERENCES MECHANICS(mechanic_id)
);

-- =========================
-- TABLE: PARTS
-- =========================
CREATE TABLE PARTS
(
    parts_id            INT PRIMARY KEY,
    part_number         NVARCHAR(50) UNIQUE,
    description         NVARCHAR(255),
    purchase_price      DECIMAL(10,2),
    retail_price        DECIMAL(10,2),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255))
);

-- =========================
-- TABLE: PARTS_USED
-- =========================
CREATE TABLE PARTS_USED
(
    parts_used_id       INT PRIMARY KEY,
    part_id             INT, -- En la tabla PARTS està como parts_id
    service_ticket_id   INT,
    number_used         INT,
    price               DECIMAL(10,2),
    _created            DATETIME DEFAULT GETUTCDATE(),
    _uid                NVARCHAR(255) DEFAULT CAST(NEWID() AS NVARCHAR(255)),

    FOREIGN KEY (part_id) REFERENCES PARTS(parts_id),
    FOREIGN KEY (service_ticket_id) REFERENCES SERVICE_TICKETS(service_ticket_id)
);
