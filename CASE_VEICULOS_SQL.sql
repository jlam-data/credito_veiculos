#### Utilizando o MSSQLS, comecei criando a base de dados que vou usar
CREATE DATABASE VEICULOS

USE VEICULOS
GO

--- Alguns arquivos precisaram ser limpos antes de importados, pois tinham erros ou caracteres que dificultavam a leitura do SGBD

#### Para visualizar o crédito concedido a Pessoa Física anualmente pelo Banco Central do Brasil (BACEN)
#### 172 linhas total (começa em 2011-01-03 sistema ano-dia-mês) 
SELECT *
FROM dbo.credito_pf_aquisicao

### 172 linhas (começa em 2011-01-03)
SELECT *
FROM dbo.credito_pf_arrendamento


#### 15 linhas (15 meses)
SELECT 
	YEAR(Ano_dia_mes) AS ANO,
	SUM(valor) AS CREDITO_PF_AQUISICAO
FROM dbo.credito_pf_aquisicao
GROUP BY 
	YEAR(Ano_dia_mes)
ORDER BY ANO


#### 15 linhas
SELECT 
	YEAR(Ano_dia_mes) AS ANO,
	SUM(valor) AS CREDITO_PF_ARRENDAMENTO
FROM dbo.credito_pf_arrendamento
GROUP BY 
	YEAR(Ano_dia_mes)
ORDER BY ANO


### 172 linhas (começa em 2011-01-03)
SELECT *
FROM dbo.inadimplencia_PF_aquisicao


### 172 linhas (começa em 2011-01-03)
SELECT *
FROM dbo.inadimplencia_PF_arrendamento


### 150 linhas (começa em 2011-01-01)
SELECT * 
FROM dbo.indicador_custo_PF_aquisicao


### 150 linhas (começa em 2011-01-01)
SELECT * 
FROM dbo.indicador_custo_PF_arrendamento


### 172 linhas (começa em 2011-01-03)
SELECT *
FROM prazo_pf_aquisicao


### 172 linhas (começa em 2011-01-03)
SELECT *
FROM prazo_pf_arrendamento


### 150 linhas (começa em 2013-01-01)
SELECT * 
FROM dbo.indicador_custo_PJ_aquisicao


### 150 linhas (começa em 2013-01-01)
SELECT * 
FROM dbo.indicador_custo_PJ_arrendamento


#### 15 linhas, 15 meses
SELECT 
	YEAR(data) AS ANO,
	SUM(valor) AS INADIMP_PF_AQUISICAO
FROM dbo.inadimplencia_PF_aquisicao
	YEAR(data)
ORDER BY ANO


### Verificando se está tudo certo com a tabela
### 172 linhas (começa em 2011-01-03)
SELECT *
FROM dbo.credito_pj_aquisicao


### Verificando se está tudo certo com a tabela
### 172 linhas (começa em 2011-01-03)
SELECT *
FROM dbo.credito_pj_arrendamento


#### 426 linhas
SELECT *
FROM dbo.venda_veiculos_concessionarias_total


### 117.012 linhas
SELECT *
FROM dbo.marco_frota


### Para entender quantos carros compunham a frota de Março/2020 em cada UF e município
### 5.569 linhas
SELECT 
	UF, MUNICIPIO, 
	SUM(QUANTIDADE) as FROTA
FROM dbo.FROTA_2020
WHERE QUANTIDADE >= 5
GROUP BY UF, MUNICIPIO
ORDER BY UF asc

SELECT 
	UF, MUNICIPIO, 
	SUM(QUANTIDADE) as FROTA
FROM dbo.FROTA_2020
WHERE QUANTIDADE >= 5
GROUP BY UF, MUNICIPIO
ORDER BY FROTA desc


### Verificando se a tabela foi importada com sucesso
SELECT TOP (5) *
FROM dbo.marco_frota


#### Para entender a quantidade por categoria de veículo
#### 18 linhas
SELECT
	TIPO_DE_VEICULO, SUM(QUANTIDADE) AS TOTAL_VEICULOS
	FROM dbo.marco_frota
WHERE QUANTIDADE >= 100
GROUP BY TIPO_DE_VEICULO
ORDER BY TOTAL_VEICULOS DESC


#### Entendendo a média de veículos por estado
#### 27 linhas - ok (26 estados + distrito federal)
SELECT
UF, AVG(QUANTIDADE) AS MEDIA_VEICULOS
FROM dbo.marco_frota
GROUP BY UF
ORDER BY MEDIA_VEICULOS DESC


### Verificando quantos registros há (são 426 meses = 35,5 anos)
### 426 linhas
SELECT *
FROM dbo.venda_veiculos_concessionarias_total


