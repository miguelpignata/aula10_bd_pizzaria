DROP DATABASE IF EXISTS pizzaria;
CREATE DATABASE pizzaria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pizzaria;

CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE pizzas (
    pizza_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    valor DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE itens_pedido (
    pedido_id INT NOT NULL,
    pizza_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pedido_id, pizza_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

INSERT INTO clientes (cliente_id, nome, telefone) VALUES
(91, 'Sara Luzia de Melo', '1199999-0001'),
(98, 'Walter Paulo Costenaro', '1199999-0002'),
(99, 'Thamires de Campos Luz', '1199999-0003'),
(100, 'Everton Jose de Souza', '1199999-0004'),
(101, 'Silvia Roberta de Jesus Garcia', '1199999-0005');

INSERT INTO pizzas (pizza_id, nome, valor) VALUES
(5, 'Atum', 32.29),
(28, 'Napolitana', 33.41),
(29, 'Vienense', 38.50),
(30, 'Toscana', 36.00),
(31, 'Canadense', 41.00),
(32, 'Cubana', 39.90);

ALTER TABLE pedidos AUTO_INCREMENT = 27;