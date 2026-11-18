WITH visualizaciones_desduplicadas AS (
    SELECT *
    FROM {{ ref('stg_watch_sessions') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id_sesion
        ORDER BY fecha_visualizacion DESC NULLS LAST,
                 fecha_carga DESC NULLS LAST,
                 id_registro DESC NULLS LAST
    ) = 1
),

visualizaciones_limpias AS (
    SELECT
        id_sesion,
        id_usuario,
        id_pelicula,
        fecha_visualizacion,
        duracion_visualizada_minutos,
        porcentaje_progreso,
        accion,
        calidad_reproduccion,
        es_descarga,
        puntuacion_usuario
    FROM visualizaciones_desduplicadas

)

SELECT *
FROM visualizaciones_limpias