--- RENOMEANDO COLUNAS - VÁRIAS TABELAS
### Como "data" é uma palavra reservada, mudei o nome da coluna para "Ano_dia_mes", que também é mais explicativo
EXEC sp_rename 'credito_pf_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'credito_pf_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'credito_pj_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'credito_pj_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'inadimplencia_PF_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'inadimplencia_PF_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'inadimplencia_PJ_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'inadimplencia_PJ_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN'; ---verificar
EXEC sp_rename 'indicador_custo_PF_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'indicador_custo_PF_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'indicador_custo_PJ_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'indicador_custo_PJ_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'marco_frota.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'prazo_pf_aquisicao.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'prazo_pf_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'prazo_pj_aquisicao.[column1]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'prazo_pj_arrendamento.[data]', 'Ano_dia_mes', 'COLUMN';
EXEC sp_rename 'venda_veiculos_concessionarias_total.[data]', 'Ano_dia_mes', 'COLUMN';


--- PF_AQUISICAO
### Criando novas tabelas para organizar e dar uma chave-primária (o banco público não tinha)
SELECT
	caq.Ano_dia_mes,
	caq.valor AS credito_aquisicao,
	inad.valor AS inadimplencia,
	prazo.valor AS prazo_aquisicao
INTO
	PF_AQUISICAO
FROM
	dbo.credito_pf_aquisicao AS caq
INNER JOIN 
	dbo.inadimplencia_PF_aquisicao_ AS inad ON inad.Ano_dia_mes = caq.Ano_dia_mes
INNER JOIN
	dbo.prazo_pf_aquisicao AS prazo ON prazo.Ano_dia_mes = caq.Ano_dia_mes


### Verificando se está tudo ok como eu planejei
SELECT *
FROM dbo.PF_AQUISICAO


### Gerando a PK da nova tabela
ALTER TABLE dbo.PF_AQUISICAO
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.PF_AQUISICAO
ADD CONSTRAINT PK_PF_AQUISICAO PRIMARY KEY (codigo);


--- PF_ARRENDAMENTO
### Repetindo o processo para dados de Pessoa física referente a Arrendamento
SELECT
	car.Ano_dia_mes,
	car.valor AS credito_arrendamento,
	inad.valor AS inadimplencia,
	prazo.valor AS prazo_arrendamento
INTO
	PF_ARRENDAMENTO
FROM
	dbo.credito_pf_arrendamento AS car
INNER JOIN 
	dbo.inadimplencia_PF_arrendamento AS inad ON inad.Ano_dia_mes = car.Ano_dia_mes
INNER JOIN
	dbo.prazo_pf_arrendamento AS prazo ON prazo.Ano_dia_mes = car.Ano_dia_mes


### Verificação da tabela gerada
SELECT *
FROM dbo.PF_ARRENDAMENTO


### Chave primária
ALTER TABLE dbo.PF_ARRENDAMENTO
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.PF_ARRENDAMENTO
ADD CONSTRAINT PK_PF_ARRENDAMENTO PRIMARY KEY (codigo);

--- PJ_AQUISICAO
### Novas tabelas de Pessoa Jurídica sobre aquisição
SELECT
	caqj.Ano_dia_mes,
	caqj.valor AS credito_aquisicao,
	inad.valor AS inadimplencia,
	prazo.valor AS prazo_aquisicao
INTO
	PJ_AQUISICAO
FROM
	dbo.credito_pj_aquisicao AS caqj
INNER JOIN 
	dbo.inadimplencia_PJ_aquisicao AS inad ON inad.Ano_dia_mes = caqj.Ano_dia_mes
INNER JOIN
	dbo.prazo_pj_aquisicao AS prazo ON prazo.Ano_dia_mes = caqj.Ano_dia_mes


SELECT * 
FROM dbo.PJ_AQUISICAO


ALTER TABLE dbo.PJ_AQUISICAO
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.PJ_AQUISICAO
ADD CONSTRAINT PK_PJ_AQUISICAO PRIMARY KEY (codigo);

--- PJ_ARRENDAMENTO
### Nova tabela sobre Pessoa Jurídica e Arrendamento
SELECT
	carj.Ano_dia_mes,
	carj.valor AS credito_arrendamento,
	inad.valor AS inadimplencia,
	prazo.valor AS prazo_arrendamento
INTO
	PJ_ARRENDAMENTO
FROM
	dbo.credito_pj_arrendamento AS carj
INNER JOIN 
	dbo.inadimplencia_PJ_arrendamento AS inad ON inad.Ano_dia_mes = carj.Ano_dia_mes
INNER JOIN
	dbo.prazo_pj_arrendamento AS prazo ON prazo.Ano_dia_mes = carj.Ano_dia_mes


SELECT * 
FROM dbo.PJ_ARRENDAMENTO


