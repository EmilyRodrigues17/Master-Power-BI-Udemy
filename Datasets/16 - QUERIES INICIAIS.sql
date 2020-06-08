------------------------------------------------
-- DIFEREN�A ENTRE FATOS E DIMENSOES
------------------------------------------------

USE AdventureWorksDW2017
GO

SELECT * FROM DimCustomer
GO

SELECT * FROM DimCurrency
GO

SELECT * FROM FactInternetSales
GO

SELECT FIRSTNAME, LASTNAME, YEARLYINCOME, CURRENCYNAME, ORDERQUANTITY, SALESAMOUNT
FROM DimCustomer DC
INNER JOIN FactInternetSales FS
ON DC.CustomerKey = FS.CustomerKey
INNER JOIN DimCurrency DIC
ON DIC.CurrencyKey = FS.CurrencyKey
ORDER BY FIRSTNAME, LASTNAME
GO

-------------------------------------------------------------
--- JOINS E RELACIONAMENTOS
-------------------------------------------------------------

CREATE DATABASE CLINICA
GO

USE CLINICA
GO

CREATE TABLE PACIENTE(
	IDPACIENTE INT PRIMARY KEY,
	NOME VARCHAR(30),
	SEXO CHAR(1)
)
GO

CREATE TABLE ENDERECO(
	IDENDERECO INT PRIMARY KEY,
	RUA VARCHAR(30),
	BAIRRO VARCHAR(30),
	CIDADE VARCHAR(30),
	ID_PACIENTE INT UNIQUE
)
GO

ALTER TABLE ENDERECO ADD
FOREIGN KEY(ID_PACIENTE)
REFERENCES PACIENTE(IDPACIENTE)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY,
	TIPO CHAR(3),
	NUMERO CHAR(6),
	ID_PACIENTE INT
)
GO

ALTER TABLE TELEFONE ADD
FOREIGN KEY(ID_PACIENTE)
REFERENCES PACIENTE(IDPACIENTE)
GO

INSERT INTO PACIENTE VALUES(1,'ANA','F')
INSERT INTO PACIENTE VALUES(2,'JOAO','M')
INSERT INTO PACIENTE VALUES(3,'CARLOS','M')
INSERT INTO PACIENTE VALUES(4,'JULIA','F')
GO

INSERT INTO ENDERECO VALUES(1,'RUA ALMEIDA, 35','CENTRO','SAO PAULO',1)
INSERT INTO ENDERECO VALUES(2,'RUA CARAVELAS, 42','MOEMA','SAO PAULO',3)
INSERT INTO ENDERECO VALUES(3,'RUA DAS FLORES, 23','JARDINS','SAO PAULO',4)
INSERT INTO ENDERECO VALUES(4,'AV. PRES. CARLOS, 124','MORUMBI','SAO PAULO',2)
GO

INSERT INTO TELEFONE VALUES(1,'CEL','453435',1)
INSERT INTO TELEFONE VALUES(2,'RES','215485',1)
INSERT INTO TELEFONE VALUES(3,'COM','887458',1)
INSERT INTO TELEFONE VALUES(4,'CEL','665632',2)
INSERT INTO TELEFONE VALUES(5,'RES','665842',2)
INSERT INTO TELEFONE VALUES(6,'COM','887458',3)
GO



------------------------------------------------------------------
---------- RELACIONAMENTOS 1 X 1
------------------------------------------------------------------

------------------------------------------------------------------
-----------  JUN�AO INTERNA
------------------------------------------------------------------

SELECT NOME, SEXO, IDPACIENTE, RUA, BAIRRO, CIDADE
FROM PACIENTE
INNER JOIN ENDERECO
ON IDPACIENTE = ID_PACIENTE
GO

------------------------------------------------------------------
-----------  RELACIONAMENTOS 1 X N
------------------------------------------------------------------

------------------------------------------------------------------
-----------  JUN�AO ESQUERDA
------------------------------------------------------------------

SELECT NOME, SEXO, TIPO, NUMERO
FROM PACIENTE
INNER JOIN TELEFONE
ON IDPACIENTE = ID_PACIENTE
GO

SELECT NOME, SEXO, TIPO, NUMERO
FROM PACIENTE
LEFT JOIN TELEFONE
ON IDPACIENTE = ID_PACIENTE
GO

------------------------------------------------------------------
-----------  RELACIONAMENTOS M X N MUITOS PARA MUITOS
------------------------------------------------------------------

