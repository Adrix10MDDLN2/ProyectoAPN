{{ config(materialized='ephemeral') }}

WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
),

campos_comunes AS (
    SELECT
        *,
        RECORD_ID AS id_registro,

        {{ limpiar_texto('USER_ID') }} AS id_usuario,
        {{ limpiar_texto('MOVIE_ID') }} AS id_pelicula,

        {{ limpiar_fecha('EVENT_TIMESTAMP') }}
            AS fecha_evento_date,

        {{ limpiar_timestamp('EVENT_TIMESTAMP') }}
            AS fecha_evento_timestamp,

        _LOADED_AT AS fecha_carga

    FROM origen
)

SELECT *
FROM campos_comunes