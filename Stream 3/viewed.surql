DEFINE TABLE viewed
    TYPE RELATION
    SCHEMAFULL
;

REMOVE FIELD in ON TABLE viewed;
DEFINE FIELD in
    ON TABLE viewed
    TYPE record<user>
    ASSERT !!$value.id
;

REMOVE FIELD out ON TABLE viewed;
DEFINE FIELD out
    ON TABLE viewed
    TYPE record<post|series|topic>
    ASSERT !!$value.id
;

DEFINE FIELD date
    ON TABLE viewed
    TYPE datetime
    VALUE time::now()
    READONLY
;

-- TODO: Make it keep only last 10 entries for each unique user->thing