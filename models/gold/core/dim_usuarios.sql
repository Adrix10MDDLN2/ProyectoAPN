SELECT
    u.id_usuario,
    u.edad,
    u.genero,
    p.nombre_pais AS pais,
    u.provincia,
    u.ciudad,
    u.miembros_hogar,
    u.fecha_creacion,
    pl.nombre_plan,
    s.esta_activo,
    s.gasto_mensual,
    s.fecha_inicio_suscripcion

FROM {{ ref('slv_usuarios') }} u

LEFT JOIN {{ ref('slv_paises') }} p
    ON u.id_pais = p.id_pais

LEFT JOIN {{ ref('slv_suscripciones') }} s
    ON u.id_usuario = s.id_usuario

LEFT JOIN {{ ref('slv_planes_suscripcion') }} pl
    ON s.id_plan = pl.id_plan
