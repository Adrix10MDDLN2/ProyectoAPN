WITH fechas_eventos AS (
    SELECT fecha_visualizacion AS fecha
    FROM {{ ref('slv_visualizaciones') }}

    UNION ALL

    SELECT fecha_recomendacion AS fecha
    FROM {{ ref('slv_recomendaciones') }}
),

limites AS (
    SELECT
        MIN(fecha) AS fecha_inicio,
        MAX(fecha) AS fecha_fin
    FROM fechas_eventos

),

numeros AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS numero
    FROM TABLE(GENERATOR(ROWCOUNT => 36600))

),

calendario AS (
    SELECT
        DATEADD(DAY, n.numero, l.fecha_inicio) AS fecha
    FROM numeros n
    CROSS JOIN limites l
    WHERE n.numero <= DATEDIFF(DAY, l.fecha_inicio, l.fecha_fin)

)

SELECT
    TO_NUMBER(TO_CHAR(fecha, 'YYYYMMDD')) AS id_fecha,
    fecha,
    YEAR(fecha) AS anio,
    QUARTER(fecha) AS trimestre,
    MONTH(fecha) AS mes,
    DAY(fecha) AS dia,
    WEEKISO(fecha) AS semana,
    YEAROFWEEKISO(fecha) AS anio_semana,
    DAYOFWEEKISO(fecha) AS dia_semana,
    DAYOFYEAR(fecha) AS dia_anio,
    DAYOFWEEKISO(fecha) IN (6, 7) AS es_fin_semana
FROM calendario