WITH generos_pelicula AS (
    SELECT
        pg.id_pelicula,

        MAX(
            CASE
                WHEN pg.tipo_genero = 'principal'
                THEN g.nombre_genero
            END
        ) AS genero_principal,

        MAX(
            CASE
                WHEN pg.tipo_genero = 'secundario'
                THEN g.nombre_genero
            END
        ) AS genero_secundario

    FROM {{ ref('slv_pelicula_generos') }} pg

    LEFT JOIN {{ ref('slv_generos') }} g
        ON pg.id_genero = g.id_genero

    GROUP BY pg.id_pelicula

)

SELECT
    p.id_pelicula,
    p.titulo,
    p.tipo_contenido,
    p.anio_estreno,
    p.duracion_minutos,
    p.idioma,
    pais.nombre_pais AS pais_origen,

    gp.genero_principal,
    gp.genero_secundario,

    p.puntuacion_imdb,
    p.presupuesto_produccion,
    p.recaudacion_taquilla,
    p.numero_temporadas,
    p.numero_episodios,
    p.es_original_plataforma,
    p.fecha_incorporacion,
    p.advertencia_contenido

FROM {{ ref('slv_peliculas') }} p

LEFT JOIN {{ ref('slv_paises') }} pais
    ON p.id_pais_origen = pais.id_pais

LEFT JOIN generos_pelicula gp
    ON p.id_pelicula = gp.id_pelicula