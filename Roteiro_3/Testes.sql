--
-- COMANDOS ADICIONAIS
--

---------------------------------------------------------------- TESTES ----------------------------------------------------------------
-- OBS: AS LINHAS COMENTADAS SÃO COMANDOS INVÁLIDOS, A FIM DE PROVAR O FUNCIONAMENTO DO BANCO DE DADOS PERANTE AS RESTRIÇÕES.

-- QUESTÃO 1:

-- TESTE: POSSÍVEIS FUNÇÕES DO FUNCIONÁRIO PARA SER UM GERENTE
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476890', 'Administrador');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476891', 'Farmacêutico');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476892', 'Farmacêutico');
insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
values(1, 'Sede', '31235476890', 'Administrador', 'Jardim Paulistano', 'Campina Grande', 'Paraíba');
insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
values(2, 'Filial', '31235476891', 'Farmacêutico', 'Graças', 'Recife', 'Pernambuco');

-- TESTE: FARMÁCIA SEM SER FILIAL
-- insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
-- values(3, 'Qualquer coisa', '31235476892', 'Farmacêutico', 'Graças', 'Recife', 'Pernambuco');

-- Questão 2:

-- TESTE: POSSÍVEIS VALORES PARA A FUNÇÃO
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476893', 'Administrador');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476894', 'Farmacêutico');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476895', 'Vendedor');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476896', 'Entregador');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476897', 'Caixa');

-- TESTE: FUNCIONÁRIO COM FUNÇÃO INVÁLIDA
-- insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476897', 'Auxiliar');

-- Questão 3:
-- Funcionário possui apenas um atributo referente a farmácia em que trabalha, o que garante a unicidade.

-- Questão 4:
-- Farmácia possui apenas um atributo referente ao gerente, o que garante a unicidade.

-- Questão 5:

-- TESTE: SEM FARMÁCIA
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476898', 'Administrador');

-- TESTE: COM FARMÁCIA
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao, farmacia_id_fk) VALUES('31235476899', 'Administrador', 1);

-- Questão 6:

-- TESTE: CLIENTE COM MAIS DE UM ENDEREÇO
insert into clientes(cliente_cpf_pk, data_nasc) VALUES('31235476100',  '1998-11-15');
INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk) values('31235476100', 'Residência');
INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk) values('31235476100', 'Trabalho');

-- Questão 7:

-- TESTE: POSSÍVEIS VALORES PARA O ENDEREÇO
insert into clientes(cliente_cpf_pk, data_nasc) VALUES('31235476101',  '1998-11-15');
INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk, endereco_logradouro) 
values('31235476101', 'Residência','Rua João Siqueira, Jardim Paulistano, 1056');
INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk, endereco_logradouro) 
values('31235476101', 'Trabalho', 'Rua Indios Cariris, Tambor, 104');
INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk, endereco_logradouro) 
values('31235476101', 'Outro', 'Rua Riachuelo, Bodocongó, 1052');

-- TESTE: VALOR PARA ENDEREÇO INVÁLIDO
-- INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk, endereco_logradouro) 
-- values('31235476101', 'Casa de Vovó', 'Rua Tiringa, Bodocongó, 1052');

-- Questão 8:
-- Medicamento possui um atributo referente a venda com receita.

-- Questão 9:

-- TESTE: ENTREGA PARA CLIENTE CADASTRADO

insert into clientes(cliente_cpf_pk, data_nasc) VALUES('31235476102',  '1998-09-15');
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao, farmacia_id_fk) VALUES('31235476103', 'Vendedor', 1);
INSERT INTO enderecos(cliente_cpf_pk, endereco_tipo_pk, endereco_logradouro)
values('31235476102', 'Residência', 'Rua Tadeu Lima, Bodocongó, 1042');
insert into medicamentos(med_id, venda_com_receita) VALUES(1, TRUE);
insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
values (1, '31235476102', TRUE, '31235476103', 'Vendedor', 1, TRUE);
INSERT INTO entregas(entrega_id, venda_id_fk, cliente_cpf_fk, endereco_cliente_fk, cliente_cadastrado_fk) values(1, 1, '31235476102', 'Residência', TRUE);

-- TESTE: ENTREGA PARA CLIENTE NÃO CADASTRADO

-- INSERT INTO entregas(entrega_id, venda_id_fk, cliente_pf_fk, endereco_cliente_fk, cliente_cadastrado_fk) values (1, 1, '31235476102', 'Residência', FALSE);

-- Questão 10:

-- TESTE: CLIENTE CADASTRADO

insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
values (2, '31235476102', TRUE, '31235476103', 'Vendedor', 1, TRUE);

-- TESTE CLIENTE NÃO CADASTRADO

-- insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
-- values (3, '31235476102', FALSE, '31235476103', 'Vendedor', 1, TRUE);

