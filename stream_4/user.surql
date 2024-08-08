DEFINE TABLE OVERWRITE user TYPE NORMAL SCHEMAFULL
PERMISSIONS FOR select, delete
    WHERE $access = "users"
    AND id = $auth.id
;

DEFINE FIELD OVERWRITE username
    ON TABLE user
    TYPE string
    ASSERT string::len($value) > 1
;

DEFINE FIELD OVERWRITE email
    ON TABLE user
    TYPE option<string>
    ASSERT $value IS NONE OR string::is::email($value)
;