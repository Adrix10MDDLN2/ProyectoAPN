WITH generos_origen AS (
    SELECT genero_principal AS nombre_genero
    FROM {{ ref('stg_movies') }}

    UNION ALL

    SELECT genero_secundario AS nombre_genero
    FROM {{ ref('stg_movies') }}
),

generos_limpios AS (
    SELECT DISTINCT
        TRIM(nombre_genero) AS nombre_genero
    FROM generos_origen
    WHERE NULLIF(TRIM(nombre_genero), '') IS NOT NULL
)

SELECT
    MD5(UPPER(nombre_genero)) AS id_genero,
    nombre_genero
FROM generos_limpios