ALTER TABLE dbo.PJ_ARRENDAMENTO
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.PJ_ARRENDAMENTO
ADD CONSTRAINT PK_PJ_ARRENDAMENTO PRIMARY KEY (codigo);

--- INDICADORES_CUSTO_PF
SELECT * 
FROM dbo.indicador_custo_PF_aquisicao

SELECT
	indca.Ano_dia_mes,
	indca.valor AS Indicador_custo_aquisicao,
	icar.valor AS Indicador_custo_arrendamento
INTO 
	INDICADORES_CUSTO_PF
FROM 
	dbo.indicador_custo_PF_aquisicao AS indca
INNER JOIN 
	dbo.indicador_custo_PF_arrendamento AS icar ON indca.Ano_dia_mes = icar.Ano_dia_mes;


ALTER TABLE dbo.INDICADORES_CUSTO_PF
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.INDICADORES_CUSTO_PF
ADD CONSTRAINT PK_INDICADORES_CUSTO_PF PRIMARY KEY (codigo);


SELECT TOP(5)*
FROM dbo.INDICADORES_CUSTO_PF

--- INDICADORES_CUSTO_PJ
SELECT
	icaq.Ano_dia_mes,
	icaq.valor AS Indicador_custo_aquisicao,
	icar.valor AS Indicador_custo_arrendamento
INTO
	INDICADORES_CUSTO_PJ
FROM
	dbo.indicador_custo_PJ_aquisicao AS icaq 
INNER JOIN 
	dbo.indicador_custo_PJ_arrendamento AS icar ON icar.Ano_dia_mes = icaq.Ano_dia_mes 


SELECT * FROM dbo.INDICADORES_CUSTO_PJ


ALTER TABLE dbo.INDICADORES_CUSTO_PJ
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.INDICADORES_CUSTO_PJ
ADD CONSTRAINT PK_INDICADORES_CUSTO_PJ PRIMARY KEY (codigo);


--- INDICADORES_CUSTO_PF
### Acrescentar colunas para ano e mês
ALTER TABLE dbo.INDICADORES_CUSTO_PF
ADD Ano INT;

UPDATE dbo.INDICADORES_CUSTO_PF
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);


ALTER TABLE dbo.INDICADORES_CUSTO_PF
ADD Mes INT;

UPDATE dbo.INDICADORES_CUSTO_PF
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);


SELECT *
FROM dbo.INDICADORES_CUSTO_PJ

--- INDICADORES_CUSTO_PJ
### Criação de coluna ano
ALTER TABLE dbo.INDICADORES_CUSTO_PJ
ADD Ano INT;

UPDATE dbo.INDICADORES_CUSTO_PJ
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

### Agora para mês
ALTER TABLE dbo.INDICADORES_CUSTO_PJ
ADD Mes INT;

UPDATE dbo.INDICADORES_CUSTO_PJ
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);


SELECT *
FROM dbo.INDICADORES_CUSTO_PJ


--- PF_AQUISICAO
### Criação de coluna ano
ALTER TABLE dbo.PF_AQUISICAO
ADD Ano INT;

UPDATE dbo.PF_AQUISICAO
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

### Agora para mês
ALTER TABLE dbo.PF_AQUISICAO
ADD Mes INT;

UPDATE dbo.PF_AQUISICAO
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);

--- PF_ARRENDAMENTO
### Criação de coluna ano
ALTER TABLE dbo.PF_ARRENDAMENTO
ADD Ano INT;

UPDATE dbo.PF_ARRENDAMENTO
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

### Agora para mês
ALTER TABLE dbo.PF_ARRENDAMENTO
ADD Mes INT;

UPDATE dbo.PF_ARRENDAMENTO
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);

SELECT TOP(5)*
FROM dbo.PF_ARRENDAMENTO


ALTER TABLE dbo.PF_ARRENDAMENTO
ADD codigo INT IDENTITY  (1,1) NOT NULL;

ALTER TABLE dbo.PF_ARRENDAMENTO
ADD CONSTRAINT PK_PF_ARRENDAMENTO PRIMARY KEY (codigo);


select top(5)*
from dbo.PJ_AQUISICAO

----PJ_AQUISICAO
### Criação de coluna ano
ALTER TABLE dbo.PJ_AQUISICAO
ADD Ano INT;

UPDATE dbo.PJ_AQUISICAO
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

### Agora para mês
ALTER TABLE dbo.PJ_AQUISICAO
ADD Mes INT;

UPDATE dbo.PJ_AQUISICAO
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);

--- PJ_ARRENDAMENTO
select top(5)*
from dbo.PJ_ARRENDAMENTO

### Criação de coluna ano
ALTER TABLE dbo.PJ_ARRENDAMENTO
ADD Ano INT;

