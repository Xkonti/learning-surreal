DEFINE TABLE OVERWRITE authored
    TYPE RELATION
    IN user OUT post ENFORCED
    SCHEMAFULL
    PERMISSIONS
        FOR select WHERE $access = "users" AND in = $auth.id
;

DEFINE FIELD OVERWRITE notes
    ON TABLE authored
    TYPE option<string>
    DEFAULT NONE
;

DEFINE INDEX OVERWRITE unique_relation
    ON TABLE authored 
    COLUMNS in, out UNIQUE;