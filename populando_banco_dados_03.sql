-- Setar o banco de dados para uso
USE db_qh_03;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		  Resetando as Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

DELETE FROM fato_servico 		where id >= 0;
DELETE FROM dim_data 			where id >= 0;
DELETE FROM dim_especialidade	where id >= 0;
DELETE FROM dim_tipo_servico	where id >= 0;
DELETE FROM dim_funcionario 	where id >= 0;
DELETE FROM dim_endereco		where id >= 0;
DELETE FROM dim_cliente 		where id >= 0;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		  Populando as Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

-- Inserindo dados na tabela Dimensão: Tipo de Serviço
---------------------------------------
INSERT INTO dim_tipo_servico (id, servico, valor, tempo_medio)
SELECT id, servico, valor, tempo_medio
FROM db_qh_02.tipo_servico;
                            
-- Inserindo dados na tabela Dimensão: Funcionários
---------------------------------------
INSERT INTO dim_funcionario (id, nome, sexo, dt_nascimento, salario)
SELECT func.id, func.nome, sexo.abreviacao, dt_nascimento, salario
FROM db_qh_02.funcionario as func
INNER JOIN db_qh_02.sexo as sexo ON func.sexo_id = sexo.id;

-- Criando tabela Dimensão: Especialidades dos Funcionários
---------------------------------------
INSERT INTO dim_especialidade (id, funcionario_id, tipo_servico_id)
SELECT id, funcionario_id, tipo_servico_id
FROM db_qh_02.especialidade;

-- Inserindo dados na tabela Dimensão: Endereço
---------------------------------------
INSERT INTO dim_endereco (id, bairro, rua)
SELECT distinct id, bairro, rua
FROM db_qh_02.endereco;

-- Inserindo dados na tabela Dimensão: Cliente
---------------------------------------
INSERT INTO dim_cliente (id, nome, sexo)
SELECT cli.id, cli.nome, sexo.abreviacao
FROM db_qh_02.cliente as cli
INNER JOIN db_qh_02.sexo as sexo ON cli.sexo_id = sexo.id;

-- Inserindo dados na tabela Dimensão: Data
---------------------------------------
INSERT INTO dim_data (data, hora, dia, mes, ano)
SELECT distinct data,
	   hora,
       DAY(data),
       MONTH(data),
       YEAR(data)
FROM db_qh_02.servico;

-- Inserindo dados na tabela Fato: Serviço
---------------------------------------
INSERT INTO fato_servico (id, cliente_id, data_id, frete, valor_total, tipo_servico_id,
				     funcionario_id, endereco_id, status, nota)
SELECT serv.id, cliente_id, dim_data.id, frete, valor_total, tipo_servico_id,
				funcionario_id, endereco_id, ss.id, aval.nota
FROM db_qh_02.servico as serv
LEFT OUTER JOIN db_qh_02.avaliacao_servico as aval on serv.id = aval.servico_id
INNER JOIN dim_data on serv.data     = dim_data.data
				   and serv.hora    = dim_data.hora
INNER JOIN db_qh_02.status_servico as ss on serv.status_id = ss.id;