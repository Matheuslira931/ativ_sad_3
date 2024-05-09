-- Criando o banco de dados
CREATE DATABASE db_qh_02;
-- Setar o banco de dados para uso
USE db_qh_02;

---------------------------------------
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 			Criação das Tabelas
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------

-- Criando tabela de Tipo de Serviço
---------------------------------------
CREATE TABLE tipo_servico (
   id        	smallint primary KEY auto_increment,
   servico		varchar(60),
   valor    	decimal(19,2),
   tempo_medio	time
);

-- Criando tabela de Sexo
---------------------------------------
CREATE TABLE sexo (
   id		  	smallint PRIMARY KEY auto_increment,
   nome       	varchar(60),
   abreviacao	varchar(1)
);

-- Criando tabela de Funcionários
---------------------------------------
CREATE TABLE funcionario (
   id		  			smallint PRIMARY KEY auto_increment,
   nome       			varchar(60),
   sexo_id  		  	smallint, -- 1 = Masculino, 2 = Feminino
   dt_nascimento 		date,
   salario 		  		decimal(19,2),
   FOREIGN KEY (sexo_id) 		   REFERENCES sexo (id)
);

-- Criando tabela de Especialidades dos Funcionários
---------------------------------------
CREATE TABLE especialidade (
   id		  		smallint PRIMARY KEY auto_increment,
   funcionario_id 	smallint,
   tipo_servico_id	smallint,
   FOREIGN KEY (funcionario_id)  REFERENCES funcionario (id),
   FOREIGN KEY (tipo_servico_id) REFERENCES tipo_servico (id)
);

-- Criando tabela de Endereço
---------------------------------------
CREATE TABLE endereco (
   id		smallint PRIMARY KEY auto_increment,
   bairro	varchar(20),
   rua	   	varchar(20)
);

-- Criando a tabela de Cliente
---------------------------------------
CREATE TABLE cliente (
   id     		smallint PRIMARY KEY auto_increment,
   nome        	varchar(60),
   sexo_id     	smallint,
   FOREIGN KEY (sexo_id)  REFERENCES sexo (id)
);

-- Criando tabela de Status do Serviço
---------------------------------------
CREATE TABLE status_servico (
   id	smallint PRIMARY KEY auto_increment,
   nome	varchar(20)
);

-- Criando a tabela de Serviço
---------------------------------------
CREATE TABLE servico (
   id     			smallint PRIMARY KEY auto_increment,
   cliente_id		smallint,
   data 			date,
   hora   			time,
   frete    		decimal(19,2),  
   valor_total    	decimal(19,2),
   tipo_servico_id	smallint,
   funcionario_id   smallint,
   endereco_id		smallint,
   status_id 		smallint, -- 1 Em espera, 2 Concluído, 3 Em atendimento , 4 Cancelado
   FOREIGN KEY (cliente_id) 	 REFERENCES cliente (id),
   FOREIGN KEY (endereco_id) 	 REFERENCES endereco (id),
   FOREIGN KEY (tipo_servico_id) REFERENCES tipo_servico (id),
   FOREIGN KEY (funcionario_id)  REFERENCES funcionario (id),
   FOREIGN KEY (status_id) 		 REFERENCES status_servico (id)
);

-- Criando tabela de Avaliação do Serviço
---------------------------------------
CREATE TABLE avaliacao_servico (
   id		  smallint PRIMARY KEY auto_increment,
   nota       smallint,
   servico_id smallint,
   FOREIGN KEY (servico_id) REFERENCES servico (id)
);
