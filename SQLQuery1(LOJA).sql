/*TABLES*/

CREATE TABLE Pessoa(
	idPessoa int NOT NULL,
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
	idPessoa_Fisica INT PRIMARY KEY,
    CPF varchar(11) NOT NULL,
	idPessoa int,
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa) 
); 


CREATE INDEX PessoaFisica_FKIndex ON Pessoa_Fisica(idPessoa); 

CREATE INDEX IFK_PessoaFisica ON Pessoa_Fisica (idPessoa);  


CREATE TABLE Pessoa_Juridica(
    idPessoa_Juridica INT PRIMARY KEY,
    CNPJ varchar(14) NOT NULL,
	idPessoa int,
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
); 

CREATE INDEX PessoaJuridica_FKIndex ON Pessoa_Juridica (idPessoa); 

CREATE INDEX IFK_PessoaJuridica ON Pessoa_Juridica (idPessoa); 


CREATE TABLE Produto (
    idProduto INT IDENTITY PRIMARY KEY ,
    nome VARCHAR(255),
    quantidade INT,
    precoVenda NUMERIC(10, 2)
); 

CREATE TABLE Usuario(
    idUsuario INT IDENTITY PRIMARY KEY ,
    Logar VARCHAR(255) not null,
    Senha VARCHAR(25) not null
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

CREATE INDEX Movimento_FKIndex1 ON Movimento (idUsuario); 

CREATE INDEX Movimento_FKIndex2 ON Movimento (idPessoa); 

CREATE INDEX Movimento_FKIndex3 ON movimento (idProduto); 

CREATE INDEX IFK_Responsavel ON Movimento (idUsuario); 

CREATE INDEX IFK_Cliente ON Movimento (idPessoa); 

CREATE INDEX IFK_ItemMovimentado ON Movimento (idProduto); 


/*INSERT INTO*/

INSERT INTO Usuario (Logar, Senha) VALUES ( 'op1', 'op1'); 
INSERT INTO Usuario (Logar, Senha)VALUES ( 'op2', 'op2');
INSERT INTO Usuario (Logar, Senha)VALUES ( 'op3', 'op3');
INSERT INTO Usuario (Logar, Senha)VALUES ( 'op4', 'op4');

INSERT INTO Produto VALUES 
( 'Banana', 100, 5.00),
('Maçã', 300, 3.50),
('Laranja', 500, 2.00),
('Manga', 800, 4.00);

SELECT * FROM Usuario;



DECLARE @IdPessoa int;
SET @IdPessoa = Next value for seq_Pessoa;


INSERT INTO Pessoa
(idPessoa, nome, logradouro,cidade, estado, telefone, email)
VALUES 
(@IdPessoa, 'Ferdinando','Rua 21, casa 411, Japiim', 'Manaus', 'AM', '921313-1313','Toro@Ferdinando.com');

INSERT INTO Pessoa_Fisica 
(idPessoa_Fisica, CPF)
VALUES
(@IdPessoa, '78945612378');


INSERT INTO Pessoa
(idPessoa, nome, logradouro,cidade, estado, telefone, email)
VALUES 
(@IdPessoa, 'JJC', 'Rua 11, Centro', 'Riacho do Norte', 'PA', '1212-1212', 'jjc@riacho.com');

INSERT INTO Pessoa_Juridica
(idPessoa_Juridica, CNPJ)
VALUES
(@IdPessoa, '15915915945682');



INSERT INTO Pessoa
(idPessoa, nome, logradouro,cidade, estado, telefone, email)
VALUES 
(@IdPessoa, 'Marta','Rua 31 de março, 504', 'Manaus', 'AM', '1212-2525', 'Marta@toledo.com');

INSERT INTO Pessoa_Fisica 
(idPessoa_Fisica, CPF)
VALUES
(@IdPessoa, '15935862475');




INSERT INTO Pessoa
(idPessoa, nome, logradouro,cidade, estado, telefone, email)
VALUES
(@IdPessoa, 'Smart', 'Laranjeiras, 0000', 'Manaus', 'AM','4585-9674', 'Smart@CIA.com');

INSERT INTO Pessoa_Juridica
(idPessoa_Juridica, CNPJ)
VALUES
(@IdPessoa, '4569871236985');






INSERT INTO Movimento(idPessoa, idUsuario, idProduto, quantidade, tipo, valorUnitario)
	VALUES	(1,1,1,12,'S',4.00),
			(2,2,2,2,'S',3.00),
			(4,3,3,35,'E',4.00),
			(5,4,4,25,'E',6.00);

SELECT * FROM Movimento;


/*DADOS*/

SELECT * FROM Usuario;
SELECT * FROM Produto;
SELECT * FROM Pessoa;
SELECT * FROM Pessoa_Fisica;
SELECT * FROM Pessoa_Juridica;
SELECT * FROM Movimento;

SELECT * FROM Pessoa 
inner join Pessoa_Fisica ON (Pessoa.idPessoa = Pessoa_Fisica.idPessoa);

SELECT * FROM Pessoa 
inner join Pessoa_Juridica ON (Pessoa.idPessoa = Pessoa_Juridica.idPessoa);

SELECT 
	p.nome, 
	pe.nome, 
	m.quantidade, 
	m.valorUnitario, 
	m.quantidade * m.valorUnitario AS ValorTotal 
FROM Movimento AS m
inner join Produto AS p ON (m.idProduto = p.idProduto)
inner join Pessoa AS pe ON (m.idPessoa = pe.idPessoa)
WHERE tipo = 'S'

SELECT 
	p.nome, 
	pe.nome, 
	m.quantidade, 
	m.valorUnitario, 
	m.quantidade * m.valorUnitario AS ValorTotal 
FROM Movimento AS m
inner join Produto AS p ON (m.idProduto = p.idProduto)
inner join Pessoa AS pe ON (m.idPessoa = pe.idPessoa)
WHERE tipo = 'E'


SELECT pdt.nome, SUM(m.quantidade * m.valorUnitario) as valor_total
FROM Movimento m
INNER JOIN Produto pdt ON m.idProduto = pdt.idProduto
WHERE m.tipo = 'S'
GROUP BY pdt.nome;

SELECT pdt.nome, SUM(m.quantidade * m.valorUnitario) as Valor_total
FROM Movimento m
INNER JOIN Produto pdt ON m.idProduto = pdt.idProduto
WHERE m.tipo = 'E'
GROUP BY pdt.nome;

SELECT u.idUsuario, u.Logar FROM 
	(SELECT idUsuario FROM Usuario
	EXCEPT   
	SELECT idUsuario FROM Movimento AS m
	WHERE m.tipo = 'E') AS UserSemMovimento
inner join Usuario AS u ON (u.idUsuario = UserSemMovimento.idUsuario);

SELECT u.*
FROM Usuario u
LEFT JOIN Movimento m ON u.idUsuario = m.idUsuario AND m.tipo = 'E'
WHERE m.idMovimento is null;

SELECT u.Logar, sum(quantidade * valorUnitario) AS Valor_Total 
FROM Movimento AS m
inner join Usuario AS u ON (m.idUsuario = u.idUsuario)
WHERE m.tipo = 'E'
GROUP BY u.Logar

SELECT u.Logar, sum(quantidade * valorUnitario) AS ValorTotal 
FROM Movimento AS m
inner join Usuario AS u ON (m.idUsuario = u.idUsuario)
WHERE m.tipo = 'S'
GROUP BY u.Logar

SELECT p.nome,  sum(m.quantidade * valorUnitario)/sum(m.quantidade) AS ValorTotal 
FROM Movimento AS m
inner join Produto AS p ON (m.idProduto = p.idProduto)
WHERE m.tipo = 'S'
GROUP BY p.nome

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

