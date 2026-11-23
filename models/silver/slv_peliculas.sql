{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='id_pelicula',
    on_schema_change='fail'
) }}

WITH peliculas_ordenadas AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY id_pelicula
            ORDER BY
                fecha_evento DESC NULLS LAST,
                fecha_carga DESC NULLS LAST,
                id_registro DESC NULLS LAST
        ) AS numero_fila
    FROM {{ ref('stg_movies') }}
),

peliculas_unicas AS (
    SELECT *
    FROM peliculas_ordenadas
    WHERE numero_fila = 1
),

peliculas_incrementales AS (
    SELECT *
    FROM peliculas_unicas
    {% if is_incremental() %}
        WHERE fecha_carga >= (
            SELECT DATEADD(
                DAY, -2, MAX(fecha_carga)
            )
            FROM {{ this }}
        )
    {% endif %}
)

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
    advertencia_contenido,
    fecha_carga
FROM peliculas_incrementales