DEFINE TABLE contains
    TYPE RELATION
    SCHEMAFULL
;

DEFINE FIELD in
    ON TABLE contains
    TYPE record<series>
    ASSERT !!$value.id
;

DEFINE FIELD out
    ON TABLE contains
    TYPE record<post>
    ASSERT !!$value.id
;

DEFINE INDEX unique_relation
    ON TABLE contains 
    COLUMNS in, out UNIQUE;