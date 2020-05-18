-- Aluno: Gabriel Paiva Medeiros
-- Matrícula: 118210822

-- Criação Tabela

Create table tarefas (
  identificacao INTEGER,
  descricao Text,
  cpf CHAR(11),
  numero INTeger,
  letra char(1)
);

-- Questão 1 -----------------------------------------------------------------------------------------

Insert into tarefas values(2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');
Insert into tarefas values(2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');
Insert into tarefas values(null, null, null, null, null);

-- Insert into tarefas values(2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');
-- Insert into tarefas values(2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');

-- Delete from tarefas where func_resp_cpf='987654323211';
-- Delete from tarefas where func_resp_cpf='98765432321';

-- Questão 2 -----------------------------------------------------------------------------------------

ALTER TABLE tarefas ALTER COLUMN identificacao TYPE BIGINT;
INSERT into tarefas values(2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');

-- Questão 3 -----------------------------------------------------------------------------------------

ALTER TABLE tarefas ADD CONSTRAINT prioridade_check CHECK (numero <= 32767);

-- Insert into tarefas values(2147483649, 'limpar portas do 1o andar', '32322525199', 32768, 'A');
-- Insert into tarefas values(2147483650, 'limpar portas do 1o andar', '32333233288', 32769, 'A');

Insert into tarefas values(2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A');
Insert into tarefas values(2147483652, 'limpar janelas do 2o andar', '32323232911', 32766, 'A');

-- Questão 4 -----------------------------------------------------------------------------------------

DELETE FROM tarefas WHERE identificacao IS NULL;

ALTER TABLE tarefas ALTER COLUMN identificacao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
-- ALTER TABLE tarefas ALTER COLUMN cpf SET NOT NULL; RETIRADO PARA TESTE DA QUESTÃO 11
ALTER TABLE tarefas ALTER COLUMN numero SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN letra SET NOT NULL;

ALTER TABLE tarefas RENAME COLUMN identificacao To id;
ALTER TABLE tarefas RENAME COLUMN cpf To func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN numero To prioridade;
ALTER TABLE tarefas RENAME COLUMN letra To status;

-- Questão 5 -----------------------------------------------------------------------------------------

Alter table tarefas ADD PRIMARY KEY(id);
insert into tarefas values(2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A');
-- insert into tarefas values(2147483653, 'limpar portas do 1o andar', '32323232911', 3, 'A');

-- Questão 6.a ---------------------------------------------------------------------------------------

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf TYPE char(11);

-- Questão 6.b ---------------------------------------------------------------------------------------

ALTER TABLE tarefas ADD CONSTRAINT status_check CHECK (status = 'A' or status = 'R' or status = 'F');
ALTER TABLE tarefas Drop CONSTRAINT status_check;

UPDATE tarefas
SET status = 'P'  
WHERE status ='A';

UPDATE tarefas 
SET status = 'E'  
WHERE status ='R';

UPDATE tarefas
SET status = 'C'  
WHERE status ='F';

ALTER TABLE tarefas ADD CONSTRAINT status_check CHECK (status = 'P' or status = 'E' or status = 'C');

-- Questão 7 -----------------------------------------------------------------------------------------

UPDATE tarefas
SET prioridade = 5
where prioridade < 0 or prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT prioridade_check_2 CHECK (prioridade >= 0 and prioridade <= 5);

-- Questão 8 -----------------------------------------------------------------------------------------

Create table funcionario (
  superior_cpf CHAR(11),
  cpf CHAR(11),
  nome VARCHAR(30) NOT NULL,
  data_nasc date NOT NULL,
  funcao VARCHAR(11),
  nivel char(1) NOT NULL,
  PRIMARY KEY(cpf),
  FOREIGN KEY (superior_cpf) REFERENCES funcionario(cpf),
  constraint func_check check(funcao ='LIMPEZA' or funcao='SUP_LIMPEZA'),
  constraint func_check_2 check((superior_cpf is NULL AND funcao = 'SUP_LIMPEZA') or
                             (superior_cpf is not NULL AND funcao = 'SUP_LIMPEZA') or
                             (superior_cpf is not NULL AND funcao = 'LIMPEZA')),
  constraint nivel_check check(nivel = 'J' OR nivel = 'P' or nivel = 'S')
);

insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);

insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');

-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('12345678913', '1980-04-09', 'Joao da Silva', 'LIMPEZA', 'J', NULL);

-- Questão 9.a ---------------------------------------------------------------------------------------

-- SUPERIOR NULL
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('42342342342', '1979-09-23', 'Chico da Silva', 'SUP_LIMPEZA', 'S', NULL);

-- SUP_LIMPEZA SEM SUPERIOR
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('75423424242', '1982-05-07', 'Beatriz Lacerda', 'SUP_LIMPEZA', 'S', NULL);

-- SUP_LIMPEZA COM SUPERIOR
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('42345242342', '1978-05-07', 'Tadeu Oliveira', 'SUP_LIMPEZA', 'J', '12345678912');

-- LIMPEZA COM SUPERIOR
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('54671829018', '1982-10-22', 'Ana Caroline', 'LIMPEZA', 'J', '12345678912');

-- FUNCAO NULL
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('35432323254', '1981-08-29', 'Risonilson Ferreira', NULL, 'P', NULL);

-- FUNCAO E SUPERIOR NULL
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('54543534534', '1982-11-21', 'Ricardo Ferreira', NULL, 'P', NULL);

-- Testes Normais
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf)
values ('54364356757', '1980-04-20', 'Lucas Amaral', 'LIMPEZA', 'P', '12345678912');

insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('87878787878', '1979-03-18', 'Neymar Jubileu', 'SUP_LIMPEZA', 'S', NULL);

insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('54534534543', '1982-11-02', 'Tadeu Lacerda', 'LIMPEZA', 'J', '12345678912');

insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('97786588945', '1981-10-03', 'Maria Joana', 'SUP_LIMPEZA', 'S', NULL);

-- Questão 9.b ---------------------------------------------------------------------------------------

-- LIMPEZA SEM SUPERIOR
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('31231232132', '1982-01-21', 'Matheus Salgueiro', 'LIMPEZA', 'S', NULL);

-- DATA INVALIDA
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('42345242342', '1978-02-43', 'Tadeu Ferreira', 'SUP_LIMPEZA', 'J', '12345678912');

-- NIVEL DIFERENTE DE J, P E S.
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('54671829018', '1982-12-17', 'Letícia Amaral', 'LIMPEZA', 'T', '12345678912');

-- NOME NULL
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('42342423434', '1979-12-15', NULL, 'SUP_LIMPEZA', 'S', NULL);

-- DATA NULL
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('35432323254', NULL, 'Maria Vitória', NULL, 'P', NULL);

-- CPF NULL
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values (NULL, '1982-09-24', 'Helena Tavares', NULL, 'P', NULL);

-- NIVEL NULL
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf)
-- values ('54364356757', '1980-11-25', 'Pedro Oliveira', 'LIMPEZA', NULL, '12345678912');

-- CPF COM MAIS DE 11 DIGITOS
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('5453453454312', '1979-04-26', 'Caio Leite', 'SUP_LIMPEZA', 'S', NULL);

-- CPF_SUPERIOR COM MAIS DE 11 DIGITOS
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('54534534543', '1982-07-02', 'Caio Sérgio', 'LIMPEZA', 'J', '123456789121');

-- FUNCAO DIFERENTE DE LIMPEZA E SUP_LIMPEZA
-- insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
-- values ('54354354354', '1978-10-01', 'Maria Oliveira', 'GERENTE', 'S', NULL);

-- Questão 10 ----------------------------------------------------------------------------------------

-- Novos Funcionários
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('98765432111', '1980-02-12', 'Tadeu de Atena', 'SUP_LIMPEZA', 'S', '12345678912');
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('98765432122', '1980-08-09', 'Iago de Platão', 'LIMPEZA', 'J', '12345678912');
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('32323232955', '1981-07-05', 'Caio Leite', 'SUP_LIMPEZA', 'S', '12345678912');
insert into funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
values ('32323232911', '1983-06-23', 'Caio Sérgio', 'LIMPEZA', 'J', '12345678912');

alter table tarefas add CONSTRAINT tarefas_cpf_fk 
FOREIGN key (func_resp_cpf) REFERENCES funcionario(cpf) on DELETE cascade;

-- alter table tarefas add CONSTRAINT tarefas_cpf_fk 
-- FOREIGN key (func_resp_cpf) REFERENCES funcionario(cpf) on DELETE restrict;
-- Erro = Update or delete on table "funcionario" violates foreign key constraint "tarefas_cpf_fk" on table "tarefas"

DELETE FROM funcionario where cpf='32323232911';

-- Questão 11 ----------------------------------------------------------------------------------------

ALTER TABLE tarefas ADD CONSTRAINT status_check_2 CHECK ((status <> 'P' and func_resp_cpf is not NULL) OR
                                                        (status = 'P'));
alter table tarefas DROP CONSTRAINT tarefas_cpf_fk;

alter table tarefas add CONSTRAINT tarefas_cpf_fk 
FOREIGN key (func_resp_cpf) REFERENCES funcionario(cpf) on DELETE set NULL;

-- NOVA TAREFA COM ESTADO = 'E'
Insert into tarefas values(21474321312, 'limpar janelas da sala 204', '54364356757', 1, 'E');

-- delete from funcionario where cpf = '98765432111'; -- Possui E como status
-- delete from funcionario where cpf = '54364356757'; -- Possui C como status
-- Erro = New row for relation "tarefas" violates check constraint "status_check_2"

delete from funcionario where cpf = '32323232955'; -- Possui P como status
 
