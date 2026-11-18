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

generos_peliculas AS (
    SELECT
        id_pelicula,
        genero_principal AS nombre_genero,
        'principal' AS tipo_genero
    FROM peliculas_desduplicadas
    WHERE NULLIF(TRIM(genero_principal), '') IS NOT NULL

    UNION ALL

    SELECT
        id_pelicula,
        genero_secundario AS nombre_genero,
        'secundario' AS tipo_genero
    FROM peliculas_desduplicadas
    WHERE NULLIF(TRIM(genero_secundario), '') IS NOT NULL
      AND UPPER(TRIM(genero_secundario))
          <> UPPER(TRIM(genero_principal))
),

relaciones AS (
    SELECT
        id_pelicula,
        MD5(UPPER(TRIM(nombre_genero))) AS id_genero,
        tipo_genero
    FROM generos_peliculas

)
SELECT
    id_pelicula,
    id_genero,
    tipo_genero
FROM relaciones
