USE pizzaria;

DROP TRIGGER IF EXISTS trg_atualiza_valor_pedido;

DELIMITER //
CREATE TRIGGER trg_atualiza_valor_pedido
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor = (
        SELECT SUM(valor * quantidade)
        FROM itens_pedido
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END //
DELIMITER ;

INSERT INTO pedidos (cliente_id, data, hora, valor)
VALUES (101, CURDATE(), NOW(), NULL);

SET @pedido_teste = LAST_INSERT_ID();

SELECT * FROM pedidos WHERE pedido_id = @pedido_teste;

INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor)
VALUES (@pedido_teste, 31, 1, (SELECT valor FROM pizzas WHERE pizza_id = 31));

SELECT pedido_id, cliente_id, moeda(valor) AS valor_apos_item_1 
FROM pedidos WHERE pedido_id = @pedido_teste;

INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor)
VALUES (@pedido_teste, 32, 2, (SELECT valor FROM pizzas WHERE pizza_id = 32));

SELECT pedido_id, cliente_id, moeda(valor) AS valor_final_automatico 
FROM pedidos WHERE pedido_id = @pedido_teste;

SHOW TRIGGERS FROM pizzaria;