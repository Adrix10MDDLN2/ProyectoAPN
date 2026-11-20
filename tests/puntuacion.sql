SELECT
    id_pelicula,
    puntuacion_imdb
FROM {{ ref('slv_peliculas') }}
WHERE puntuacion_imdb NOT BETWEEN 0 AND 10