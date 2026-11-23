SELECT
    id_recomendacion,
    id_usuario,
    id_pelicula,
    id_algoritmo,
    id_dispositivo,

    TO_NUMBER(
        TO_CHAR(fecha_recomendacion, 'YYYYMMDD')
    ) AS id_fecha,

    fecha_recomendacion,
    tipo_recomendacion,
    puntuacion_recomendacion,
    fue_clicada,
    posicion_lista,
    momento_dia,

    1 AS total_recomendaciones,

    CASE
        WHEN fue_clicada = TRUE THEN 1
        WHEN fue_clicada = FALSE THEN 0
        ELSE NULL
    END AS indicador_clic

FROM {{ ref('slv_recomendaciones') }}