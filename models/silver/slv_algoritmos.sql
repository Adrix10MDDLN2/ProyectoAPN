WITH algoritmos_origen AS (
    SELECT DISTINCT
        TRIM(version_algoritmo) AS version_algoritmo
    FROM {{ ref('stg_recommendation_logs') }}
    WHERE NULLIF(TRIM(version_algoritmo), '') IS NOT NULL
)

SELECT
    MD5(UPPER(version_algoritmo)) AS id_algoritmo,
    version_algoritmo
FROM algoritmos_origen
