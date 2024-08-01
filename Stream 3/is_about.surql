DEFINE TABLE is_about
    TYPE RELATION
    FROM post|series TO topic
    SCHEMAFULL
;

DEFINE FIELD in
    ON TABLE is_about
    TYPE record<post|series>
    ASSERT !!$value.id
;

DEFINE FIELD out
    ON TABLE is_about
    TYPE record<topic>
    ASSERT !!$value.id
;

DEFINE INDEX unique_relation
    ON TABLE is_about 
    COLUMNS in, out UNIQUE;