CREATE TABLE MEDICO(
	IDMEDICO INT PRIMARY KEY,
	NOME VARCHAR(30),
	ESPECIALIDADE VARCHAR(30)
)
GO

INSERT INTO MEDICO VALUES(1,'JORDAN','CARDIOLOGIA')
INSERT INTO MEDICO VALUES(2,'MARCIA','ENDOCRINOLOGIA')
INSERT INTO MEDICO VALUES(3,'BRUNA','NEFROLOGIA')
INSERT INTO MEDICO VALUES(4,'ANDRE','CLINICO GERAL')
GO

CREATE TABLE CONSULTA(
	IDCONSULTA INT PRIMARY KEY IDENTITY,
	ID_PACIENTE INT,
	ID_MEDICO INT,
	DATA DATE
)
GO

ALTER TABLE CONSULTA ADD 
FOREIGN KEY(ID_PACIENTE)
REFERENCES PACIENTE(IDPACIENTE)
GO

ALTER TABLE CONSULTA ADD 
FOREIGN KEY(ID_MEDICO)
REFERENCES MEDICO(IDMEDICO)
GO

INSERT INTO CONSULTA VALUES(1,2,'03/05/2019')
INSERT INTO CONSULTA VALUES(1,3,'10/06/2019')
INSERT INTO CONSULTA VALUES(1,4,'11/07/2019')
INSERT INTO CONSULTA VALUES(3,2,'23/05/2019')
INSERT INTO CONSULTA VALUES(3,2,'15/04/2019')
INSERT INTO CONSULTA VALUES(4,3,'16/02/2019')
INSERT INTO CONSULTA VALUES(4,4,'29/08/2019')
GO

SELECT P.NOME AS PACIENTE,
	   M.NOME AS MEDICO,
	   ESPECIALIDADE,
	   DATA
	   FROM PACIENTE P
	   INNER JOIN CONSULTA C
	   ON P.IDPACIENTE = C.ID_PACIENTE
	   INNER JOIN MEDICO M
	   ON M.IDMEDICO = C.ID_MEDICO
	   GO

SELECT P.NOME AS PACIENTE,
	   M.NOME AS MEDICO,
	   ESPECIALIDADE,
	   DATA
	   FROM PACIENTE P
	   LEFT JOIN CONSULTA C
	   ON P.IDPACIENTE = C.ID_PACIENTE
	   LEFT JOIN MEDICO M
	   ON M.IDMEDICO = C.ID_MEDICO
	   GO

SELECT P.NOME AS PACIENTE,
	   M.NOME AS MEDICO,
	   ESPECIALIDADE,
	   DATA
	   FROM PACIENTE P
	   RIGHT JOIN CONSULTA C
	   ON P.IDPACIENTE = C.ID_PACIENTE
	   RIGHT JOIN MEDICO M
	   ON M.IDMEDICO = C.ID_MEDICO
	   GO

SELECT P.NOME AS PACIENTE,
	   M.NOME AS MEDICO,
	   ESPECIALIDADE,
	   DATA
	   FROM PACIENTE P
	   FULL JOIN CONSULTA C
	   ON P.IDPACIENTE = C.ID_PACIENTE
	   FULL JOIN MEDICO M
	   ON M.IDMEDICO = C.ID_MEDICO
	   GO

-------------------------------------------------------
--- APENAS QUEM NAO TEVE ATENDIMENTO
-------------------------------------------------------


SELECT P.NOME AS PACIENTE,
	   M.NOME AS MEDICO,
	   ESPECIALIDADE,
	   DATA
	   FROM PACIENTE P
	   LEFT JOIN CONSULTA C
	   ON P.IDPACIENTE = C.ID_PACIENTE
	   LEFT JOIN MEDICO M
	   ON M.IDMEDICO = C.ID_MEDICO
	   WHERE IDMEDICO IS NULL
	   GO

-------------------------------------------------------
--- MEDICOS QUE NAO ATENDERAM
-------------------------------------------------------


SELECT P.NOME AS PACIENTE,
	   M.NOME AS MEDICO,
	   ESPECIALIDADE,
	   DATA
	   FROM PACIENTE P
	   RIGHT JOIN CONSULTA C
	   ON P.IDPACIENTE = C.ID_PACIENTE
	   RIGHT JOIN MEDICO M
	   ON M.IDMEDICO = C.ID_MEDICO
	   WHERE IDPACIENTE IS NULL
	   GO