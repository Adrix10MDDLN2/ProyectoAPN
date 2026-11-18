/*
STAGING: Usuarios
Extraemos los registros de usuarios de Bronze,
renombramos las columnas y convertimos los tipos de datos.
*/
WITH origen AS (
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = 'user_snapshot'
),

usuarios AS (
    SELECT
        RECORD_ID AS id_registro,
        USER_ID AS id_usuario,
        
        NULLIF(TRIM(SRC__EMAIL), '') AS correo_electronico,
        NULLIF(TRIM(SRC__FIRST_NAME), '') AS nombre,
        NULLIF(TRIM(SRC__LAST_NAME), '') AS apellidos,

        TRY_TO_NUMBER(SRC__AGE, 10, 0) AS edad,
        SRC__GENDER AS genero,
        SRC__COUNTRY AS pais,
        SRC__STATE_PROVINCE AS provincia,
        SRC__CITY AS ciudad,

        SRC__SUBSCRIPTION_PLAN AS plan_suscripcion,
        TRY_TO_DATE(SRC__SUBSCRIPTION_START_DATE) AS fecha_inicio_suscripcion,
        TRY_TO_BOOLEAN(SRC__IS_ACTIVE) AS esta_activo,
        TRY_TO_DECIMAL(SRC__MONTHLY_SPEND, 12, 2) AS gasto_mensual,

        SRC__PRIMARY_DEVICE AS dispositivo_principal,
        TRY_TO_NUMBER(SRC__HOUSEHOLD_SIZE, 10, 0) AS miembros_hogar,
        TRY_TO_TIMESTAMP_NTZ(SRC__CREATED_AT) AS fecha_creacion,

        TRY_TO_TIMESTAMP_NTZ(EVENT_TIMESTAMP) AS fecha_evento,
        _LOADED_AT AS fecha_carga

    FROM origen
)
SELECT *
FROM usuarios