USE pizzaria;

DROP PROCEDURE IF EXISTS atualizaValorPedido;
DELIMITER //
CREATE PROCEDURE atualizaValorPedido(id INT)
BEGIN
    UPDATE pedidos
    SET valor = (SELECT SUM(valor * quantidade) FROM itens_pedido WHERE pedido_id = id)
    WHERE pedido_id = id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS pedidoDeUmItem;

DELIMITER //
CREATE PROCEDURE pedidoDeUmItem(cli_id INT, piz_id INT, qtd INT)
BEGIN
    DECLARE preco_unitario DECIMAL(10,2);
    DECLARE novo_pedido_id INT;

    SELECT valor INTO preco_unitario FROM pizzas WHERE pizza_id = piz_id;

    INSERT INTO pedidos (cliente_id, data, hora, valor)
    VALUES (cli_id, CURDATE(), NOW(), (preco_unitario * qtd));

    SET novo_pedido_id = LAST_INSERT_ID();

    INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor)
    VALUES (novo_pedido_id, piz_id, qtd, preco_unitario);
END //
DELIMITER ;

CALL pedidoDeUmItem(99, 29, 1);
CALL pedidoDeUmItem(100, 30, 2);
CALL pedidoDeUmItem(101, 31, 1);
CALL pedidoDeUmItem(101, 32, 2);
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    pz.nome AS pizza,
    ip.quantidade,
    moeda(p.valor) AS total_pedido
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
JOIN pizzas pz ON ip.pizza_id = pz.pizza_id;