/*
STAGING: Registros de búsquedas
Filtramos, renombramos y convertimos tipos.
Conservamos todos los registros originales.
*/
WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = 'search_log'
),

busquedas AS (
    SELECT
        RECORD_ID AS id_registro,

        NULLIF(TRIM(SRC__SEARCH_ID), '') AS id_busqueda,
        NULLIF(TRIM(USER_ID), '') AS id_usuario,

        NULLIF(TRIM(SRC__SEARCH_QUERY), '') AS texto_busqueda,

        TRY_TO_DATE(SRC__SEARCH_DATE) AS fecha_busqueda,

        TRY_TO_NUMBER(SRC__RESULTS_RETURNED, 10, 0)
            AS resultados_obtenidos,

        TRY_TO_NUMBER(SRC__CLICKED_RESULT_POSITION, 10, 0)
            AS posicion_resultado_clicado,

        TRY_TO_DECIMAL(SRC__SEARCH_DURATION_SECONDS, 12, 2)
            AS duracion_busqueda_segundos,

        TRY_TO_BOOLEAN(SRC__HAD_TYPO) AS tiene_error_escritura,
        TRY_TO_BOOLEAN(SRC__USED_FILTERS) AS utilizo_filtros,

        NULLIF(TRIM(SRC__LOCATION_COUNTRY), '') AS pais_busqueda,

        TRY_TO_DATE(EVENT_TIMESTAMP) AS fecha_evento,
        _LOADED_AT AS fecha_carga

    FROM origen
)
SELECT *
FROM busquedas