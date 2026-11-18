WITH busquedas_desduplicadas AS (
    SELECT *
    FROM {{ ref('stg_search_logs') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id_busqueda
        ORDER BY fecha_busqueda DESC NULLS LAST,
                 fecha_carga DESC NULLS LAST,
                 id_registro DESC NULLS LAST
    ) = 1
),

busquedas_limpias AS (
    SELECT
        id_busqueda,
        id_usuario,
        texto_busqueda,
        fecha_busqueda,
        resultados_obtenidos,
        posicion_resultado_clicado,
        duracion_busqueda_segundos,
        tiene_error_escritura,
        utilizo_filtros,
        MD5(UPPER(TRIM(pais_busqueda))) AS id_pais_busqueda
    FROM busquedas_desduplicadas
)

SELECT *
FROM busquedas_limpias