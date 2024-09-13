DEFINE FUNCTION OVERWRITE fn::purge_deleted() {
    -- How long a record needs to be marked as "deleted"
    -- before it's allowed to be actually deleted
    LET $duration_before_deleted = 30d;
    
    -- Delete series
    DELETE series WHERE !!deleted_at AND deleted_at + $duration_before_deleted <= time::now();

    -- Delete posts
    DELETE post WHERE !!deleted_at AND deleted_at + $duration_before_deleted <= time::now();

    -- Delete topics
    DELETE topic WHERE !!deleted_at AND deleted_at + $duration_before_deleted <= time::now();
}
COMMENT "Deletes all records that have been marked as deleted for more than the specified duration";