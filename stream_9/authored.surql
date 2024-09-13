DEFINE TABLE OVERWRITE authored
    TYPE RELATION
    IN user OUT post ENFORCED
    SCHEMAFULL
    PERMISSIONS
        FOR select WHERE $access = "users" AND in = $auth.id
;

DEFINE FIELD OVERWRITE last_update_id
    ON TABLE authored
    TYPE uuid
    COMMENT "The ID of the last update to the relation - used to detect deleted relations"
;

DEFINE INDEX OVERWRITE unique_relation
    ON TABLE authored 
    COLUMNS in, out UNIQUE;