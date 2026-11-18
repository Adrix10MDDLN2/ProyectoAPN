/*
STAGING: Registros de recomendaciones
Filtramos, renombramos y convertimos tipos.
Conservamos todos los registros originales.
*/
WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = 'recommendation_log'
),

recomendaciones AS (
    SELECT
        RECORD_ID AS id_registro,

        NULLIF(TRIM(SRC__RECOMMENDATION_ID), '')
            AS id_recomendacion,

        NULLIF(TRIM(USER_ID), '') AS id_usuario,
        NULLIF(TRIM(MOVIE_ID), '') AS id_pelicula,

        TRY_TO_DATE(SRC__RECOMMENDATION_DATE)
            AS fecha_recomendacion,

        NULLIF(TRIM(SRC__RECOMMENDATION_TYPE), '')
            AS tipo_recomendacion,

        TRY_TO_DECIMAL(SRC__RECOMMENDATION_SCORE, 5, 3)
            AS puntuacion_recomendacion,

        TRY_TO_BOOLEAN(SRC__WAS_CLICKED)
            AS fue_clicada,

        TRY_TO_NUMBER(SRC__POSITION_IN_LIST, 10, 0)
            AS posicion_lista,

        NULLIF(TRIM(SRC__DEVICE_TYPE), '')
            AS tipo_dispositivo,

        NULLIF(TRIM(SRC__TIME_OF_DAY), '')
            AS momento_dia,

        NULLIF(TRIM(SRC__ALGORITHM_VERSION), '')
            AS version_algoritmo,

        TRY_TO_DATE(EVENT_TIMESTAMP) AS fecha_evento,
        _LOADED_AT AS fecha_carga

    FROM origen
)
SELECT *
FROM recomendaciones