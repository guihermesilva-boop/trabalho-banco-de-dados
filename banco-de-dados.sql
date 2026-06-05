CREATE SCHEMA IF NOT EXISTS FEATURE_STORE;
SET search_path TO FEATURE_STORE;
DROP SCHEMA IF EXISTS feature_store CASCADE;

CREATE TABLE users ( 
    id_users SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL 
);

CREATE TABLE datasets (
    id_datasets SERIAL PRIMARY KEY,
    id_criador INT REFERENCES users (id_users),
    descricao VARCHAR(1000) NOT NULL,
    data_hora_datasets TIMESTAMP DEFAULT NOW(),
    origem_fonte VARCHAR(100)
);

CREATE TABLE version (
    id_version SERIAL PRIMARY KEY,
    id_dataset INT REFERENCES datasets (id_datasets),
    id_criador INT REFERENCES users (id_users),
    id_versao_base INT REFERENCES version (id_version), 
    data_hora_version TIMESTAMP DEFAULT NOW(),
    archive_path VARCHAR(500) NOT NULL,
    mudancas_descricao TEXT
);

CREATE TABLE log_acesso (
    id_log_acessos SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES users (id_users),
    id_versao_atual INT REFERENCES version (id_version),
    tipo_acesso VARCHAR(8), 
    data_hora_log_acesso TIMESTAMP DEFAULT NOW()
);

ALTER TABLE log_acesso 
ADD CONSTRAINT check_tipo_acesso 
CHECK (tipo_acesso IN ('VIEW', 'DOWNLOAD'));

INSERT INTO users (nome, email, senha) VALUES
('Ana Silva', 'ana.silva@feature.com', 'hash_123'),
('Bruno Costa', 'bruno.c@feature.com', 'hash_456'),
('Carla Souza', 'carla.s@feature.com', 'hash_789');

INSERT INTO datasets (id_criador, descricao, origem_fonte, data_hora_datasets) VALUES
(1, 'Dataset de Previsão de Churn - Telecom', 'CRM Interno', '2026-05-01 09:00:00'),
(2, 'Features de Fraude em Cartão de Crédito', 'API Gateway Pagamentos', '2026-05-02 14:30:00'),
(3, 'Dados de Recomendação E-commerce', 'Logs de Navegação Web', '2026-05-03 10:15:00');

INSERT INTO version (id_dataset, id_criador, archive_path, mudancas_descricao, data_hora_version) VALUES
(1, 1, '/storage/v1/churn_raw.csv', 'Carga inicial', '2026-05-01 09:30:00'),
(1, 2, '/storage/v1/churn_v2.csv', 'Normalização', '2026-05-05 16:00:00'),
(2, 2, '/storage/v2/fraud_base.csv', 'Labels de fraude', '2026-05-02 15:00:00'),
(3, 3, '/storage/v3/rec_v1.csv', 'Interações', '2026-05-03 11:00:00');

UPDATE version SET id_versao_base = 1 WHERE id_version = 2;

INSERT INTO log_acesso (id_usuario, id_versao_atual, tipo_acesso, data_hora_log_acesso) VALUES
(1, 1, 'VIEW', '2026-05-01 10:00:00'),
(2, 1, 'VIEW', '2026-05-01 11:30:00'),
(3, 1, 'DOWNLOAD', '2026-05-02 08:15:00'),
(1, 2, 'VIEW', '2026-05-06 09:00:00'),
(3, 2, 'DOWNLOAD', '2026-05-07 14:20:00'),
(2, 2, 'DOWNLOAD', '2026-05-08 10:10:00'),
(1, 3, 'VIEW', '2026-05-03 13:00:00'),
(1, 3, 'DOWNLOAD', '2026-05-04 09:45:00'),
(2, 4, 'VIEW', '2026-05-04 11:00:00'),
(3, 4, 'VIEW', '2026-05-05 15:30:00');
