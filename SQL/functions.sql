USE pizzaria;

SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS moeda;

DELIMITER //
CREATE FUNCTION moeda(v FLOAT) RETURNS TEXT
BEGIN
    DECLARE x VARCHAR(20);
    SET x = FORMAT(v, 2, 'de_DE');
    RETURN CONCAT('R$ ', x);
END //
DELIMITER ;

SELECT pizza_id, nome, moeda(valor) AS 'preço' FROM pizzas;