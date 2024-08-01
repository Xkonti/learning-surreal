DEFINE TABLE series TYPE NORMAL SCHEMAFULL;

DEFINE FIELD name
    ON TABLE series
    TYPE string
;

DEFINE FIELD description
    ON TABLE series
    TYPE string
;

DEFINE FIELD slug
    ON TABLE series
    TYPE string
    ASSERT string::len($value) > 3 AND $value == string::slug($value)
;

DEFINE INDEX unique_slug
    ON TABLE series 
    COLUMNS slug
    UNIQUE;