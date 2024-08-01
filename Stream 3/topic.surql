DEFINE TABLE topic TYPE NORMAL SCHEMAFULL;

DEFINE FIELD name
    ON TABLE topic
    TYPE string
;

DEFINE FIELD description
    ON TABLE topic
    TYPE string
;

DEFINE FIELD slug
    ON TABLE topic
    TYPE string
    ASSERT string::len($value) > 1 AND $value == string::slug($value)
;

DEFINE INDEX unique_slug
    ON TABLE topic 
    COLUMNS slug
    UNIQUE;