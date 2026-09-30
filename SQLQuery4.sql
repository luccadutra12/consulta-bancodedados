-- ============================================
-- ATIVIDADE 8 - AGROINDÚSTRIA
-- SQL SERVER
-- ============================================

-- 1. APAGAR O BANCO SE JÁ EXISTIR
USE master;
GO

DROP DATABASE IF EXISTS agroindustria_db;
GO

-- 2. CRIAR O BANCO
CREATE DATABASE agroindustria_db;
GO

USE agroindustria_db;
GO

-- 3. CRIAR A TABELA SETOR
CREATE TABLE setor (
    id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(40) NOT NULL,
    descricao VARCHAR(MAX)
);
GO

-- 4. CRIAR A TABELA MEDIDAS
CREATE TABLE medidas (
    id INT PRIMARY KEY IDENTITY(1,1),
    id_setor INT NOT NULL,
    data_hora DATETIME NOT NULL,
    variavel VARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_setor) REFERENCES setor(id)
);
GO

-- 5. CADASTRAR OS SETORES
INSERT INTO setor (nome, descricao) VALUES
('Moagem', 'Responsável pela extração do caldo da cana-de-açúcar.'),
('Clarificação', 'Remove impurezas do caldo e ajusta pH.'),
('Evaporação', 'Concentra o caldo por remoção de água.'),
('Fermentação', 'Converte açúcares em etanol através de leveduras.'),
('Destilação', 'Separa o etanol produzido na fermentação.'),
('Caldeira', 'Gera vapor para os processos industriais.');
GO

-- 6. CADASTRAR AS MEDIÇÕES
INSERT INTO medidas (id_setor, data_hora, variavel, valor) VALUES
(1, '2025-10-09 08:00:00', 'VAZÃO', 210.50),
(1, '2025-10-09 08:10:00', 'TEMP', 32.80),
(2, '2025-10-09 08:20:00', 'PH', 6.45),
(2, '2025-10-09 08:30:00', 'BRIX', 13.20),
(3, '2025-10-09 08:40:00', 'TEMP', 78.50),
(3, '2025-10-09 08:50:00', 'BRIX', 36.70),
(4, '2025-10-09 09:00:00', 'PH', 4.60),
(4, '2025-10-09 09:10:00', 'TEMP', 33.90),
(5, '2025-10-09 09:20:00', 'ETOH', 92.10),
(6, '2025-10-09 09:30:00', 'PRESSÃO', 17.80);
GO

-- ============================================
-- CONSULTAS BÁSICAS
-- ============================================

-- Mostrar todos os setores
SELECT * FROM setor;

-- Mostrar todas as medidas
SELECT * FROM medidas;


-- ============================================
-- QUESTÃO 1
-- ID, variável e valor da mais recente
-- para a mais antiga
-- ============================================

SELECT id, variavel, valor
FROM medidas
ORDER BY data_hora DESC;


-- ============================================
-- QUESTÃO 2
-- Medições de TEMP do maior para o menor
-- ============================================

SELECT *
FROM medidas
WHERE variavel = 'TEMP'
ORDER BY valor DESC;


-- ============================================
-- QUESTÃO 3
-- BRIX entre 30 e 80
-- ============================================

SELECT *
FROM medidas
WHERE variavel = 'BRIX'
AND valor BETWEEN 30 AND 80
ORDER BY valor ASC;


-- ============================================
-- QUESTÃO 4
-- Quantidade de medidas de cada variável
-- ============================================

SELECT variavel, COUNT(*) AS quantidade
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY quantidade DESC;


-- ============================================
-- QUESTÃO 5
-- Valor médio de cada variável
-- ============================================

SELECT variavel, AVG(valor) AS media
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY media DESC;


-- ============================================
-- QUESTÃO 6
-- Menor e maior valor de cada variável
-- ============================================

SELECT 
    variavel,
    MIN(valor) AS menor_valor,
    MAX(valor) AS maior_valor
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY variavel ASC;


-- ============================================
-- QUESTÃO 7
-- Média de TEMP por setor
-- ============================================

SELECT 
    setor.nome,
    AVG(medidas.valor) AS media_temperatura
FROM medidas
INNER JOIN setor
    ON medidas.id_setor = setor.id
WHERE medidas.variavel = 'TEMP'
GROUP BY setor.nome
ORDER BY media_temperatura DESC;


-- ============================================
-- QUESTÃO 8
-- Maior e menor ETOH por setor
-- ============================================

SELECT 
    setor.nome,
    MIN(medidas.valor) AS menor_etoh,
    MAX(medidas.valor) AS maior_etoh
FROM medidas
INNER JOIN setor
    ON medidas.id_setor = setor.id
WHERE medidas.variavel = 'ETOH'
GROUP BY setor.nome
ORDER BY setor.nome ASC;


-- ============================================
-- QUESTÃO 9
-- Quantidade de medições por setor
-- ============================================

SELECT 
    setor.nome,
    COUNT(medidas.id) AS quantidade_medicoes
FROM setor
INNER JOIN medidas
    ON medidas.id_setor = setor.id
GROUP BY setor.nome
ORDER BY quantidade_medicoes DESC;