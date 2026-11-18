WITH resenias_desduplicadas AS (
    SELECT *
    FROM {{ ref('stg_reviews') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id_resena
        ORDER BY fecha_resena DESC NULLS LAST,
                 fecha_carga DESC NULLS LAST,
                 id_registro DESC NULLS LAST
    ) = 1
),

resenas_limpias AS (
    SELECT
        id_resena,
        id_usuario,
        id_pelicula,
        puntuacion,
        fecha_resena,
        visualizacion_verificada,
        votos_utiles,
        votos_totales,
        texto_resena,
        sentimiento,
        puntuacion_sentimiento
    FROM resenias_desduplicadas
)

SELECT *
FROM resenas_limpias
