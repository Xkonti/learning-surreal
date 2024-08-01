DEFINE TABLE learned
    TYPE RELATION
    SCHEMAFULL
;

REMOVE FIELD in ON TABLE learned;
DEFINE FIELD in
    ON TABLE learned
    TYPE record<user>
    ASSERT !!$value.id
;

REMOVE FIELD out ON TABLE learned;
DEFINE FIELD out
    ON TABLE learned
    TYPE record<post>
    ASSERT !!$value.id AND $value.learnable
;

DEFINE FIELD date
    ON TABLE learned
    TYPE datetime
    VALUE time::now()
    READONLY
;

DEFINE INDEX unique_relation
    ON TABLE learned 
    COLUMNS in, out UNIQUE;