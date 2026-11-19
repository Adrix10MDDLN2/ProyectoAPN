/*
STAGING: Reseñas de películas y series
Filtramos los registros de reseñas,
renombramos columnas y convertimos tipos
Conservamos todos los registros originales.
*/
WITH origen AS (
    {{ origen_staging('review') }}
),
resenas AS (
    SELECT
        {{ campo_comun_staging('id_registro') }},

        {{ limpiar_texto('SRC__REVIEW_ID') }} AS id_resena,
        {{ campo_comun_staging('id_usuario') }},
        {{ campo_comun_staging('id_pelicula') }},

        {{ limpiar_entero('SRC__RATING') }} AS puntuacion,
        {{ limpiar_fecha('SRC__REVIEW_DATE') }} AS fecha_resena,

        {{ limpiar_booleano('SRC__IS_VERIFIED_WATCH') }} AS visualizacion_verificada,

        {{ limpiar_entero('SRC__HELPFUL_VOTES') }} AS votos_utiles,
        {{ limpiar_entero('SRC__TOTAL_VOTES') }} AS votos_totales,

        {{ limpiar_texto('SRC__REVIEW_TEXT') }} AS texto_resena,
        {{ limpiar_texto('SRC__SENTIMENT') }} AS sentimiento,

        {{ limpiar_decimal('SRC__SENTIMENT_SCORE', 5, 3) }} AS puntuacion_sentimiento,

        {{ campo_comun_staging('fecha_evento') }},
        {{ campo_comun_staging('fecha_carga') }}

    FROM origen
)
SELECT *
FROM resenas
