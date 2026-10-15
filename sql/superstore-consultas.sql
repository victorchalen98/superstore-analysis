USE superstore;
SELECT * FROM orders LIMIT 10;

-- CONTEO DE FILAS DE LA TABLA ORDERS
SELECT count(*) FROM orders;

-- VER TIPOS DE DATOS DE LA TABLA ORDERS
DESCRIBE orders;

-- INGRESOS TOTALES
SELECT SUM(sales) FROM orders;

-- TOP 10 PRODUCTOS MAS VENDIDOS
SELECT product_name, SUM(quantity) AS unidades
FROM orders
GROUP BY product_name
ORDER BY unidades DESC
LIMIT 10;

-- VENTAS TOTALES POR REGIÓN
SELECT region, SUM(sales) AS ventas_totales FROM orders
group by region
order by ventas_totales DESC;

-- MES CON MAYORES VENTAS
SELECT date_format(order_date, '%Y-%m') AS mes, SUM(sales) AS ingreso_mensual FROM orders
GROUP BY mes
ORDER BY ingreso_mensual ASC;

-- CATEGORIA Y SUBCATEGORIA CON MAYOR GANANCIA
SELECT category, sub_category, SUM(sales) ventas_totales FROM orders
GROUP BY category, sub_category
ORDER BY ventas_totales DESC;

-- SEGMENTO DE CLIENTE MAS RENTABLE
SELECT segment, SUM(profit) ventas_totales FROM orders
GROUP BY segment
ORDER BY ventas_totales DESC;

-- PRODUCTO CON VENTAS ALTAS PERO GANANCIAS NEGATIVAS
SELECT product_name,
       SUM(sales) AS ventas_totales,
       SUM(profit) AS ganancia_total
FROM orders
GROUP BY product_name
HAVING ganancia_total < 0
ORDER BY ventas_totales DESC;