-- Criando o banco de dados
CREATE DATABASE db_qh_01;
-- Setar o banco de dados para uso
USE db_qh_01;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 			Criação das Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

-- Criando tabela de Tipo de Serviço
---------------------------------------
CREATE TABLE tb_tp_serv (
   codtpser        smallint PRIMARY KEY,
   servico		   varchar(60),
   valorservico    decimal(19,2),
   tempomedservico time
);

-- Criando tabela de Funcionários
---------------------------------------
CREATE TABLE tb_func (
   codfunc		  smallint PRIMARY KEY,
   nomefunc       varchar(60),
   sxfunc  		  smallint, -- 1 = Masculino, 2 = Feminino
   dtnasc 		  date,
   especialidades varchar(30),
   salario 		  decimal(19,2)
);

-- Criando a tabela de Serviço
---------------------------------------
CREATE TABLE tb_serv (
   codser     smallint PRIMARY KEY,
   nomecli     varchar(60),
   sxcli       varchar(1), -- 1 = Masculino, 2 = Feminino
   bairro   varchar(20),
   rua      varchar(20),
   dataagend   date,
   horaagent   time,
   vlrfrete    decimal(19,2),  
   vlrtotal    decimal(19,2),
   codtpser    smallint,
   codfunc     smallint,
   statusagend smallint, -- 1 Em espera, 2 Concluído, 3 Em atendimento , 4 Cancelado
   FOREIGN KEY (codtpser) REFERENCES tb_tp_serv (codtpser),
   FOREIGN KEY (codfunc) REFERENCES tb_func (codfunc)
);

-- Criando tabela de Avaliação do Serviço
---------------------------------------
CREATE TABLE tb_aval_serv (
   codaval	smallint PRIMARY KEY auto_increment,
   nota     smallint,
   codser  smallint,
   FOREIGN KEY (codser) REFERENCES tb_serv (codser)
);
