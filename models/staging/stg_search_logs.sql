/*
STAGING: Registros de búsquedas
Filtramos, renombramos y convertimos tipos.
Conservamos todos los registros originales.
*/
WITH origen AS (
    SELECT *
    FROM {{ ref('ephemeral_tablon_camposComunes') }}
    WHERE RECORD_TYPE = 'search_log'
),

busquedas AS (
    SELECT
        id_registro,

        {{ limpiar_texto('SRC__SEARCH_ID') }} AS id_busqueda,
        id_usuario,

        {{ limpiar_texto('SRC__SEARCH_QUERY') }} AS texto_busqueda,

        {{ limpiar_fecha('SRC__SEARCH_DATE') }} AS fecha_busqueda,

        {{ limpiar_entero('SRC__RESULTS_RETURNED') }} AS resultados_obtenidos,

        {{ limpiar_entero('SRC__CLICKED_RESULT_POSITION') }} AS posicion_resultado_clicado,

        {{ limpiar_decimal('SRC__SEARCH_DURATION_SECONDS', 12, 2) }} AS duracion_busqueda_segundos,

        {{ limpiar_booleano('SRC__HAD_TYPO') }} AS tiene_error_escritura,
        {{ limpiar_booleano('SRC__USED_FILTERS') }} AS utilizo_filtros,

        {{ limpiar_texto('SRC__LOCATION_COUNTRY') }} AS pais_busqueda,

        fecha_evento_date AS fecha_evento,
        fecha_carga

    FROM origen
)
SELECT *
FROM busquedas
