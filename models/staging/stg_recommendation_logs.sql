/*
STAGING: Registros de recomendaciones
Filtramos, renombramos y convertimos tipos.
Conservamos todos los registros originales.
*/
WITH origen AS (
    {{ origen_staging('recommendation_log') }}
),

recomendaciones AS (
    SELECT
        {{ campo_comun_staging('id_registro') }},

        {{ limpiar_texto('SRC__RECOMMENDATION_ID') }} AS id_recomendacion,

        {{ campo_comun_staging('id_usuario') }},
        {{ campo_comun_staging('id_pelicula') }},

        {{ limpiar_fecha('SRC__RECOMMENDATION_DATE') }} AS fecha_recomendacion,

        {{ limpiar_texto('SRC__RECOMMENDATION_TYPE') }} AS tipo_recomendacion,

        {{ limpiar_decimal('SRC__RECOMMENDATION_SCORE', 5, 3) }} AS puntuacion_recomendacion,

        {{ limpiar_booleano('SRC__WAS_CLICKED') }} AS fue_clicada,

        {{ limpiar_entero('SRC__POSITION_IN_LIST') }} AS posicion_lista,

        {{ limpiar_texto('SRC__DEVICE_TYPE') }} AS tipo_dispositivo,

        {{ limpiar_texto('SRC__TIME_OF_DAY') }} AS momento_dia,

        {{ limpiar_texto('SRC__ALGORITHM_VERSION') }} AS version_algoritmo,

        {{ campo_comun_staging('fecha_evento') }},
        {{ campo_comun_staging('fecha_carga') }}

    FROM origen
)
SELECT *
FROM recomendaciones
