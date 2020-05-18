-- Aluno: Gabriel Paiva Medeiros
-- Matrícula: 118210822
-- Período: 2020.1

-- Comentários:

-- Questão 1: 
-- Foi criado um tipo para restringir os tipos de farmácias (Sede, Filial);

-- Questão 2:
-- Foi criado um tipo para restringir as possíveis funções dos funcionários (Farmacêutico, Entregador, Vendedor,
-- Caixa e Administrador);

-- Questão 3:
-- Foi criado apenas um campo (atributo) referente a farmácia que um determinado funcionário trabalha.
-- Tal atributo é uma chave estrangeira que referencia o ID da farmácia.

-- Questão 4:
-- Foi criado apenas um campo (atributo) referente ao gerente da farmácia.
-- Tal atributo é uma chave estrangeira que referencia o cpf de um funcionário, já que o gerente é um funcionário.

-- Questão 5:
-- O atributo referente a farmácia em que um funcionário trabalha pode ser nulo, ou seja, 
-- não possui a notação 'NOT NULL'

-- Questão 6:
-- Para que isso fosse possível foi criado uma nova tabela para os endereços dos clientes.

-- Questão 7:
-- Foi criado um tipo para restringir os possíveis endereços dos clientes (Residência, Trabalho ou outro)

-- Questão 8:
-- Foi criado um atributo do tipo boolean na tabela medicamentos para identificar a necessidade de receita ou não;
-- TRUE = precisa de receita
-- FALSE = não precisa de receita

-- Questão 9:
-- Existe duas chaves estrangeiras na tabela referente as entregas, o cpf do cliente e um booleano afirmando se o cliente
-- está cadastrado. Tais chaves estrangeiras referenciam atributos da tabela Vendas, onde mais informações se encontram.

-- Questão 10:
-- O campo referente ao cpf de um cliente que fez alguma compra não faz referÊncia a nenhum atributo de outra tabela, já que 
-- o cliente pode existir ou não.

-- Questão 11:
-- Foi colocado a notação ON DELETE RESTRICT no atributo referente ao funcionário na tabela vendas. 

-- Questão 12:
-- Foi colocado a notação ON DELETE RESTRICT no atributo referente ao medicamento na tabela vendas. 

-- Questão 13:
-- Foi adicionada a constraint ver_idade,  a qual faz uso da funcao date_part() que retira partes de uma data(ano, dia, mês, ...).
-- A ideia foi pegar o ano atual e subtrair do ano em que o cliente nasceu.

-- Questão 14:
-- Foi utilizada a notação UNIQUE para restringir a existência de apenas uma farmácia por bairro.
-- UNIQUE (cidade, estado, bairro) -> Foi colocado as três variáveis pois pode existir bairros com nomes iguais em diferentes
-- estados ou cidades.

-- Questão 15:
-- Foi usado a notação EXCLUDE para garantir a existência de apenas uma sede.
-- EXCLUDE (tipo_farm WITH =) WHERE (tipo_farm = 'Sede'),

-- Questão 16:
-- Foi utilizada a notacao CHECK() para verificarmos a função do gerente.
-- Para termos acesso a função do gerente, na tabela funcionários afirmamos que o cpf e a função do funcionário
-- são únicas em conjunto. Dessa forna, tive acesso aos dois atributos para fazer a verificação.

-- Questão 17:
-- A verificação foi feita na tabela vendas, onde os dados de uma compra se encontram.
-- Nessa tabela temos uma variável booleana que afirma se um cliente está cadastrado ou não. Além disso, há uma chave estrangeira
-- que referencia o atributo do medicamento que afirma se ele precisa de receita ou não.

-- Questão 18:
-- A verificação foi feita na tabela vendas, onde os dados de uma compra se encontram.
-- Nessa tabela temos uma chave estrangeira referente a função do funcionário.
-- Para verificar usamos a notação CHECK()

-- Questão 19:
-- Para verificar o estado da farmácia, criamos um tipo para o atributo estado da tabela farmácias.