UPDATE dbo.PJ_ARRENDAMENTO
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

### Agora para mês
ALTER TABLE dbo.PJ_ARRENDAMENTO
ADD Mes INT;

UPDATE dbo.PJ_ARRENDAMENTO
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);

---- VERIFICANDO TABELA venda_veiculos_concessionarias_total
SELECT TOP(5) *
FROM dbo.venda_veiculos_concessionarias_total

ALTER TABLE dbo.venda_veiculos_concessionarias_total
ADD Ano INT;

UPDATE dbo.venda_veiculos_concessionarias_total
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

### Agora para mês
ALTER TABLE dbo.venda_veiculos_concessionarias_total
ADD Mes INT;

UPDATE dbo.venda_veiculos_concessionarias_total
SET
    Mes = CAST(RIGHT(Ano_dia_mes, 2) AS INT);

### Colocando coluna de código
ALTER TABLE dbo.venda_veiculos_concessionarias_total
ADD codigo INT IDENTITY NOT NULL;

ALTER TABLE dbo.venda_veiculos_concessionarias_total
ADD CONSTRAINT PK_venda_veiculos_concessionarias_total PRIMARY KEY (codigo)

SELECT TOP(5)*
FROM dbo.VENDAS_VEICULOS_CONCESSIONARIAS


### Trabalhando formato do período
ALTER TABLE dbo.VENDAS_VEICULOS_CONCESSIONARIAS
ADD Periodo VARCHAR(7);

UPDATE dbo.VENDAS_VEICULOS_CONCESSIONARIAS
SET
    Ano = CAST(LEFT(Ano_dia_mes, CHARINDEX('-', Ano_dia_mes) - 1) AS INT);

UPDATE dbo.VENDAS_VEICULOS_CONCESSIONARIAS
SET
    Periodo = TRY_CONVERT(DATE, '01-' + Periodo, 105)

EXEC sp_help 'dbo.VENDAS_VEICULOS_CONCESSIONARIAS
'

--- NOVA COLUNA DE DATA PARA TABELA INDICADORES_CUSTO_PF
SELECT TOP(5)*
FROM dbo.INDICADORES_CUSTO_PF

ALTER TABLE dbo.INDICADORES_CUSTO_PF
ADD Periodo VARCHAR (7)

UPDATE dbo.INDICADORES_CUSTO_PF
SET
    Periodo = FORMAT(TRY_CAST(Ano_dia_mes AS DATE), 'MM-yyyy')
WHERE
    Ano_dia_mes IS NOT NULL;


--- Conferindo se as tabelas têm dados nulos
SELECT *
FROM dbo.FROTA_2020 
WHERE 
	UF IS NULL OR
	MUNICIPIO IS NULL OR
	TIPO_DE_VEICULO IS NULL OR 
	QUANTIDADE IS NULL


SELECT *
FROM dbo.INDICADORES_CUSTO_PF
WHERE 
	Ano_dia_mes IS NULL OR
	Indicador_custo_aquisicao IS NULL OR
	Indicador_custo_arrendamento IS NULL OR 
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL


SELECT *
FROM dbo.INDICADORES_CUSTO_PJ
WHERE 
	Ano_dia_mes IS NULL OR
	Indicador_custo_aquisicao IS NULL OR
	Indicador_custo_arrendamento IS NULL OR 
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL


SELECT *
FROM dbo.PF_AQUISICAO
WHERE 
	Ano_dia_mes IS NULL OR
	credito_aquisicao IS NULL OR
	inadimplencia IS NULL OR 
	prazo_aquisicao IS NULL OR 
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL

	
SELECT *
FROM dbo.PF_ARRENDAMENTO
WHERE 
	Ano_dia_mes IS NULL OR
	credito_arrendamento IS NULL OR
	inadimplencia IS NULL OR 
	prazo_arrendamento IS NULL OR 
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL


SELECT *
FROM dbo.PJ_AQUISICAO
WHERE 
	Ano_dia_mes IS NULL OR
	credito_aquisicao IS NULL OR
	inadimplencia IS NULL OR 
	prazo_aquisicao IS NULL OR 
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL


SELECT *
FROM dbo.PJ_ARRENDAMENTO
WHERE 
	Ano_dia_mes IS NULL OR
	credito_arrendamento IS NULL OR
	inadimplencia IS NULL OR 
	prazo_arrendamento IS NULL OR 
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL
	

SELECT *
FROM dbo.VENDAS_VEICULOS_CONCESSIONARIAS
WHERE 
	Ano_dia_mes IS NULL OR
	valor IS NULL OR
	codigo IS NULL OR
	Ano IS NULL OR
	Mes IS NULL OR
	Periodo IS NULL
