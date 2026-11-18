WITH recomendaciones_desduplicadas AS (
    SELECT *
    FROM {{ ref('stg_recommendation_logs') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id_recomendacion
        ORDER BY fecha_recomendacion DESC NULLS LAST,
                 fecha_carga DESC NULLS LAST,
                 id_registro DESC NULLS LAST
    ) = 1
),

recomendaciones_limpias AS (
    SELECT
        id_recomendacion,
        id_usuario,
        id_pelicula,
        fecha_recomendacion,
        tipo_recomendacion,
        puntuacion_recomendacion,
        fue_clicada,
        posicion_lista,
        MD5(UPPER(TRIM(tipo_dispositivo))) AS id_dispositivo,
        momento_dia,
        CASE
            WHEN NULLIF(TRIM(version_algoritmo), '') IS NOT NULL
            THEN MD5(UPPER(TRIM(version_algoritmo)))
            ELSE NULL
        END AS id_algoritmo
    FROM recomendaciones_desduplicadas
)

SELECT *
FROM recomendaciones_limpias