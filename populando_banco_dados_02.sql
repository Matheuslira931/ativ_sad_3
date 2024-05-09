-- Setar o banco de dados para uso
USE db_qh_02;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		  Resetando as Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

DELETE FROM avaliacao_servico	where id >= 0;
DELETE FROM servico 			where id >= 0;
DELETE FROM especialidade 		where id >= 0;
DELETE FROM funcionario			where id >= 0;
DELETE FROM endereco 			where id >= 0;
DELETE FROM cliente 			where id >= 0;
DELETE FROM status_servico 		where id >= 0;
DELETE FROM tipo_servico		where id >= 0;
DELETE FROM sexo 				where id >= 0;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		  Populando as Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

-- Inserindo dados na tabela Status do Serviço
---------------------------------------
INSERT INTO status_servico VALUES (1, 'Em espera'),
								  (2, 'Concluído'),
								  (3, 'Em atendimento'),
								  (4, 'Cancelado');

-- Inserindo dados na tabela Sexo
---------------------------------------
INSERT INTO sexo VALUES (1, 'Masculino', 'M'),
                        (2, 'Feminino', 'F');

-- Inserindo dados na tabela Tipo de Serviço
---------------------------------------
INSERT INTO tipo_servico (id, servico, valor, tempo_medio )
SELECT codtpser, servico, valorservico, tempomedservico
FROM db_qh_01.tb_tp_serv;
                            
-- Inserindo dados na tabela Funcionários
---------------------------------------
INSERT INTO funcionario (id, nome, sexo_id, dt_nascimento, salario)
SELECT codfunc, nomefunc, sexo.id, dtnasc, salario
FROM db_qh_01.tb_func as func
INNER JOIN sexo ON func.sxfunc = sexo.id;

-- Criando tabela de Especialidades dos Funcionários
---------------------------------------
INSERT INTO especialidade (funcionario_id, tipo_servico_id)
SELECT func.codfunc, 
       TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(func.especialidades, ',', n.digit+1), ',', -1)) as especialidade
FROM
  (SELECT 0 digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) n
INNER JOIN db_qh_01.tb_func as func
ON CHAR_LENGTH(func.especialidades) - CHAR_LENGTH(REPLACE(func.especialidades, ',', '')) >= n.digit
INNER JOIN funcionario ON func.codfunc = funcionario.id
ORDER BY func.codfunc, especialidade;

-- Inserindo dados na tabela Endereço
---------------------------------------
INSERT INTO endereco (bairro, rua)
SELECT distinct bairro, rua
FROM db_qh_01.tb_serv;

-- Inserindo dados na tabela Cliente
---------------------------------------
INSERT INTO cliente (nome, sexo_id)
SELECT nomecli, MAX(sexo.id)
FROM db_qh_01.tb_serv as serv
INNER JOIN sexo ON serv.sxcli = sexo.id
GROUP BY nomecli;

-- Inserindo dados na tabela Serviço
---------------------------------------
INSERT INTO servico (id, cliente_id, data, hora, frete, valor_total, 
					tipo_servico_id, funcionario_id, endereco_id, status_id)
SELECT DISTINCT codser, cliente.id, dataagend, horaagent, vlrfrete, vlrfrete+tipo_servico.valor, 
		tipo_servico.id, funcionario.id, endereco.id, status_servico.id
FROM db_qh_01.tb_serv as serv
INNER JOIN cliente 		  on serv.nomecli     = cliente.nome
INNER JOIN tipo_servico   on serv.codtpser    = tipo_servico.id
INNER JOIN funcionario 	  on serv.codfunc 	  = funcionario.id
INNER JOIN endereco 	  on  serv.bairro 	  = endereco.bairro
						  and serv.rua        = endereco.rua
INNER JOIN status_servico on serv.statusagend = status_servico.id;

-- Inserindo dados na tabela Avaliação do Serviço
---------------------------------------
INSERT INTO avaliacao_servico (id, nota, servico_id)
SELECT codaval, nota, codser
FROM db_qh_01.tb_aval_serv;
