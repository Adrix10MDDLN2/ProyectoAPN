{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='id_usuario',
    on_schema_change='fail'
) }}

WITH usuarios_ordenados AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY id_usuario
            ORDER BY
                fecha_evento DESC NULLS LAST,
                fecha_carga DESC NULLS LAST,
                id_registro DESC NULLS LAST
        ) AS numero_fila
    FROM {{ ref('stg_users') }}
),

usuarios_unicos AS (
    SELECT *
    FROM usuarios_ordenados
    WHERE numero_fila = 1
),

usuarios_incrementales AS (
    SELECT *
    FROM usuarios_unicos
    {% if is_incremental() %}
        WHERE fecha_carga >= (
            SELECT DATEADD(
                DAY, -2, MAX(fecha_carga)
            )
            FROM {{ this }}
        )
    {% endif %}
)

SELECT
    id_usuario,
    correo_electronico,
    nombre,
    apellidos,
    CASE
        WHEN edad < 0 THEN NULL
        ELSE edad
    END AS edad,
    genero,
    MD5(UPPER(TRIM(pais))) AS id_pais,
    provincia,
    ciudad,
    MD5(UPPER(TRIM(dispositivo_principal))) AS id_dispositivo_principal,
    miembros_hogar,
    fecha_creacion,
    fecha_carga
FROM usuarios_incrementales