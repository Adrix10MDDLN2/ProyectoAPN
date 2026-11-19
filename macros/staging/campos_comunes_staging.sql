-- Extraccion comun de Bronze, conservando todos los registros.
{% macro origen_staging(tipo_registro) -%}
    SELECT *
    FROM {{ source('bronze', 'TABLON') }}
    WHERE RECORD_TYPE = '{{ tipo_registro }}'
{%- endmacro %}

-- Centraliza columnas compartidas y sus alias en castellano.
-- Los parametros preservan las diferencias de los modelos originales.
{% macro campo_comun_staging(campo, limpiar_id=true, tipo_fecha='date') -%}
    {%- if campo == 'id_registro' -%}
        RECORD_ID AS id_registro
    {%- elif campo == 'id_usuario' -%}
        {{ limpiar_texto('USER_ID') if limpiar_id else 'USER_ID' }} AS id_usuario
    {%- elif campo == 'id_pelicula' -%}
        {{ limpiar_texto('MOVIE_ID') if limpiar_id else 'MOVIE_ID' }} AS id_pelicula
    {%- elif campo == 'fecha_evento' -%}
        {%- if tipo_fecha == 'timestamp' -%}
            {{ limpiar_timestamp('EVENT_TIMESTAMP') }} AS fecha_evento
        {%- elif tipo_fecha == 'date' -%}
            {{ limpiar_fecha('EVENT_TIMESTAMP') }} AS fecha_evento
        {%- else -%}
            {{ exceptions.raise_compiler_error('Tipo de fecha no valido: ' ~ tipo_fecha) }}
        {%- endif -%}
    {%- elif campo == 'fecha_carga' -%}
        _LOADED_AT AS fecha_carga
    {%- else -%}
        {{ exceptions.raise_compiler_error('Campo comun no valido: ' ~ campo) }}
    {%- endif -%}
{%- endmacro %}
