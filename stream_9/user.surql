DEFINE TABLE OVERWRITE user TYPE NORMAL SCHEMAFULL
PERMISSIONS FOR select, delete
    WHERE $access = "users"
    AND id = $auth.id
;

DEFINE FIELD OVERWRITE username
    ON TABLE user
    TYPE string
    ASSERT $value.len() > 1
;

DEFINE FIELD OVERWRITE email
    ON TABLE user
    TYPE option<string>
    ASSERT !$value OR $value.is_email()
;

-- Gets automatically set when the user is created
DEFINE FIELD OVERWRITE created_at
    ON TABLE user
    TYPE datetime
    VALUE time::now()
    READONLY
;

-- Gets automatically set by an event
DEFINE FIELD OVERWRITE updated_at
    ON TABLE user
    TYPE datetime
    VALUE time::now() -- This updates the field automatically
;