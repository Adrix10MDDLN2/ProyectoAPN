WITH agregaciones AS (

    SELECT
        f.id_fecha,
        d.fecha,
        d.anio,
        d.mes,
        f.id_pelicula,
        p.titulo,
        p.tipo_contenido,
        p.genero_principal,
        p.genero_secundario,
        p.pais_origen,
        u.pais AS pais_usuario,
        u.nombre_plan AS plan_suscripcion,

        COUNT(*) AS total_sesiones,
        COUNT(DISTINCT f.id_usuario) AS usuarios_unicos,

        SUM(f.duracion_visualizada_minutos)
            AS minutos_visualizados,

        AVG(f.duracion_visualizada_minutos)
            AS duracion_media_minutos,

        AVG(f.porcentaje_progreso)
            AS progreso_medio,

        COUNT(f.porcentaje_progreso)
            AS sesiones_progreso_conocido,

        COUNT_IF(f.es_finalizada = TRUE)
            AS sesiones_finalizadas,

        COUNT(f.es_descarga)
            AS sesiones_descarga_conocida,

        COUNT_IF(f.es_descarga = TRUE)
            AS sesiones_descargadas,

        AVG(f.puntuacion_usuario)
            AS puntuacion_media_usuario

    FROM {{ ref('fct_visualizaciones') }} f

    INNER JOIN {{ ref('dim_fecha') }} d
        ON f.id_fecha = d.id_fecha

    INNER JOIN {{ ref('dim_peliculas') }} p
        ON f.id_pelicula = p.id_pelicula

    INNER JOIN {{ ref('dim_usuarios') }} u
        ON f.id_usuario = u.id_usuario

    GROUP BY
        f.id_fecha,
        d.fecha,
        d.anio,
        d.mes,
        f.id_pelicula,
        p.titulo,
        p.tipo_contenido,
        p.genero_principal,
        p.genero_secundario,
        p.pais_origen,
        u.pais,
        u.nombre_plan
)

SELECT
    *,

    ROUND(
        minutos_visualizados / 60.0, 2
    ) AS horas_visualizadas,

    ROUND(
        duracion_media_minutos, 2
    ) AS duracion_media,

    ROUND(
        progreso_medio, 2
    ) AS progreso_medio_porcentaje,

    ROUND(
        100.0 * sesiones_finalizadas
        / NULLIF(sesiones_progreso_conocido, 0),
        2
    ) AS tasa_finalizacion,

    ROUND(
        100.0 * sesiones_descargadas
        / NULLIF(sesiones_descarga_conocida, 0),
        2
    ) AS tasa_descarga,

    ROUND(
        puntuacion_media_usuario, 2
    ) AS puntuacion_media

FROM agregaciones