DEFINE TABLE OVERWRITE learned
    TYPE RELATION
    SCHEMAFULL
    PERMISSIONS
        FOR select, create, delete WHERE $access = "users" AND in = $auth.id
;

DEFINE FIELD OVERWRITE in
    ON TABLE learned
    TYPE record<user>
    ASSERT $value.exists()
;

DEFINE FIELD OVERWRITE out
    ON TABLE learned
    TYPE record<post>
;

DEFINE FIELD OVERWRITE date
    ON TABLE learned
    TYPE datetime
    VALUE time::now()
    READONLY
;

DEFINE INDEX OVERWRITE unique_relation
    ON TABLE learned 
    COLUMNS in, out UNIQUE;

DEFINE EVENT OVERWRITE on_learn_create ON TABLE learned
    WHEN $event == "CREATE"
    THEN {
        LET $post = $after.out;
        IF !$post.exists() OR $after.draft OR $after.deleted_at {
            THROW "Can't learn something that doesn't exist";
        };
        IF !$post.learnable {
            THROW "Can't learn a non-learnable post";
        };
    }
;