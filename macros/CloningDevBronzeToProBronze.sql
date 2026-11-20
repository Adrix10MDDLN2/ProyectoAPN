{% macro clonar_bronze() %}
    {% set base_destino = env_var('DBT_BRONZE_DB_APN') | upper | trim %}
    {% if base_destino == 'PRO_BRONZE_DB_APN' %}
        {% set sql_clonado %}
            CREATE OR REPLACE DATABASE PRO_BRONZE_DB_APN
            CLONE DEV_BRONZE_DB_APN
        {% endset %}
        {{ log('Iniciando clonado de Bronze DEV a PRO', info=true) }}
        {% do run_query(sql_clonado) %}
        {{ log('Clonado de Bronze completado correctamente', info=true) }}
    {% else %}
        {{ exceptions.raise_compiler_error(
            'El clonado solo se permite en produccion'
        ) }}
    {% endif %}
{% endmacro %}