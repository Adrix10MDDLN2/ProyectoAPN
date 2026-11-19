/*
STAGING: Reseñas de películas y series
Filtramos los registros de reseñas,
renombramos columnas y convertimos tipos
Conservamos todos los registros originales.
*/
WITH origen AS (
    SELECT *
    FROM {{ ref('ephemeral_tablon_camposComunes') }}
    WHERE RECORD_TYPE = 'review'
),
resenas AS (
    SELECT
        id_registro,

        {{ limpiar_texto('SRC__REVIEW_ID') }} AS id_resena,
        id_usuario,
        id_pelicula,

        {{ limpiar_entero('SRC__RATING') }} AS puntuacion,
        {{ limpiar_fecha('SRC__REVIEW_DATE') }} AS fecha_resena,

        {{ limpiar_booleano('SRC__IS_VERIFIED_WATCH') }} AS visualizacion_verificada,

        {{ limpiar_entero('SRC__HELPFUL_VOTES') }} AS votos_utiles,
        {{ limpiar_entero('SRC__TOTAL_VOTES') }} AS votos_totales,

        {{ limpiar_texto('SRC__REVIEW_TEXT') }} AS texto_resena,
        {{ limpiar_texto('SRC__SENTIMENT') }} AS sentimiento,

        {{ limpiar_decimal('SRC__SENTIMENT_SCORE', 5, 3) }} AS puntuacion_sentimiento,

        fecha_evento_date AS fecha_evento,
        fecha_carga

    FROM origen
)
SELECT *
FROM resenas
