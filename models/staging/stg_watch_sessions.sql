/*
STAGING: Sesiones de reproducción
Filtramos los registros de reproducción,
renombramos columnas y convertimos tipos.
No eliminamos duplicados ni aplicamos reglas de negocio.
*/
WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = 'watch_session'
),

sesiones AS (
    SELECT
        RECORD_ID AS id_registro,
        NULLIF(TRIM(SRC__SESSION_ID), '') AS id_sesion,

        NULLIF(TRIM(USER_ID), '') AS id_usuario,
        NULLIF(TRIM(MOVIE_ID), '') AS id_pelicula,

        TRY_TO_DATE(SRC__WATCH_DATE) AS fecha_visualizacion,

        TRY_TO_DECIMAL(
            SRC__WATCH_DURATION_MINUTES, 12, 2
        ) AS duracion_visualizada_minutos,

        TRY_TO_DECIMAL(
            SRC__PROGRESS_PERCENTAGE, 5, 2
        ) AS porcentaje_progreso,

        NULLIF(TRIM(SRC__ACTION), '') AS accion,
        NULLIF(TRIM(SRC__QUALITY), '') AS calidad_reproduccion,

        TRY_TO_BOOLEAN(SRC__IS_DOWNLOAD) AS es_descarga,

        TRY_TO_DECIMAL(
            SRC__USER_RATING, 4, 2
        ) AS puntuacion_usuario,

        TRY_TO_DATE(EVENT_TIMESTAMP) AS fecha_evento,
        _LOADED_AT AS fecha_carga

    FROM origen
)
SELECT *
FROM sesiones
