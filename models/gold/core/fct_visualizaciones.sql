SELECT
    id_sesion,
    id_usuario,
    id_pelicula,

    TO_NUMBER(
        TO_CHAR(fecha_visualizacion, 'YYYYMMDD')
    ) AS id_fecha,

    fecha_visualizacion,
    duracion_visualizada_minutos,
    porcentaje_progreso,
    accion,
    calidad_reproduccion,
    es_descarga,
    puntuacion_usuario,

    1 AS total_sesiones,

    CASE
        WHEN porcentaje_progreso IS NULL THEN NULL
        WHEN porcentaje_progreso >= 90 THEN TRUE
        ELSE FALSE
    END AS es_finalizada

FROM {{ ref('slv_visualizaciones') }}