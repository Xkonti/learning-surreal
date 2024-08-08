DEFINE ACCESS OVERWRITE users ON DATABASE TYPE RECORD
    WITH JWT ALGORITHM RS256 KEY "-----BEGIN PUBLIC KEY-----
YOUR_PUBLIC_KEY_HERE
-----END PUBLIC KEY-----"
    AUTHENTICATE {
        LET $userId = <record>$token.ID;
        UPSERT $userId SET
            username = $token.name,
            email = $token.email
        ;
        RETURN $userId;
    }
;