USE pizzaria;

-- Garantir que tudo funciona corretamente
INSERT IGNORE INTO clientes (nome, telefone) VALUES
('Claudiane Mendes Trigueiro Silva', '1199999-1001'),
('Diogo Matos da Silva', '1199999-1002'),
('Eder Almeida Batista de Oliveira', '1199999-1003');

INSERT IGNORE INTO pizzas (nome, valor) VALUES
('Aliche', 42.00),
('Firense', 44.50),
('Toscana', 36.00),
('Grega', 39.00),
('Canadense', 41.00),
('Margherita', 35.50);

-- Inserir pedido 1 - Claudiane Mendes Trigueiro Silva (2 Aliche + 1 Firense)
INSERT INTO pedidos (cliente_id, data, hora, valor)
VALUES (
    (SELECT cliente_id FROM clientes WHERE nome = 'Claudiane Mendes Trigueiro Silva' LIMIT 1),
    CURDATE(), NOW(), NULL
);
SET @pedido_claudiane = LAST_INSERT_ID();

INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor) VALUES
(@pedido_claudiane, (SELECT pizza_id FROM pizzas WHERE nome = 'Aliche' LIMIT 1), 2, (SELECT valor FROM pizzas WHERE nome = 'Aliche' LIMIT 1)),
(@pedido_claudiane, (SELECT pizza_id FROM pizzas WHERE nome = 'Firense' LIMIT 1), 1, (SELECT valor FROM pizzas WHERE nome = 'Firense' LIMIT 1));

-- Inserir pedido 2 - Diogo Matos da Silva (2 Toscana + 1 Grega)
INSERT INTO pedidos (cliente_id, data, hora, valor)
VALUES (
    (SELECT cliente_id FROM clientes WHERE nome = 'Diogo Matos da Silva' LIMIT 1),
    CURDATE(), NOW(), NULL
);
SET @pedido_diogo = LAST_INSERT_ID();

INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor) VALUES
(@pedido_diogo, (SELECT pizza_id FROM pizzas WHERE nome = 'Toscana' LIMIT 1), 2, (SELECT valor FROM pizzas WHERE nome = 'Toscana' LIMIT 1)),
(@pedido_diogo, (SELECT pizza_id FROM pizzas WHERE nome = 'Grega' LIMIT 1), 1, (SELECT valor FROM pizzas WHERE nome = 'Grega' LIMIT 1));

-- Inserir pedido 3 - Eder Almeida Batista de Oliveira (1 Canadense + 2 Margherita)
INSERT INTO pedidos (cliente_id, data, hora, valor)
VALUES (
    (SELECT cliente_id FROM clientes WHERE nome = 'Eder Almeida Batista de Oliveira' LIMIT 1),
    CURDATE(), NOW(), NULL
);
SET @pedido_eder = LAST_INSERT_ID();

INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor) VALUES
(@pedido_eder, (SELECT pizza_id FROM pizzas WHERE nome = 'Canadense' LIMIT 1), 1, (SELECT valor FROM pizzas WHERE nome = 'Canadense' LIMIT 1)),
(@pedido_eder, (SELECT pizza_id FROM pizzas WHERE nome = 'Margherita' LIMIT 1), 2, (SELECT valor FROM pizzas WHERE nome = 'Margherita' LIMIT 1));

-- Confere se o triggers.sql calculou corretamente 
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    GROUP_CONCAT(CONCAT(ip.quantidade, 'x ', pz.nome, ' (', moeda(ip.valor), ')') SEPARATOR ' + ') AS itens_do_pedido,
    moeda(SUM(ip.valor * ip.quantidade)) AS soma_esperada,
    moeda(p.valor) AS valor_calculado_pelo_trigger
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
JOIN pizzas pz ON ip.pizza_id = pz.pizza_id
WHERE p.pedido_id IN (@pedido_claudiane, @pedido_diogo, @pedido_eder)
GROUP BY p.pedido_id, c.nome, p.valor;