DEFINE TABLE OVERWRITE requires
    TYPE RELATION
    SCHEMAFULL
    COMMENT "Whether a post requires the knowledge from another post"
;

DEFINE FIELD OVERWRITE in
    ON TABLE requires
    TYPE record<post>
    ASSERT $value != out AND $value.exists()
;

DEFINE FIELD OVERWRITE out
    ON TABLE requires
    TYPE record<post>
    ASSERT $value != in AND $value.exists() AND $value.learnable
;

DEFINE INDEX OVERWRITE unique_post_requirements 
    ON TABLE requires 
    COLUMNS in, out UNIQUE;