SELECT
    id_dispositivo,
    nombre_dispositivo

FROM {{ ref('slv_dispositivos') }}
