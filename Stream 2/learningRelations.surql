-- Random queries from the stream about relations in SurrealDB

UPDATE book SET series = "The Expanse" WHERE <-(wrote WHERE series=="The Expanse");
UPDATE book SET series = NONE;
UPDATE author SET referenceToSelf = $this.id;

UPDATE book
    SET series = array::distinct((SELECT VALUE <-(wrote WHERE series IS NOT NONE).series FROM $this)[0])
    WHERE <-(wrote WHERE series IS NOT NONE);

UPDATE wrote SET series = NONE;

CREATE author:terrypratchett SET name = 'Terrry Pratchett';
CREATE author:danielabraham SET name = 'Daniel Abraham';
CREATE author:tyfranck SET name = 'Ty Franck';
CREATE author:jamescorey SET name = 'James S. A. Corey';
CREATE author:jrrtolkien SET name = 'JRR Tolkien';
CREATE ONLY author:frankherbert SET name = 'Frank Herbert';

CREATE book:b1 SET name = "Leviathan Wakes";
CREATE book:b2 SET name = "Caliban's War";
CREATE book:b3 SET name = "Abaddon's Gate";
CREATE book:b4 SET name = "Cibola Burn";
CREATE book:b5 SET name = "Nemesis Games";
CREATE book:b6 SET name = "Babylon's Ashes";
CREATE book:b7 SET name = "Persepolis Rising";
CREATE book:b8 SET name = "Tiamat's Wrath";
CREATE book:b9 SET name = "Leviathan Falls";

RELATE [author:danielabraham, author:tyfranck, author:jamescorey]->wrote->[book:b1, book:b2, book:b3, book:b4, book:b5, book:b6, book:b7, book:b8, book:b9] SET series = "The Expanse";

DEFINE FIELD in ON TABLE wrote TYPE record<author|book>;
DEFINE FIELD out ON TABLE wrote TYPE record<author|book>;

RELATE author:terrypratchett->wrote->(array::distinct(SELECT VALUE out FROM wrote WHERE series == "The Expanse"))
    SET reason = "joke";

LET $series = array::group(SELECT VALUE series FROM book WHERE series IS NOT NONE);

FOR $seriesName IN $series {
    LET $seriesId = type::thing("series", string::replace(string::slug($seriesName), "-", ""));
    CREATE $seriesId
        SET name = $seriesName
        RETURN NONE;
    RELATE $seriesId->includes->(SELECT VALUE id FROM book WHERE $seriesName IN series);
};

UPDATE book SET series = NONE;

SELECT VALUE ->includes->book AS books FROM ONLY series WHERE name == "The Expanse" LIMIT 1 FETCH books;

SELECT * FROM book WHERE <-includes<-(series WHERE name == "Disc World");

SELECT *, <-includes<-series.name as series FROM book WHERE count(<-includes) > 1;

DEFINE TABLE loves TYPE RELATION FROM author TO book|author;
INFO FOR DB;
INFO FOR TABLE loves;

SELECT ->cart->product as product_in_cart FROM person:01GF3ZB678900B3AGTRAP7MWZ2 FETCH product_in_cart;


SELECT name, count(<-cart<-person) as carts FROM product;


-- Average number of items in a cart per customer

SELECT math::mean(itemsInCart) AS avgItemsPerCart FROM (SELECT <float>count(->cart) AS itemsInCart FROM person) GROUP ALL;

SELECT first_name, count() as occurrences FROM person GROUP BY first_name;

RELATE (SELECT id FROM person)->cart->product:01G7X22D188KQSZ2EZ73RTQDT8
    SET
    colour = "hard to tell",
    currency = "PLN",
    price = -1,
    product_name = product:01G7X22D188KQSZ2EZ73RTQDT8.name,
    quantity = 23,
    size = "small",
    time.created_at = time::now(),
    time.updated_at = time::now();