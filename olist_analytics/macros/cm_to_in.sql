{% macro cm_to_in(column_name, precision=2) %}
    round({{ column_name }} / 2.54, {{ precision }})
{% endmacro %}
