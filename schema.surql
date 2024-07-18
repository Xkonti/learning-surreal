DEFINE TABLE user SCHEMAFULL;
DEFINE FIELD name ON user TYPE string;

DEFINE TABLE post SCHEMAFULL;
DEFINE FIELD author ON post TYPE record<user>;
DEFINE FIELD name ON post TYPE string;
DEFINE FIELD slug ON post TYPE string DEFAULT string::slug(name);
DEFINE FIELD tags ON post TYPE array<string> DEFAULT [];
DEFINE FIELD related_posts ON post TYPE array<record<post>> DEFAULT [];
DEFINE FIELD required_knowledge ON post TYPE array<record<post>> DEFAULT [];
DEFINE FIELD is_knowledge ON post TYPE boolean DEFAULT false;
DEFINE INDEX postSlugIndex ON TABLE post COLUMNS slug UNIQUE;

DEFINE TABLE comment SCHEMAFULL;
DEFINE FIELD author ON comment TYPE record<user>;
DEFINE FIELD post ON comment TYPE record<post>;
DEFINE FIELD parent ON comment TYPE option<record<comment>> DEFAULT NONE;
DEFINE FIELD text ON comment TYPE string;
DEFINE FIELD created_at ON comment TYPE datetime VALUE time::now() READONLY;

