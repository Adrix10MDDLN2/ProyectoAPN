/*
STAGING: Catálogo de películas y series
Filtramos los registros del catálogo, renombramos
las columnas y convertimos los tipos de datos
*/
WITH origen AS (
    SELECT *
    FROM {{ ref('ephemeral_tablon_camposComunes') }}
    WHERE RECORD_TYPE = 'movie_catalog'
),

peliculas AS (
    SELECT
        id_registro,
        id_pelicula,

        {{ limpiar_texto('SRC__TITLE') }} AS titulo,
        {{ limpiar_texto('SRC__CONTENT_TYPE') }} AS tipo_contenido,
        {{ limpiar_texto('SRC__GENRE_PRIMARY') }} AS genero_principal,
        {{ limpiar_texto('SRC__GENRE_SECONDARY') }} AS genero_secundario,

        {{ limpiar_entero('SRC__RELEASE_YEAR') }} AS anio_estreno,
        {{ limpiar_entero('SRC__DURATION_MINUTES') }} AS duracion_minutos,

        {{ limpiar_texto('SRC__LANGUAGE') }} AS idioma,
        {{ limpiar_texto('SRC__COUNTRY_OF_ORIGIN') }} AS pais_origen,

        {{ limpiar_decimal('SRC__IMDB_RATING', 4, 2) }} AS puntuacion_imdb,
        {{ limpiar_decimal('SRC__PRODUCTION_BUDGET', 18, 2) }} AS presupuesto_produccion,
        {{ limpiar_decimal('SRC__BOX_OFFICE_REVENUE', 18, 2) }} AS recaudacion_taquilla,

        {{ limpiar_entero('SRC__NUMBER_OF_SEASONS') }} AS numero_temporadas,
        {{ limpiar_entero('SRC__NUMBER_OF_EPISODES') }} AS numero_episodios,

        {{ limpiar_booleano('SRC__IS_NETFLIX_ORIGINAL') }} AS es_original_plataforma,
        {{ limpiar_fecha('SRC__ADDED_TO_PLATFORM') }} AS fecha_incorporacion,

        {{ limpiar_booleano('SRC__CONTENT_WARNING') }} AS advertencia_contenido,

        fecha_evento_timestamp AS fecha_evento,
        fecha_carga

    FROM origen
)
SELECT *
FROM peliculas
