WITH paises_origen AS (
    SELECT pais AS nombre_pais
    FROM {{ ref('stg_users') }}

    UNION ALL

    SELECT pais_origen AS nombre_pais
    FROM {{ ref('stg_movies') }}

    UNION ALL

    SELECT pais_busqueda AS nombre_pais
    FROM {{ ref('stg_search_logs') }}
),
paises_limpios AS (
    SELECT DISTINCT
        UPPER(TRIM(nombre_pais)) AS nombre_pais
    FROM paises_origen
    WHERE NULLIF(TRIM(nombre_pais), '') IS NOT NULL
)
SELECT
    MD5(nombre_pais) AS id_pais,
    nombre_pais
FROM paises_limpios