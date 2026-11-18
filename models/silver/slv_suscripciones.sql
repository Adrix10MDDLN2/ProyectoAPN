WITH usuarios_desduplicados AS (
    SELECT *
    FROM {{ ref('stg_users') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY id_usuario
        ORDER BY fecha_evento DESC NULLS LAST,
                 fecha_carga DESC NULLS LAST,
                 id_registro DESC NULLS LAST
    ) = 1
),

suscripciones AS (
    SELECT
        id_usuario,
        MD5(UPPER(TRIM(plan_suscripcion))) AS id_plan,
        fecha_inicio_suscripcion,
        esta_activo,
        gasto_mensual
    FROM usuarios_desduplicados

)

SELECT
    id_usuario,
    id_plan,
    fecha_inicio_suscripcion,
    esta_activo,
    gasto_mensual
FROM suscripciones
