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

DEFINE FIELD OVERWRITE author_id
    ON TABLE user
    TYPE option<string>
    DEFAULT NONE
    PERMISSIONS NONE
    COMMENT "An unique ID of the user that persists across multiple database instances - used to identify post authors"
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

-- Make sure the author_id is unique
DEFINE INDEX OVERWRITE unique_author_id
    ON TABLE user 
    COLUMNS author_id
    UNIQUE
;