/*
STAGING: Usuarios
Extraemos los registros de usuarios de Bronze,
renombramos las columnas y convertimos los tipos de datos.
*/
WITH origen AS (
    {{ origen_staging('user_snapshot') }}
),

usuarios AS (
    SELECT
        {{ campo_comun_staging('id_registro') }},
        {{ campo_comun_staging('id_usuario', limpiar_id=false) }},
        
        {{ limpiar_texto('SRC__EMAIL') }} AS correo_electronico,
        {{ limpiar_texto('SRC__FIRST_NAME') }} AS nombre,
        {{ limpiar_texto('SRC__LAST_NAME') }} AS apellidos,

        {{ limpiar_entero('SRC__AGE') }} AS edad,
        SRC__GENDER AS genero,
        SRC__COUNTRY AS pais,
        SRC__STATE_PROVINCE AS provincia,
        SRC__CITY AS ciudad,

        SRC__SUBSCRIPTION_PLAN AS plan_suscripcion,
        {{ limpiar_fecha('SRC__SUBSCRIPTION_START_DATE') }} AS fecha_inicio_suscripcion,
        {{ limpiar_booleano('SRC__IS_ACTIVE') }} AS esta_activo,
        {{ limpiar_decimal('SRC__MONTHLY_SPEND', 12, 2) }} AS gasto_mensual,

        SRC__PRIMARY_DEVICE AS dispositivo_principal,
        {{ limpiar_entero('SRC__HOUSEHOLD_SIZE') }} AS miembros_hogar,
        {{ limpiar_timestamp('SRC__CREATED_AT') }} AS fecha_creacion,

        {{ campo_comun_staging('fecha_evento', tipo_fecha='timestamp') }},
        {{ campo_comun_staging('fecha_carga') }}

    FROM origen
)
SELECT *
FROM usuarios
