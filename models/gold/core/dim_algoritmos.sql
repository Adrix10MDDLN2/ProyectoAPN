SELECT
    id_algoritmo,
    version_algoritmo

FROM {{ ref('slv_algoritmos') }}
