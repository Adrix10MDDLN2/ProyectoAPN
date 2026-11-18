/*
STAGING: Reseñas de películas y series
Filtramos los registros de reseñas,
renombramos columnas y convertimos tipos
Conservamos todos los registros originales.
*/
WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = 'review'
),
resenas AS (
    SELECT
        RECORD_ID AS id_registro,

        NULLIF(TRIM(SRC__REVIEW_ID), '') AS id_resena,
        NULLIF(TRIM(USER_ID), '') AS id_usuario,
        NULLIF(TRIM(MOVIE_ID), '') AS id_pelicula,

        TRY_TO_NUMBER(SRC__RATING, 10, 0) AS puntuacion,
        TRY_TO_DATE(SRC__REVIEW_DATE) AS fecha_resena,

        TRY_TO_BOOLEAN(SRC__IS_VERIFIED_WATCH)
            AS visualizacion_verificada,

        TRY_TO_NUMBER(SRC__HELPFUL_VOTES, 10, 0) AS votos_utiles,
        TRY_TO_NUMBER(SRC__TOTAL_VOTES, 10, 0) AS votos_totales,

        NULLIF(TRIM(SRC__REVIEW_TEXT), '') AS texto_resena,
        NULLIF(TRIM(SRC__SENTIMENT), '') AS sentimiento,

        TRY_TO_DECIMAL(SRC__SENTIMENT_SCORE, 5, 3)
            AS puntuacion_sentimiento,

        TRY_TO_DATE(EVENT_TIMESTAMP) AS fecha_evento,
        _LOADED_AT AS fecha_carga

    FROM origen
)
SELECT *
FROM resenas
