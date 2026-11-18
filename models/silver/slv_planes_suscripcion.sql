WITH planes_origen AS (
    SELECT DISTINCT
        TRIM(plan_suscripcion) AS nombre_plan
    FROM {{ ref('stg_users') }}
    WHERE NULLIF(TRIM(plan_suscripcion), '') IS NOT NULL

)
SELECT
    MD5(UPPER(nombre_plan)) AS id_plan,
    nombre_plan
FROM planes_origen