-- Transformaciones reutilizables de Snowflake.
{% macro limpiar_texto(columna) -%}
    NULLIF(TRIM({{ columna }}), '')
{%- endmacro %}

{% macro limpiar_entero(columna) -%}
    TRY_TO_NUMBER({{ columna }}, 10, 0)
{%- endmacro %}

{% macro limpiar_decimal(columna, precision, escala) -%}
    TRY_TO_DECIMAL({{ columna }}, {{ precision }}, {{ escala }})
{%- endmacro %}

{% macro limpiar_fecha(columna) -%}
    TRY_TO_DATE({{ columna }})
{%- endmacro %}

{% macro limpiar_timestamp(columna) -%}
    TRY_TO_TIMESTAMP_NTZ({{ columna }})
{%- endmacro %}

{% macro limpiar_booleano(columna) -%}
    TRY_TO_BOOLEAN({{ columna }})
{%- endmacro %}
