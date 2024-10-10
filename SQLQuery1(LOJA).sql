
-- TABLES

CREATE TABLE Pessoa(
	idPessoa int,
	nome varchar(255) not null,
	logradouro varchar(255),
	cidade varchar(255),
	estado char(2),
	telefone varchar(11),
	email varchar(255),
	PRIMARY KEY (idPessoa) 
);

CREATE SEQUENCE seq_Pessoa AS INT
START WITH 1 
INCREMENT BY 1 
MINVALUE 1 
MAXVALUE 1000000 
NO CYCLE 
CACHE 5;

CREATE TABLE Pessoa_Fisica(
	idPessoa_Fisica int PRIMARY KEY,
    CPF varchar(11) NOT NULL,
	idPessoa int,
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE Pessoa_Juridica(
    idPessoa_Juridica int PRIMARY KEY,
    CNPJ varchar(14) NOT NULL,
	idPessoa int,
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE Produto (
    idProduto INT PRIMARY KEY,
    nome VARCHAR(255),
    quantidade INT,
    precoVenda NUMERIC(10, 2)
);

CREATE TABLE Usuario(
    idUsuario INT PRIMARY KEY,
    Logar VARCHAR(255),
    Senha VARCHAR(25)
);


CREATE TABLE Movimento(
    idMovimento INT IDENTITY(1,1) PRIMARY KEY,
    idPessoa INT,
	idUsuario INT,
    idProduto INT,
	quantidade INT,
	tipo CHAR(1),
    valorUnitario FLOAT,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa),
    FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
);



--iNSERT INTO

INSERT INTO Usuario VALUES 
(1, 'op1', 'op1'), 
(2, 'op2', 'op2');

INSERT INTO Usuario VALUES
(3, 'op3', 'op3'),
(4, 'op4', 'op4');

INSERT INTO Produto VALUES 
(1, 'Banana', 100, 5.00),
(2, 'Maçã', 300, 3.50),
(3, 'Laranja', 500, 2.00),
(4, 'Manga', 800, 4.00);

select * from Usuario;
Select * from Produto;



INSERT INTO Movimento(idPessoa, idUsuario, idProduto, quantidade, tipo, valorUnitario)
	VALUES	(8,1,1,12,'S',4.00),
			(9,2,2,2,'S',3.00),
			(10,3,3,35,'E',4.00),
			(11,4,4,25,'E',6.00);




INSERT INTO Pessoa
(idPessoa, nome, logradouro,cidade, estado, telefone, email)
values 
(next value for seq_Pessoa,'Ferdinando','Rua 21, casa 411, Japiim', 'Manaus', 'AM', '921313-1313','Toro@Ferdinando.com'),
(next value for seq_Pessoa, 'JJC', 'Rua 11, Centro', 'Riacho do Norte', 'PA', '1212-1212', 'jjc@riacho.com');  

INSERT INTO Pessoa
(idPessoa, nome, logradouro,cidade, estado, telefone, email)
values
(next value for seq_Pessoa, 'Marta','Rua 31 de março, 504', 'Manaus', 'AM', '1212-2525', 'Marta@toledo.com'),
(next value for seq_Pessoa, 'Smart', 'Laranjeiras, 0000', 'Manaus', 'AM','4585-9674', 'Smart@CIA.com')
;


DECLARE @IdPessoa int;
SET @IdPessoa = Next value for seq_Pessoa; 

INSERT INTO Pessoa_Fisica
(idPessoa_Fisica, CPF)
VALUES 
(@IdPessoa, '78945612378');

INSERT INTO Pessoa_Juridica
(idPessoa_Juridica, CNPJ)
VALUES
(@IdPessoa, '15915915945682');


--DADOS

SELECT * FROM Usuario;
SELECT * FROM Produto;
SELECT * FROM Pessoa;
SELECT * FROM Pessoa_Fisica;
SELECT * FROM Pessoa_Juridica;
SELECT * FROM Movimento;




SELECT p.*, pf.cpf 
FROM Pessoa p
INNER JOIN Pessoa_Fisica pf ON p.idPessoa = pf.idPessoa;

SELECT p.*, pj.cnpj 
FROM Pessoa p
INNER JOIN Pessoa_Juridica pj ON p.idPessoa = pj.idPessoa;

SELECT m.*, p.nome as fornecedor, pdt.nome as Produto, m.quantidade, m.valorUnitario, (m.quantidade * m.valorUnitario) as total
FROM Movimento m
INNER JOIN Pessoa p ON p.idPessoa = m.idPessoa
INNER JOIN Produto pdt ON pdt.idProduto = m.idProduto
WHERE m.tipo = 'E';


SELECT m.*, p.nome as comprador, pdt.nome as Produto, m.quantidade, m.valorUnitario, (m.quantidade * m.valorUnitario) as total
FROM Movimento m
INNER JOIN Pessoa p ON m.idPessoa = p.idPessoa
INNER JOIN Produto pdt ON m.idProduto = pdt.idProduto
WHERE m.tipo = 'S';

SELECT pdt.nome, SUM(m.quantidade * m.valorUnitario) as totValor
FROM Movimento m
INNER JOIN Produto pdt ON m.idProduto = pdt.idProduto
WHERE m.tipo = 'E'
GROUP BY pdt.nome;

SELECT pdt.nome, SUM(m.quantidade * m.valorUnitario) as valor_total
FROM Movimento m
INNER JOIN Produto pdt ON m.idProduto = pdt.idProduto
WHERE m.tipo = 'S'
GROUP BY pdt.nome;

SELECT u.*
FROM Usuario u
LEFT JOIN Movimento m ON u.idUsuario = m.idUsuario AND m.tipo = 'E'
WHERE m.idMovimento is null;



