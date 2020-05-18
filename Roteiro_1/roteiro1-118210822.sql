-- QUESTÕES 1, 2, 3, 4, 5, 7, 8

CREATE TABLE AUTOMOVEL (
	tipo VARCHAR(15),
	chassi VARCHAR(20),
	placa CHAR(7),
	PRIMARY KEY(chassi)
);

CREATE TABLE SEGURADO (
	nome_segurado VARCHAR(30) NOT NULL,
	idade INTEGER,
	cpf_segurado VARCHAR(12),
	segurado_chassi_automovel_fkey VARCHAR(20),
	PRIMARY KEY(cpf_segurado),
	FOREIGN KEY(segurado_chassi_automovel_fkey) REFERENCES AUTOMOVEL(chassi)
);

CREATE TABLE PERITO (
	nome_perito VARCHAR(30) NOT NULL,
	cpf_perito VARCHAR(12),
	PRIMARY KEY(cpf_perito)
);

CREATE TABLE OFICINA (
	cnpj CHAR(18),
	nome_oficina VARCHAR(30) NOT NULL,
	PRIMARY KEY(cnpj)
);

CREATE TABLE SEGURO (
	valor NUMERIC,
	seguro_chassi_automovel_fkey VARCHAR(20),
	seguro_cpf_segurado_fkey VARCHAR(12) NOT NULL,
	FOREIGN KEY(seguro_chassi_automovel_fkey) REFERENCES AUTOMOVEL(chassi),
	FOREIGN KEY(seguro_cpf_segurado_fkey) REFERENCES SEGURADO(cpf_segurado),
	PRIMARY KEY(seguro_chassi_automovel_fkey)
);

CREATE TABLE SINISTRO (
	descricao TEXT,
	data DATE NOT NULL,
	sinistro_chassi_automovel_fkey VARCHAR(20),
	sinistro_cpf_segurado_fkey VARCHAR(12) NOT NULL,
	FOREIGN KEY(sinistro_chassi_automovel_fkey) REFERENCES AUTOMOVEL(chassi),
	FOREIGN KEY(sinistro_cpf_segurado_fkey) REFERENCES SEGURADO(cpf_segurado),
	PRIMARY KEY(sinistro_chassi_automovel_fkey)
);

CREATE TABLE PERICIA (
	pericia_cpf_perito_fkey VARCHAR(12),
	perdatotal BOOLEAN NOT NULL,
	pericia_sinistro_fkey VARCHAR(20),
	FOREIGN KEY(pericia_sinistro_fkey) REFERENCES SINISTRO(sinistro_chassi_automovel_fkey),
	FOREIGN KEY(pericia_cpf_perito_fkey) REFERENCES PERITO(cpf_perito),
	PRIMARY KEY(pericia_cpf_perito_fkey, pericia_sinistro_fkey)
);

CREATE TABLE REPARO (
	reparo_cnpj_oficina_fkey CHAR(18),
	preco NUMERIC(20) NOT NULL,
	reparo_chassi_automovel_fkey VARCHAR(20),
	FOREIGN KEY(reparo_cnpj_oficina_fkey) REFERENCES OFICINA(cnpj),
	FOREIGN KEY(reparo_chassi_automovel_fkey) REFERENCES AUTOMOVEL(chassi),
	PRIMARY KEY(reparo_cnpj_oficina_fkey, reparo_chassi_automovel_fkey)
);

-- QUESTÃO 6, 9

DROP TABLE SEGURO;
DROP TABLE PERICIA;
DROP TABLE SINISTRO;
DROP TABLE SEGURADO;
DROP TABLE REPARO;
DROP TABLE OFICINA;
DROP TABLE PERITO;
DROP TABLE AUTOMOVEL;
