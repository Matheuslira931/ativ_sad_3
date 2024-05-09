-- Criando o banco de dados
CREATE DATABASE db_qh_03;
-- Setar o banco de dados para uso
USE db_qh_03;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 			Criação das Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

-- Criando tabela de Dimensão: Tipo de Serviço
---------------------------------------
CREATE TABLE dim_tipo_servico (
   id        	smallint primary KEY auto_increment,
   servico		varchar(60),
   valor    	decimal(19,2),
   tempo_medio	time
);

-- Criando tabela de Dimensão: Funcionários
---------------------------------------
CREATE TABLE dim_funcionario (
   id		  			 smallint PRIMARY KEY auto_increment,
   nome       			 varchar(60),
   sexo                  varchar(1),
   dt_nascimento 		 date,
   salario 		  		 decimal(19,2)
);

-- Criando tabela de Dimensão: Especialidades dos Funcionários
---------------------------------------
CREATE TABLE dim_especialidade (
   id		  		smallint PRIMARY KEY auto_increment,
   funcionario_id 	smallint,
   tipo_servico_id	smallint,
   FOREIGN KEY (funcionario_id)  REFERENCES dim_funcionario (id),
   FOREIGN KEY (tipo_servico_id) REFERENCES dim_tipo_servico (id)
);

-- Criando tabela de Dimensão: Endereço
---------------------------------------
CREATE TABLE dim_endereco (
   id		smallint PRIMARY KEY auto_increment,
   bairro	varchar(20),
   rua	   	varchar(20)
);

-- Criando a tabela de Dimensão: Cliente
---------------------------------------
CREATE TABLE dim_cliente (
   id   smallint PRIMARY KEY auto_increment,
   nome varchar(60),
   sexo	varchar(1)
);

-- Criando a tabela de Dimensão: Data
---------------------------------------
CREATE TABLE dim_data (
   id   smallint PRIMARY KEY auto_increment,
   data	date,
   hora time,
   dia  int,
   mes  int, 
   ano  int
);

-- Criando a tabela Fato: Serviço
---------------------------------------
CREATE TABLE fato_servico (
   id     			smallint PRIMARY KEY auto_increment,
   cliente_id		smallint,
   data_id   		smallint,
   frete    		decimal(19,2),  
   valor_total    	decimal(19,2),
   tipo_servico_id	smallint,
   funcionario_id   smallint,
   endereco_id		smallint,
   status 		    smallint,
   nota             smallint,
   FOREIGN KEY (cliente_id) 	 REFERENCES dim_cliente (id),
   FOREIGN KEY (endereco_id) 	 REFERENCES dim_endereco (id),
   FOREIGN KEY (tipo_servico_id) REFERENCES dim_tipo_servico (id),
   FOREIGN KEY (funcionario_id)  REFERENCES dim_funcionario (id),
   FOREIGN KEY (data_id)  REFERENCES dim_data (id)
);
