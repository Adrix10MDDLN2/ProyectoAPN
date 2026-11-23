WITH agregaciones AS (

    SELECT
        f.id_fecha,
        d.fecha,
        d.anio,
        d.mes,

        f.id_pelicula,
        p.titulo,
        p.genero_principal,

        f.id_algoritmo,
        COALESCE(
            a.version_algoritmo,
            'Sin version'
        ) AS algoritmo,

        f.id_dispositivo,
        disp.nombre_dispositivo AS dispositivo,

        u.pais AS pais_usuario,
        f.tipo_recomendacion,
        f.momento_dia,
        f.posicion_lista,

        COUNT(*) AS total_recomendaciones,

        COUNT(DISTINCT f.id_usuario)
            AS usuarios_unicos,

        COUNT(f.indicador_clic)
            AS recomendaciones_clic_conocido,

        COUNT_IF(f.indicador_clic = 1)
            AS total_clics,

        AVG(f.puntuacion_recomendacion)
            AS puntuacion_media_recomendacion

    FROM {{ ref('fct_recomendaciones') }} f

    INNER JOIN {{ ref('dim_fecha') }} d
        ON f.id_fecha = d.id_fecha

    INNER JOIN {{ ref('dim_peliculas') }} p
        ON f.id_pelicula = p.id_pelicula

    INNER JOIN {{ ref('dim_usuarios') }} u
        ON f.id_usuario = u.id_usuario

    LEFT JOIN {{ ref('dim_algoritmos') }} a
        ON f.id_algoritmo = a.id_algoritmo

    INNER JOIN {{ ref('dim_dispositivos') }} disp
        ON f.id_dispositivo = disp.id_dispositivo

    GROUP BY
        f.id_fecha,
        d.fecha,
        d.anio,
        d.mes,
        f.id_pelicula,
        p.titulo,
        p.genero_principal,
        f.id_algoritmo,
        a.version_algoritmo,
        f.id_dispositivo,
        disp.nombre_dispositivo,
        u.pais,
        f.tipo_recomendacion,
        f.momento_dia,
        f.posicion_lista
)

SELECT
    *,

    ROUND(
        100.0 * total_clics
        / NULLIF(recomendaciones_clic_conocido, 0),
        2
    ) AS ctr_porcentaje,

    ROUND(
        puntuacion_media_recomendacion, 2
    ) AS puntuacion_media

FROM agregaciones