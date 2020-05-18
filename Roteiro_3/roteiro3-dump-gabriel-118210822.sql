--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.5.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_med_id_fk_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_funcionario_cpf_fk_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT gerente_cpf;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_farmacia_id_fk_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_venda_id_fk_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_cliente_cpf_fk_fkey1;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_cliente_cpf_fk_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_venda_id_pk_cliente_cadastrado_key;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_med_id_venda_com_receita_key;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_funcionario_cpf_pk_funcionario_funcao_key;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_tipo_farm_excl;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_cidade_estado_bairro_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.enderecos DROP CONSTRAINT enderecos_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
DROP TABLE public.vendas;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP TABLE public.farmacias;
DROP TABLE public.entregas;
DROP TABLE public.enderecos;
DROP TABLE public.clientes;
DROP TYPE public.possiveis_funcoes;
DROP TYPE public.poss_tipo_farm;
DROP TYPE public.poss_func;
DROP TYPE public.poss_estados;
DROP TYPE public.poss_endereco;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: poss_endereco; Type: TYPE; Schema: public; Owner: gabrielmedeiros
--

CREATE TYPE public.poss_endereco AS ENUM (
    'Residência',
    'Trabalho',
    'Outro'
);


ALTER TYPE public.poss_endereco OWNER TO gabrielmedeiros;

--
-- Name: poss_estados; Type: TYPE; Schema: public; Owner: gabrielmedeiros
--

CREATE TYPE public.poss_estados AS ENUM (
    'Maranhão',
    'Paraíba',
    'Rio Grande do Norte',
    'Pernambuco',
    'Sergipe',
    'Piauí',
    'Alagoas',
    'Bahia',
    'Ceará'
);


ALTER TYPE public.poss_estados OWNER TO gabrielmedeiros;

--
-- Name: poss_func; Type: TYPE; Schema: public; Owner: gabrielmedeiros
--

CREATE TYPE public.poss_func AS ENUM (
    'Farmacêutico',
    'Vendedor',
    'Entregador',
    'Caixa',
    'Administrador'
);


ALTER TYPE public.poss_func OWNER TO gabrielmedeiros;

--
-- Name: poss_tipo_farm; Type: TYPE; Schema: public; Owner: gabrielmedeiros
--

CREATE TYPE public.poss_tipo_farm AS ENUM (
    'Sede',
    'Filial'
);


ALTER TYPE public.poss_tipo_farm OWNER TO gabrielmedeiros;

--
-- Name: possiveis_funcoes; Type: TYPE; Schema: public; Owner: gabrielmedeiros
--

CREATE TYPE public.possiveis_funcoes AS ENUM (
    'Farmacêutico',
    'Vendedor',
    'Entregador',
    'Caixa',
    'Administrador'
);


ALTER TYPE public.possiveis_funcoes OWNER TO gabrielmedeiros;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.clientes (
    cliente_cpf_pk character(11) NOT NULL,
    data_nasc date,
    CONSTRAINT ver_idade CHECK (((date_part('year'::text, ('now'::text)::date) - date_part('year'::text, data_nasc)) >= (18)::double precision))
);


ALTER TABLE public.clientes OWNER TO gabrielmedeiros;

--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.enderecos (
    cliente_cpf_pk character(11) NOT NULL,
    endereco_tipo_pk public.poss_endereco NOT NULL,
    endereco_logradouro text
);


ALTER TABLE public.enderecos OWNER TO gabrielmedeiros;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.entregas (
    entrega_id integer NOT NULL,
    venda_id_fk integer,
    cliente_cadastrado_fk boolean,
    cliente_cpf_fk character(11),
    endereco_cliente_fk public.poss_endereco,
    CONSTRAINT entregas_cliente_cadastrado_fk_check CHECK (cliente_cadastrado_fk)
);


ALTER TABLE public.entregas OWNER TO gabrielmedeiros;

--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.farmacias (
    id_farm_pk integer NOT NULL,
    tipo_farm public.poss_tipo_farm,
    gerente_cpf_fk character(11) NOT NULL,
    gerente_func_fk public.poss_func NOT NULL,
    bairro character varying(30),
    cidade character varying(30),
    estado public.poss_estados,
    CONSTRAINT farmacias_gerente_func_fk_check CHECK (((gerente_func_fk = 'Administrador'::public.poss_func) OR (gerente_func_fk = 'Farmacêutico'::public.poss_func))),
    CONSTRAINT tipo_farm CHECK (((tipo_farm = 'Filial'::public.poss_tipo_farm) OR (tipo_farm = 'Sede'::public.poss_tipo_farm)))
);


