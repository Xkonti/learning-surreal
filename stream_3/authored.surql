DEFINE TABLE authored
    TYPE RELATION
    SCHEMAFULL
;

REMOVE FIELD in ON TABLE authored;
DEFINE FIELD in
    ON TABLE authored
    TYPE record<user>
    ASSERT !!$value.id
;

REMOVE FIELD out ON TABLE authored;
DEFINE FIELD out
    ON TABLE authored
    TYPE record<post>
    ASSERT !!$value.id
;

DEFINE FIELD notes
    ON TABLE authored
    TYPE option<string>
    DEFAULT NONE
;

DEFINE INDEX unique_relation
    ON TABLE authored 
    COLUMNS in, out UNIQUE;