# Superstore analysis

Análisis exploratorio del dataset [Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

## Pregunta de negocio

**¿Qué categorías, subcategorías/productos y regiones generan o destruyen rentabilidad, y en qué segmentos de descuento conviene investigar las pérdidas?**

El análisis responde la pregunta comparando ventas y ganancias por categoría, subcategoría, producto, región y estado. También revisa cómo se distribuyen las ganancias y los márgenes entre los valores de descuento observados, para identificar casos que merecen investigarse.

### Preguntas de apoyo

- ¿Qué categorías y subcategorías concentran las mayores ventas y ganancias?
- ¿Qué productos, regiones o estados presentan pérdidas totales?
- ¿Hay valores de descuento asociados con menores ganancias o márgenes, y en qué categorías o subcategorías ocurre?

### Criterios de análisis

- Ventas y ganancias se compararán como totales agregados. El margen se calculará como `ganancia total / ventas totales`, no como el promedio de los márgenes de cada fila.
- Los descuentos se analizarán usando inicialmente sus valores observados en los datos, sin crear intervalos arbitrarios.
- Los resultados describen asociaciones en este conjunto de datos; no demuestran que un descuento cause una pérdida.

## Resultados y recomendaciones

En las 9.994 líneas del dataset (2014–2017), las ventas suman **$2.297.200,86** y la ganancia **$286.397,02**, con un margen agregado de **12,47%**.

- Las tres categorías son rentables. **Technology** lidera la ganancia (**$145.454,95; margen 17,40%**), seguida de **Office Supplies** (**$122.490,80; 17,04%**). **Furniture** tiene el menor margen (**2,49%**).
- Las subcategorías con pérdidas son **Tables** (**-$17.725,48**), **Bookcases** (**-$3.472,56**) y **Supplies** (**-$1.189,10**). **301 de 1.850 productos** tienen ganancia total negativa; las pérdidas más grandes incluyen Cubify CubeX Double Head (**-$8.879,97**), Lexmark MX611dhe (**-$4.589,97**) y Cubify CubeX Triple Head (**-$3.839,99**).
- Todas las regiones son rentables, pero **Central** tiene el menor margen (**7,92%**); **West** presenta el mayor (**14,94%**). Por estado, **Texas** registra la mayor pérdida (**-$25.729,36**), seguido de **Ohio** (**-$16.971,38**) y **Pennsylvania** (**-$15.559,96**).
- Los descuentos observados de **30% a 80%** tienen ganancia agregada negativa; los valores de 0% a 20% son positivos. Esta asociación no prueba causalidad y algunos valores tienen pocas observaciones.

**Prioridades de investigación:** revisar precios, costos y descuentos en Tables, Bookcases y Supplies; auditar descuentos de 30% o más en el detalle de productos y estados; y analizar las causas de la baja rentabilidad de Central y de las pérdidas en Texas, Ohio y Pennsylvania. Validar los hallazgos en productos y condiciones comparables antes de modificar la política comercial.

Estos resultados son descriptivos del dataset y periodo analizados; no garantizan el desempeño futuro.

**Herramientas utilizadas:**
- Python (Pandas, Matplotlib)
- SQL
- Power BI
- Jupyter Notebook.

## Ejecución de las consultas SQL

El script [superstore-consultas.sql](./sql/superstore-consultas.sql) crea la base `superstore`, define `orders`, importa el CSV y ejecuta las consultas. Requiere MySQL 8+ o MariaDB, y `LOCAL INFILE` debe estar habilitado en el cliente y en el servidor.

Desde la raíz del repositorio, ejecutar una sola vez sobre la tabla vacía:

```bash
mysql --local-infile=1 -u <usuario> -p < sql/superstore-consultas.sql
```

El comando solicita la contraseña y el script busca `data/raw/Sample - Superstore.csv` relativo al directorio actual. Si se vuelve a importar el archivo, vaciar primero la tabla para evitar claves duplicadas.