--
-- Tipos
--
CREATE TYPE poss_func AS ENUM ('Farmacêutico', 'Vendedor', 'Entregador', 'Caixa', 'Administrador');
CREATE TYPE poss_estados AS ENUM ('Maranhão', 'Paraíba', 'Rio Grande do Norte', 'Pernambuco', 'Sergipe', 'Piauí', 
                                  'Alagoas', 'Bahia', 'Ceará');
CREATE TYPE poss_tipo_farm AS ENUM ('Sede', 'Filial');

--
-- Farmácias
--
create table farmacias (
  id_farm_pk integer PRIMARY KEY,
  tipo_farm poss_tipo_farm,
  gerente_cpf_fk char(11) NOT NULL,
  gerente_func_fk poss_func NOT NULL,
  bairro varchar(30),
  cidade varchar(30),
  estado poss_estados,
  UNIQUE (cidade, estado, bairro),
  EXCLUDE (tipo_farm WITH =) WHERE (tipo_farm = 'Sede'),
  check(gerente_func_fk = 'Administrador' or gerente_func_fk = 'Farmacêutico')
);

alter table farmacias add CONSTRAINT tipo_farm check(tipo_farm = 'Filial' or tipo_farm = 'Sede');

--
-- Funcionários
--
create table funcionarios (
  funcionario_cpf_pk char(11) PRIMARY KEY,
  funcionario_funcao poss_func NOT NULL,
  farmacia_id_fk Integer,
  FOREIGN KEY (farmacia_id_fk) REFERENCES farmacias(id_farm_pk),
  UNIQUE(funcionario_cpf_pk, funcionario_funcao)
);

alter table farmacias add CONSTRAINT gerente_cpf
FOREIGN key (gerente_cpf_fk, gerente_func_fk) REFERENCES funcionarios(funcionario_cpf_pk, funcionario_funcao);

--
-- Clientes
--
CREATE TYPE poss_endereco AS ENUM ('Residência', 'Trabalho', 'Outro');

create table clientes (
  cliente_cpf_pk char(11) PRIMARY key,
  data_nasc date
);
alter table clientes add CONSTRAINT ver_idade check(DATE_PART('year', CURRENT_DATE) - DATE_PART('year', data_nasc)  >= 18);

--
-- Enderecos
--

create table enderecos (
  cliente_cpf_pk char(11),
  endereco_tipo_pk poss_endereco,
  endereco_logradouro TEXT,
  PRIMARY key(cliente_cpf_pk, endereco_tipo_pk)
);

--
-- Medicamentos
--
create table medicamentos (
  med_id integer PRIMARY KEY,
  venda_com_receita boolean,
  UNIQUE(med_id, venda_com_receita)
);

--
-- Vendas
--
create table vendas (
  venda_id_pk integer primary key,
  cliente_cpf char(11),
  cliente_cadastrado boolean,
  funcionario_cpf_fk char(11),
  funcionario_funcao_fk poss_func,
  med_id_fk INteger,
  med_com_receita_fk boolean,
  unique(venda_id_pk, cliente_cadastrado),
  check (funcionario_funcao_fk = 'Vendedor'),
  foreign key(funcionario_cpf_fk, funcionario_funcao_fk) REFERENCES 
  funcionarios(funcionario_cpf_pk, funcionario_funcao) on delete RESTRICT,
  foreign key(med_id_fk, med_com_receita_fk) references medicamentos(med_id, venda_com_receita) on delete RESTRICT,
  check((cliente_cadastrado and med_com_receita_fk) or (cliente_cadastrado and not med_com_receita_fk) 
        or (not cliente_cadastrado and not med_com_receita_fk))
);

--
-- Entregas
--
create table entregas (
  entrega_id integer PRIMARY key,
  venda_id_fk integer,
  cliente_cadastrado_fk Boolean,
  cliente_cpf_fk char(11),
  endereco_cliente_fk poss_endereco,
  foreign key (cliente_cpf_fk) REFERENCES clientes(cliente_cpf_pk),
  check (cliente_cadastrado_fk),
  Foreign key (cliente_cpf_fk, endereco_cliente_fk) references enderecos(cliente_cpf_pk, endereco_tipo_pk),
  FOREIGN key (venda_id_fk, cliente_cadastrado_fk) references vendas(venda_id_pk, cliente_cadastrado)
);
