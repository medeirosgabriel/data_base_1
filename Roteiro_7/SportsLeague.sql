-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-10-07 15:38:46.903

-- tables
-- Table: elenco
CREATE TABLE elenco (
    idPartida_pk integer  NOT NULL,
    idTime_fk integer  NOT NULL,
    cpf_jogador_pk char(11)  NOT NULL,
    posicao_pk varchar(20)  NOT NULL,
    CONSTRAINT elenco_pk PRIMARY KEY (idPartida_pk,cpf_jogador_pk,posicao_pk)
);

-- Table: jogador
CREATE TABLE jogador (
    cpf_pk char(11)  NOT NULL,
    idTime_fk integer  NOT NULL,
    nome varchar(30)  NOT NULL,
    numero integer  NOT NULL,
    idade integer  NOT NULL,
    CONSTRAINT AK_0 UNIQUE (numero) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT check_idade CHECK (( idade > 18 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT jogador_pk PRIMARY KEY (cpf_pk)
);

-- Table: partida
CREATE TABLE partida (
    idPartida_pk integer  NOT NULL,
    idTime1_fk integer  NOT NULL,
    idTime2_fk integer  NOT NULL,
    vencedor integer  NOT NULL,
    empate boolean  NOT NULL,
    data date  NOT NULL,
    resultado varchar(5)  NOT NULL,
    CONSTRAINT check_time_1 CHECK (( idTime1_fk <> idTime2_fk )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT check_vencedor CHECK (( ( vencedor is null and empate = True ) or ( vencedor is not null and empate = False ) )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT check_vencedor_2 CHECK (( vencedor = idtime1_fk or vencedor = idtime2_fk or vencedor is null )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT partida_pk PRIMARY KEY (idPartida_pk)
);

-- Table: time
CREATE TABLE time (
    idTime_pk integer  NOT NULL,
    nome varchar(30)  NOT NULL,
    tecnico varchar(30)  NOT NULL,
    numeroJogadores integer  NOT NULL,
    pontos integer  NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY (idTime_pk)
);

-- foreign keys
-- Reference: elenco_jogador (table: elenco)
ALTER TABLE elenco ADD CONSTRAINT elenco_jogador
    FOREIGN KEY (cpf_jogador_pk)
    REFERENCES jogador (cpf_pk)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: elenco_partida (table: elenco)
ALTER TABLE elenco ADD CONSTRAINT elenco_partida
    FOREIGN KEY (idPartida_pk)
    REFERENCES partida (idPartida_pk)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: elenco_time (table: elenco)
ALTER TABLE elenco ADD CONSTRAINT elenco_time
    FOREIGN KEY (idTime_fk)
    REFERENCES time (idTime_pk)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: jogador_time (table: jogador)
ALTER TABLE jogador ADD CONSTRAINT jogador_time
    FOREIGN KEY (idTime_fk)
    REFERENCES time (idTime_pk)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: partida_time_1 (table: partida)
ALTER TABLE partida ADD CONSTRAINT partida_time_1
    FOREIGN KEY (idTime1_fk)
    REFERENCES time (idTime_pk)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: partida_time_2 (table: partida)
ALTER TABLE partida ADD CONSTRAINT partida_time_2
    FOREIGN KEY (idTime2_fk)
    REFERENCES time (idTime_pk)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

