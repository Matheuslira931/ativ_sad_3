-- Setar o banco de dados para uso
USE db_qh_01;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		  Resetando as Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

DELETE FROM tb_aval_serv	where codaval >= 0;
DELETE FROM tb_serv 		where codser >= 0;
DELETE FROM tb_tp_serv		where codtpser >= 0;
DELETE FROM tb_func 		where codfunc >= 0;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 		  Populando as Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

-- Inserindo dados na tabela Tipo de Serviço
---------------------------------------
INSERT INTO tb_tp_serv VALUES (1 , 'Reparação de Ar Condicionado', 100, "02:00:00"),
							  (2 , 'Reparação de Geladeira', 120, "03:00:00"),
                              (3 , 'Reparação de Máquina de Lavar', 80, "01:00:00"),
                              (4 , 'Reparação de Ventilador', 50, "00:30:00"),
                              (5 , 'Reparação de Liquidificador', 30, "00:25:00");
                            
-- Inserindo dados na tabela Funcionários
---------------------------------------

-- Excluindo a procedure se já existir
DROP PROCEDURE IF EXISTS criarFuncionarios;

DELIMITER //
CREATE PROCEDURE criarFuncionarios (qtdRegistros SMALLINT UNSIGNED)
BEGIN
DECLARE contador SMALLINT UNSIGNED DEFAULT 1;
WHILE contador <= qtdRegistros DO
    INSERT INTO tb_func (
		codfunc,
		nomefunc,
		sxfunc,
		dtnasc,
		especialidades,
		salario
    )
    VALUES (
        contador,
        CONCAT('Funcionário ', CAST((contador % 10 + 1) AS CHAR)),
        (SELECT FLOOR(1 + RAND() * 2)),
        CURRENT_DATE - INTERVAL FLOOR(RAND() * 200) DAY,
       (SELECT GROUP_CONCAT(codtpser ORDER BY RAND() SEPARATOR ', ') FROM 
       (SELECT codtpser FROM tb_tp_serv ORDER BY RAND() LIMIT 3) AS random_selection),
        ROUND((RAND() * (4000 - 10) + 10), 2)
    );

    SET contador = contador + 1;
END WHILE;
END//
DELIMITER ;

-- Testando:
CALL criarFuncionarios(10);

-- Inserindo dados na tabela Serviço
---------------------------------------

-- Excluindo a procedure se já existir
DROP PROCEDURE IF EXISTS criarServicos;

DELIMITER //
CREATE PROCEDURE criarServicos (qtdRegistros SMALLINT UNSIGNED)
BEGIN
DECLARE contador SMALLINT UNSIGNED DEFAULT 1;
DECLARE tipo_servico SMALLINT;
DECLARE funcionario SMALLINT;
WHILE contador <= qtdRegistros DO
	
    SET tipo_servico = (SELECT codtpser FROM tb_tp_serv ORDER BY RAND( ) LIMIT 1);
    SET funcionario = (SELECT codfunc FROM tb_func WHERE especialidades LIKE CONCAT('%', tipo_servico, '%') ORDER BY RAND( ) LIMIT 1);

    INSERT INTO tb_serv (
		codser,
		nomecli,
		sxcli,
		bairro,
		rua,
		dataagend,
		horaagent,
		vlrfrete,  
		vlrtotal,
		codtpser,
		codfunc,
		statusagend
    )
    VALUES (
        contador,
        CONCAT('Cliente ', CAST((contador % 10 + 1) AS CHAR)),
        (SELECT FLOOR(1 + RAND() * 2)),
        CONCAT('Bairro ', CAST((contador % 10 + 1) AS CHAR)),
        CONCAT('Rua ', CAST((contador % 10 + 1) AS CHAR)),
        CURRENT_DATE - INTERVAL FLOOR(RAND() * 14) DAY,
        (SELECT SEC_TO_TIME(FLOOR(RAND() * 86400))),
        ROUND((RAND() * (20 - 8) + 10), 2),
        0,
        tipo_servico,
        funcionario,
        (SELECT FLOOR(1 + RAND() * 4))
    );

    SET contador = contador + 1;
END WHILE;
END//
DELIMITER ;

-- Testando:
CALL criarServicos(20);

-- Inserindo dados na tabela Avaliação do Serviço
---------------------------------------
INSERT INTO tb_aval_serv (nota, codser)
SELECT (SELECT FLOOR(1 + RAND() * 10)), codser
FROM tb_serv
where statusagend = '4';
