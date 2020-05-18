-- Aluno: Gabriel Paiva Medeiros
-- Matrícula: 118210822
-- Período: 2020.1

-- Comentários:

-- Questão 1:
-- Foi criada uma relação de nome tarefa com os atributos identificação, descrição, cpf,
-- número e letra, com os domínios integer, text, char(11), integer, letra, respectivamente;
-- Após isso, foram feitas algumas inserções;
-- As inserções comentadas são as inválidas.

-- Questão 2:
-- Foi alterado o domínio da coluna identificação para que a inserção fosse aceita. 
-- Domínio anterior = INTEGER
-- Domínio atual = BIGINTER

-- Questão 3:
-- Foi adicionado uma nova constraint check para que o valor da prioridade fosse menor ou igual a 32767.
-- Sendo assim, as duas primeiras inserções não foram aceitas, diferente das demais. 

-- Questão 4:
-- Todas as colunas foram alteradas para que não aceitem valores nulos.
-- Seus nomes também foram alterados;
-- Além disso, a linha de comando referente a aceitação de valores nulos da coluna cpf foi
-- comentada para que fosse possível fazer os testes da questão 11;
-- Após essas mudanças foi verificado que havia uma tupla com valores nulos, logo a mesma foi removida
-- através do comando DELETE.

-- Questão 5:
-- Para que a segunda tarefa não fosse inserida, o atributo id da relacao tarefa foi colocado como chave primária,
-- já que as tuplas possuíam o mesmo id.

-- Questão 6:
-- Para que o atributo func_resp_cpf tivesse exatamente 11 caracteres, o domínio foi alterado para char(11);
-- Em relação a segunda questão é verificado primeiro se todas as tarefas possuem estado válido. Após isso, a constraint
-- referente a verificação é excluída.
-- Sendo assim, podemos atualizar os valores A, R e F para P, E e C, respectivamente, já que 
-- foi verificada a validade dos status;
-- Após tudo isso, a nova constraint é adicionada, a fim de garantir a validez dos status com os valores P, E e C.

-- Questão 7:
-- As tarefas com prioridade maior que 5, foram atualizadas para 5.
-- Após isso foi adicionada uma nova constraint que restringe os valores da prioridade para que fiquem entre 0 e 5;

-- Questão 8:
-- A relação funcionario foi criada.
-- E as constraints necessárias foram adicionadas.
-- Constraints:
-- func_check: Garante que os valores da função se limitem a 'LIMPEZA' e 'SUP_LIMPEZA'.
-- func_check_2: Garante que quando a função for 'LIMPEZA' o funcionário deve ter um superior.
-- nivel_check: Garante que os valores do nivel se limitem a 'J', 'P' e 'S'.

-- Questão 9:
-- Testes referentes a limitações de valores, a restrições de valores e a valores nulos
-- foram feitos a fim de garantir o funcionamento do Banco de Dados.

-- Questão 10:
-- Foi criada uma chave estrangeira na relaçao tarefas, a qual faz referência a um funcionário.
-- Além disso, foi criada a constraint para que na operação DELETE fosse executada uma atualização em cascata.
-- Se mudarmos a constraint anterior para ON DELETE RESTRICT, a remoção do funcionário não é permitida.

-- Questão 11:
-- Foi adicionada uma nova constraint com o intuito de garantir que apenas a tarefa com status = 'P' possa ter o atributo
-- func_resp_cpf igual a NULL;
-- Após isso, foi deletada a constraint tarefas_cpf_fk, para que uma nova (ON DELETE SET NULL) ser adicionada;
-- Sendo assim, algumas remoções não funcionaram, pois na atualização dos valores, o novo valor é do func_resp_cpf é NULL, 
-- e de acordo com a nova constraint, isso não é possível quando o status é igual a 'E' ou 'C'.
-- Além disso para que fosse testado com todos os status, uma nova tarefa foi criada com status igual a 'E', já que antes não existia.

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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_cpf_fk;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.funcionario (
    superior_cpf character(11),
    cpf character(11) NOT NULL,
    nome character varying(30) NOT NULL,
    data_nasc date NOT NULL,
    funcao character varying(11),
    nivel character(1) NOT NULL,
    CONSTRAINT func_check CHECK ((((funcao)::text = 'LIMPEZA'::text) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT func_check_2 CHECK ((((superior_cpf IS NULL) AND ((funcao)::text = 'SUP_LIMPEZA'::text)) OR ((superior_cpf IS NOT NULL) AND ((funcao)::text = 'SUP_LIMPEZA'::text)) OR ((superior_cpf IS NOT NULL) AND ((funcao)::text = 'LIMPEZA'::text)))),
    CONSTRAINT nivel_check CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar)))
);


ALTER TABLE public.funcionario OWNER TO gabrielmedeiros;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: gabrielmedeiros
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character(11),
    prioridade integer NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT prioridade_check CHECK ((prioridade <= 32767)),
    CONSTRAINT prioridade_check_2 CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT status_check CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar))),
    CONSTRAINT status_check_2 CHECK ((((status <> 'P'::bpchar) AND (func_resp_cpf IS NOT NULL)) OR (status = 'P'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO gabrielmedeiros;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--

INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '12345678911', 'Pedro da Silva', '1980-05-07', 'SUP_LIMPEZA', 'S');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678911', '12345678912', 'Jose da Silva', '1980-03-08', 'LIMPEZA', 'J');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '42342342342', 'Chico da Silva', '1979-09-23', 'SUP_LIMPEZA', 'S');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '75423424242', 'Beatriz Lacerda', '1982-05-07', 'SUP_LIMPEZA', 'S');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678912', '42345242342', 'Tadeu Oliveira', '1978-05-07', 'SUP_LIMPEZA', 'J');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678912', '54671829018', 'Ana Caroline', '1982-10-22', 'LIMPEZA', 'J');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '35432323254', 'Risonilson Ferreira', '1981-08-29', NULL, 'P');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '54543534534', 'Ricardo Ferreira', '1982-11-21', NULL, 'P');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678912', '54364356757', 'Lucas Amaral', '1980-04-20', 'LIMPEZA', 'P');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '87878787878', 'Neymar Jubileu', '1979-03-18', 'SUP_LIMPEZA', 'S');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678912', '54534534543', 'Tadeu Lacerda', '1982-11-02', 'LIMPEZA', 'J');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES (NULL, '97786588945', 'Maria Joana', '1981-10-03', 'SUP_LIMPEZA', 'S');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678912', '98765432111', 'Tadeu de Atena', '1980-02-12', 'SUP_LIMPEZA', 'S');
INSERT INTO public.funcionario (superior_cpf, cpf, nome, data_nasc, funcao, nivel) VALUES ('12345678912', '98765432122', 'Iago de Platão', '1980-08-09', 'LIMPEZA', 'J');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: gabrielmedeiros
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (21474321312, 'limpar janelas da sala 204', '54364356757', 1, 'E');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', NULL, 4, 'P');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas_cpf_fk; Type: FK CONSTRAINT; Schema: public; Owner: gabrielmedeiros
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_cpf_fk FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