-- Questão 11:

-- TESTE: FUNCIONÁRIO QUE NÃO ESTÁ VINCULADO A NENHUMA VENDA
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao, farmacia_id_fk) VALUES('31235476104', 'Vendedor', 1);
delete from funcionarios where funcionario_cpf_pk='31235476104';

-- TESTE: FUNCIONARIO QUE ESTÁ VINCULADO A UMA VENDA
-- delete from funcionarios where funcionario_cpf_pk='31235476103';

-- Questão 12:

-- TESTE: MEDICAMENTO QUE NÃO ESTÁ VINCULADO A NENHUMA VENDA
insert into medicamentos(med_id, venda_com_receita) VALUES(2, TRUE);
delete from medicamentos where med_id=2;

-- TESTE: MEDICAMENTO QUE ESTÁ VINCULADO A UMA VENDA
-- delete from medicamentos where med_id=1;

-- Questão 13:

-- TESTE: CLIENTE COM MAIS DE 18 ANOS
insert into clientes(cliente_cpf_pk, data_nasc) VALUES('31235476105',  '1995-09-17');

-- TESTE: CLIENTE COM MENOS DE 18 ANOS
-- insert into clientes(cliente_cpf_pk, data_nasc) VALUES('31235476106',  '2010-09-15');

-- Questão 14:

-- TESTE: MAIS DE UMA FARMÁCIA POR BAIRRO
-- insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
-- values(3, 'Filial', '31235476892', 'Farmacêutico', 'Jardim Paulistano', 'Campina Grande', 'Paraíba');

-- Questão 15:

--- TESTE: MAIS DE UMA SEDE
-- insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
-- values(4, 'Sede', '31235476892', 'Farmacêutico', 'Catolé', 'Campina Grande', 'Paraíba');

-- Questão 16:

-- TESTE: FUNÇÕES VÁLIDAS PARA GERENTE
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476107', 'Farmacêutico');
insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
values(5, 'Filial', '31235476107', 'Farmacêutico', 'Cruzeiro', 'Campina Grande', 'Paraíba');

insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476108', 'Administrador');
insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
values(6, 'Filial', '31235476108', 'Administrador', 'Jardim Tavares', 'Campina Grande', 'Paraíba');

-- TESTE: FUNÇÃO INVÁLIDA PARA GERENTE
-- insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476109', 'Entregador');
-- insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado) 
-- values(7, 'Filial', '31235476109', 'Entregador', 'Mirante', 'Campina Grande', 'Paraíba');

-- Questão 17:

-- TESTE: ENTREGA PARA CLIENTE CADASTRADO

insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
values (3, '31235476102', TRUE, '31235476103', 'Vendedor', 1, TRUE);
INSERT INTO entregas(entrega_id, venda_id_fk, cliente_cpf_fk, endereco_cliente_fk, cliente_cadastrado_fk) values(2, 3, '31235476102', 'Residência', TRUE);

-- TESTE: ENTREGA PARA CLIENTE NÃO CADASTRADO

-- insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
-- values (4, '31235432321', TRUE, '31235476103', 'Vendedor', 1, TRUE);
-- INSERT INTO entregas(entrega_id, venda_id_fk, cliente_cpf_fk, endereco_cliente_fk, cliente_cadastrado_fk) values(3, 4, '31235432321', 'Residência', FALSE);

-- Questão 18:

-- TESTE: VENDA FEITA POR UM VENDEDOR
insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
values (4, '31235476102', TRUE, '31235476103', 'Vendedor', 1, TRUE);

-- TESTE VENDA POR FEITO POR UM FUNCIONÁRIO QUE NÃO É VENDEDOR
-- insert into vendas(venda_id_pk , cliente_cpf, cliente_cadastrado, funcionario_cpf_fk, funcionario_funcao_fk, med_id_fk, med_com_receita_fk)
-- values (4, '31235476102', TRUE, '31235476103', 'Entregador', 1, TRUE);

-- Questão 19:

-- TESTE: ESTADO VÁLIDO (DA PARAÍBA)
insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476110', 'Administrador');
insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado)
values(8, 'Filial', '31235476108', 'Administrador', 'Intermares', 'João Pessoa', 'Paraíba');

-- TESTE: ESTADO INVÁLIDO (SEM SER DA PARAÍBA)
-- insert into funcionarios(funcionario_cpf_pk, funcionario_funcao) VALUES('31235476111', 'Farmacêutico');
-- insert into farmacias(id_farm_pk, tipo_farm, gerente_cpf_fk, gerente_func_fk, bairro, cidade, estado)
-- values(9, 'Filial', '31235476111', 'Farmacêutico', 'Intermares', 'João Pessoa', 'Amazonas');
