-- Script para MySQL 8+ o MariaDB.
-- Ejecutar desde la raíz del repositorio con un cliente que permita LOAD DATA LOCAL:
-- mysql --local-infile=1 -u <usuario> -p < sql/superstore-consultas.sql
-- LOCAL INFILE debe estar habilitado tanto en el cliente como en el servidor.
-- La ruta del CSV se resuelve desde el directorio actual del cliente.

CREATE DATABASE IF NOT EXISTS superstore
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE superstore;

CREATE TABLE IF NOT EXISTS orders (
    row_id INT NOT NULL PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    ship_mode VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(30) NOT NULL,
    country VARCHAR(80) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(80) NOT NULL,
    postal_code VARCHAR(20) NULL,
    region VARCHAR(20) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    category VARCHAR(40) NOT NULL,
    sub_category VARCHAR(40) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    sales DECIMAL(12, 4) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(4, 2) NOT NULL,
    profit DECIMAL(12, 4) NOT NULL
);

-- Importación del CSV incluido en data/raw. Ejecutar una sola vez sobre la tabla vacía.
-- Si se importa de nuevo, vaciar la tabla manualmente antes para evitar claves duplicadas.
LOAD DATA LOCAL INFILE 'data/raw/Sample - Superstore.csv'
INTO TABLE orders
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    row_id,
    order_id,
    @order_date,
    @ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    @postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
)
SET
    order_date = STR_TO_DATE(@order_date, '%c/%e/%Y'),
    ship_date = STR_TO_DATE(@ship_date, '%c/%e/%Y'),
    postal_code = NULLIF(@postal_code, '');

-- Muestra de registros y validación de la carga
SELECT * FROM orders LIMIT 10;

-- Conteo de filas cargadas (el CSV contiene 9.994 filas de datos)
SELECT COUNT(*) AS total_filas
FROM orders;

-- Tipos de datos de la tabla
DESCRIBE orders;

-- Ventas, ganancias y margen agregados
SELECT
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total,
    SUM(profit) / NULLIF(SUM(sales), 0) AS margen_agregado
FROM orders;

-- Top 10 productos por unidades vendidas
SELECT
    product_name,
    SUM(quantity) AS unidades_vendidas
FROM orders
GROUP BY product_name
ORDER BY unidades_vendidas DESC
LIMIT 10;

-- Ventas y ganancias totales por región
SELECT
    region,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total,
    SUM(profit) / NULLIF(SUM(sales), 0) AS margen_agregado
FROM orders
GROUP BY region
ORDER BY ganancia_total DESC;

-- Mes con mayores ventas (del mayor al menor)
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS mes,
    SUM(sales) AS ventas_mensuales
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY ventas_mensuales DESC
LIMIT 1;

-- Ganancia por categoría y subcategoría
SELECT
    category,
    sub_category,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total,
    SUM(profit) / NULLIF(SUM(sales), 0) AS margen_agregado
FROM orders
GROUP BY category, sub_category
ORDER BY ganancia_total DESC;

-- Segmentos de cliente ordenados por ganancia total
SELECT
    segment,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total,
    SUM(profit) / NULLIF(SUM(sales), 0) AS margen_agregado
FROM orders
GROUP BY segment
ORDER BY ganancia_total DESC;

-- Productos con ventas y ganancia total negativas
SELECT
    product_name,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total
FROM orders
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY ventas_totales DESC;

-- Ganancia y margen por valor de descuento observado (sin crear intervalos)
SELECT
    discount,
    COUNT(*) AS lineas,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total,
    SUM(profit) / NULLIF(SUM(sales), 0) AS margen_agregado
FROM orders
GROUP BY discount
ORDER BY discount;

-- Estados con pérdidas totales
SELECT
    state,
    SUM(sales) AS ventas_totales,
    SUM(profit) AS ganancia_total
FROM orders
GROUP BY state
HAVING SUM(profit) < 0
ORDER BY ganancia_total;
