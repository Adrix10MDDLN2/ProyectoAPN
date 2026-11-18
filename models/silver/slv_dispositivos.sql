WITH dispositivos_origen AS (
    SELECT dispositivo_principal AS nombre_dispositivo
    FROM {{ ref('stg_users') }}

    UNION ALL

    SELECT tipo_dispositivo AS nombre_dispositivo
    FROM {{ ref('stg_recommendation_logs') }}
),

dispositivos_limpios AS (
    SELECT DISTINCT
        TRIM(nombre_dispositivo) AS nombre_dispositivo
    FROM dispositivos_origen
    WHERE NULLIF(TRIM(nombre_dispositivo), '') IS NOT NULL
)

SELECT
    MD5(UPPER(nombre_dispositivo)) AS id_dispositivo,
    nombre_dispositivo
FROM dispositivos_limpios