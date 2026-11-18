/*
STAGING: Catálogo de películas y series
Filtramos los registros del catálogo, renombramos
las columnas y convertimos los tipos de datos
*/
WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = 'movie_catalog'
),

peliculas AS (
    SELECT
        RECORD_ID AS id_registro,
        MOVIE_ID AS id_pelicula,

        NULLIF(TRIM(SRC__TITLE), '') AS titulo,
        NULLIF(TRIM(SRC__CONTENT_TYPE), '') AS tipo_contenido,
        NULLIF(TRIM(SRC__GENRE_PRIMARY), '') AS genero_principal,
        NULLIF(TRIM(SRC__GENRE_SECONDARY), '') AS genero_secundario,

        TRY_TO_NUMBER(SRC__RELEASE_YEAR, 10, 0) AS anio_estreno,
        TRY_TO_NUMBER(SRC__DURATION_MINUTES, 10, 0) AS duracion_minutos,

        NULLIF(TRIM(SRC__LANGUAGE), '') AS idioma,
        NULLIF(TRIM(SRC__COUNTRY_OF_ORIGIN), '') AS pais_origen,

        TRY_TO_DECIMAL(SRC__IMDB_RATING, 4, 2) AS puntuacion_imdb,
        TRY_TO_DECIMAL(SRC__PRODUCTION_BUDGET, 18, 2) AS presupuesto_produccion,
        TRY_TO_DECIMAL(SRC__BOX_OFFICE_REVENUE, 18, 2) AS recaudacion_taquilla,

        TRY_TO_NUMBER(SRC__NUMBER_OF_SEASONS, 10, 0) AS numero_temporadas,
        TRY_TO_NUMBER(SRC__NUMBER_OF_EPISODES, 10, 0) AS numero_episodios,

        TRY_TO_BOOLEAN(SRC__IS_NETFLIX_ORIGINAL) AS es_original_plataforma,
        TRY_TO_DATE(SRC__ADDED_TO_PLATFORM) AS fecha_incorporacion,

        TRY_TO_BOOLEAN(SRC__CONTENT_WARNING) AS advertencia_contenido,

        TRY_TO_TIMESTAMP_NTZ(EVENT_TIMESTAMP) AS fecha_evento,
        _LOADED_AT AS fecha_carga

    FROM origen
)
SELECT *
FROM peliculas