ALTER TABLE public.farmacias OWNER TO gabrielmedeiros;

--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.funcionarios (
    funcionario_cpf_pk character(11) NOT NULL,
    funcionario_funcao public.poss_func NOT NULL,
    farmacia_id_fk integer
);


ALTER TABLE public.funcionarios OWNER TO gabrielmedeiros;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.medicamentos (
    med_id integer NOT NULL,
    venda_com_receita boolean
);


ALTER TABLE public.medicamentos OWNER TO gabrielmedeiros;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.vendas (
    venda_id_pk integer NOT NULL,
    cliente_cpf character(11),
    cliente_cadastrado boolean,
    funcionario_cpf_fk character(11),
    funcionario_funcao_fk public.poss_func,
    med_id_fk integer,
    med_com_receita_fk boolean,
    CONSTRAINT vendas_check CHECK (((cliente_cadastrado AND med_com_receita_fk) OR (cliente_cadastrado AND (NOT med_com_receita_fk)) OR ((NOT cliente_cadastrado) AND (NOT med_com_receita_fk)))),
    CONSTRAINT vendas_funcionario_funcao_fk_check CHECK ((funcionario_funcao_fk = 'Vendedor'::public.poss_func))
);


ALTER TABLE public.vendas OWNER TO gabrielmedeiros;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Data for Name: enderecos; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--



--
-- Name: clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cliente_cpf_pk);


--
-- Name: enderecos_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT enderecos_pkey PRIMARY KEY (cliente_cpf_pk, endereco_tipo_pk);


--
-- Name: entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (entrega_id);


--
-- Name: farmacias_cidade_estado_bairro_key; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_cidade_estado_bairro_key UNIQUE (cidade, estado, bairro);


--
-- Name: farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id_farm_pk);


--
-- Name: farmacias_tipo_farm_excl; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_tipo_farm_excl EXCLUDE USING btree (tipo_farm WITH =) WHERE ((tipo_farm = 'Sede'::public.poss_tipo_farm));


--
-- Name: funcionarios_funcionario_cpf_pk_funcionario_funcao_key; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_funcionario_cpf_pk_funcionario_funcao_key UNIQUE (funcionario_cpf_pk, funcionario_funcao);


--
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (funcionario_cpf_pk);


--
-- Name: medicamentos_med_id_venda_com_receita_key; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_med_id_venda_com_receita_key UNIQUE (med_id, venda_com_receita);


--
-- Name: medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (med_id);


--
-- Name: vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (venda_id_pk);


--
-- Name: vendas_venda_id_pk_cliente_cadastrado_key; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_venda_id_pk_cliente_cadastrado_key UNIQUE (venda_id_pk, cliente_cadastrado);


--
-- Name: entregas_cliente_cpf_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_cliente_cpf_fk_fkey FOREIGN KEY (cliente_cpf_fk) REFERENCES public.clientes(cliente_cpf_pk);


--
-- Name: entregas_cliente_cpf_fk_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_cliente_cpf_fk_fkey1 FOREIGN KEY (cliente_cpf_fk, endereco_cliente_fk) REFERENCES public.enderecos(cliente_cpf_pk, endereco_tipo_pk);


--
-- Name: entregas_venda_id_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_venda_id_fk_fkey FOREIGN KEY (venda_id_fk, cliente_cadastrado_fk) REFERENCES public.vendas(venda_id_pk, cliente_cadastrado);


--
-- Name: funcionarios_farmacia_id_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_farmacia_id_fk_fkey FOREIGN KEY (farmacia_id_fk) REFERENCES public.farmacias(id_farm_pk);


--
-- Name: gerente_cpf; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT gerente_cpf FOREIGN KEY (gerente_cpf_fk, gerente_func_fk) REFERENCES public.funcionarios(funcionario_cpf_pk, funcionario_funcao);


--
-- Name: vendas_funcionario_cpf_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_funcionario_cpf_fk_fkey FOREIGN KEY (funcionario_cpf_fk, funcionario_funcao_fk) REFERENCES public.funcionarios(funcionario_cpf_pk, funcionario_funcao) ON DELETE RESTRICT;


--
-- Name: vendas_med_id_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_med_id_fk_fkey FOREIGN KEY (med_id_fk, med_com_receita_fk) REFERENCES public.medicamentos(med_id, venda_com_receita) ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

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


