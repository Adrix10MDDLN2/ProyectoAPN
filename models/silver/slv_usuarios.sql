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

usuarios_limpios AS (
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
        fecha_creacion
    FROM usuarios_desduplicados
)

SELECT
    id_usuario,
    correo_electronico,
    nombre,
    apellidos,
    edad,
    genero,
    id_pais,
    provincia,
    ciudad,
    id_dispositivo_principal,
    miembros_hogar,
    fecha_creacion
FROM usuarios_limpios