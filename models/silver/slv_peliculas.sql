WITH peliculas_desduplicadas AS (
    SELECT *
    FROM {{ ref('stg_movies') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id_pelicula
        ORDER BY fecha_evento DESC NULLS LAST,
                 fecha_carga DESC NULLS LAST,
                 id_registro DESC NULLS LAST
    ) = 1
),

peliculas_limpias AS (
    SELECT
        id_pelicula,
        titulo,
        tipo_contenido,
        anio_estreno,
        duracion_minutos,
        idioma,
        MD5(UPPER(TRIM(pais_origen))) AS id_pais_origen,
        puntuacion_imdb,
        presupuesto_produccion,
        recaudacion_taquilla,
        numero_temporadas,
        numero_episodios,
        es_original_plataforma,
        fecha_incorporacion,
        advertencia_contenido
    FROM peliculas_desduplicadas
)

SELECT *
FROM peliculas_limpias
