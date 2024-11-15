CREATE TABLE new_data(
textvalue VARCHAR(50)
);

INSERT INTO new_data(textvalue)
VALUES("Hello World!");

SELECT 
    textvalue
FROM
    new_data;

