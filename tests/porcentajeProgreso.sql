SELECT
    id_sesion,
    PORCENTAJE_PROGRESO
FROM {{ ref('slv_visualizaciones') }}
WHERE porcentaje_progreso NOT BETWEEN 0 AND 100