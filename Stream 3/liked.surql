DEFINE TABLE liked
    TYPE RELATION
    SCHEMAFULL
;

REMOVE FIELD in ON TABLE liked;
DEFINE FIELD in
    ON TABLE liked
    TYPE record<user>
    ASSERT !!$value.id
;

REMOVE FIELD out ON TABLE liked;
DEFINE FIELD out
    ON TABLE liked
    TYPE record<post|comment>
    ASSERT !!$value.id
;

DEFINE INDEX unique_relation
    ON TABLE liked
    COLUMNS in, out UNIQUE;