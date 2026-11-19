/*
STAGING: Sesiones de reproducción
Filtramos los registros de reproducción,
renombramos columnas y convertimos tipos.
No eliminamos duplicados ni aplicamos reglas de negocio.
*/
WITH origen AS (
    SELECT *
    FROM {{ ref('ephemeral_tablon_camposComunes') }}
    WHERE RECORD_TYPE = 'watch_session'
),

sesiones AS (
    SELECT
        id_registro,
        {{ limpiar_texto('SRC__SESSION_ID') }} AS id_sesion,

        id_usuario,
        id_pelicula,

        {{ limpiar_fecha('SRC__WATCH_DATE') }} AS fecha_visualizacion,

        {{ limpiar_decimal('SRC__WATCH_DURATION_MINUTES', 12, 2) }} AS duracion_visualizada_minutos,

        {{ limpiar_decimal('SRC__PROGRESS_PERCENTAGE', 5, 2) }} AS porcentaje_progreso,

        {{ limpiar_texto('SRC__ACTION') }} AS accion,
        {{ limpiar_texto('SRC__QUALITY') }} AS calidad_reproduccion,

        {{ limpiar_booleano('SRC__IS_DOWNLOAD') }} AS es_descarga,

        {{ limpiar_decimal('SRC__USER_RATING', 4, 2) }} AS puntuacion_usuario,

        fecha_evento_date AS fecha_evento,
        fecha_carga

    FROM origen
)
SELECT *
FROM sesiones
