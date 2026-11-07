# Desenvolvimento — Backend

## 1. Objetivo

Este documento define os procedimentos e padrões de desenvolvimento do
backend do módulo de integração estadual dos NITs da Bahia.

Ele orienta:

- Preparação do ambiente;
- Execução da aplicação;
- Testes e lint;
- Padrões de organização e qualidade de código;
- Convenções para novos artefatos (rotas, schemas, models, migrações).

A arquitetura geral está descrita em `architecture.md`. O modelo de dados
está descrito em `data-model.md`.

## 2. Requisitos

- Python 3.12+;
- Docker (para execução em container);
- Acesso ao PostgreSQL (a partir da fase de integração com o banco).

A orquestração conjunta dos serviços é responsabilidade do repositório
`nit-ba-infra`. Este repositório possui apenas o container próprio do
backend.

## 3. Preparação do ambiente

Não utilizar empacotamento do projeto (`pip install -e .`). As dependências
são geridas por arquivos `requirements`:

```bash
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements-dev.txt
```

- `requirements.txt`: dependências de produção;
- `requirements-dev.txt`: dependências de produção + grupo de
  desenvolvimento (pytest, pytest-cov, httpx, ruff).

O arquivo `.env.example` lista as variáveis de ambiente suportadas.
Nunca versionar o arquivo `.env` real ou incluir credenciais em código.

## 4. Execução da aplicação

### 4.1 Modo de desenvolvimento

```bash
.venv/bin/uvicorn app.main:app --reload --port 8000
```

A documentação interativa (OpenAPI) fica disponível em
`http://localhost:8000/docs`.

### 4.2 Container

```bash
docker build -t nit-ba-backend .
docker run --rm -p 8000:8000 nit-ba-backend
```

O container executa como usuário não-root, expõe a porta via `PORT` e
possui `HEALTHCHECK` apontando para `/health`.

Detalhes do container estão em `architecture.md` (seção Docker).

## 5. Testes

```bash
.venv/bin/pytest
```

Diretrizes:

- Testes unitários (services/schemas), de integração (repositories) e de
  API (`TestClient`), conforme `architecture.md` (seção Testes);
- O teste de fumaça de `/health` deve permanecer sempre funcional;
- A raiz do projeto é incluída no `sys.path` dos testes por meio de
  `conftest.py` — não instalar o projeto como pacote;
- Quando houver integração com banco, utilizar banco de dados de teste
  isolado. Nunca executar testes destrutivos no banco de desenvolvimento
  ou produção;
- Novo código deve vir acompanhado de testes pertinentes.

## 6. Lint e formatação

```bash
.venv/bin/ruff check .
```

Configuração em `pyproject.toml` (`line-length` 100, alvo Python 3.12,
conjunto de regras: `E`, `F`, `W`, `I`, `UP`, `B`).

O código deve passar no lint antes de cada commit.

## 7. Organização do código

A estrutura de referência está em `architecture.md` (seção Organização
interna). Regras obrigatórias:

- Rotas (`app/api/routes/`): definem endpoints, validam requisições e
  delegam aos services. Sem consultas complexas ou regras de negócio;
- Schemas (`app/schemas/`): validação e serialização Pydantic. Não
  retornar objetos ORM diretamente. Schemas separados para respostas,
  filtros e paginação;
- Models (`app/models/`): entidades persistidas, respeitando
  `data-model.md`;
- Repositories (`app/repositories/`): acesso e consultas ao banco,
  encapsulados;
- Services (`app/services/`): regras de negócio;
- Core (`app/core/`): configuração de ambiente, conexão e segurança.

Criar diretórios somente quando houver conteúdo para eles. Não reorganizar
código existente sem necessidade.

## 8. Migrações

O backend é responsável pelas migrações do schema canônico (ver
`data-model.md`, seção Migrações).

Diretrizes:

- Toda alteração estrutural em migração versionada, em `migrations/`;
- Nunca alterar o banco manualmente sem migração correspondente;
- Avaliar impacto no ETL e na API antes de alterar estruturas carregadas;
- Comunicar alterações de schema à equipe de ETL e ao frontend quando
  afetarem contratos.

## 9. Dependências

- Não adicionar dependências sem necessidade (ver AGENTS.md);
- Ao introduzir uma dependência nova, justificar no merge request e
  incluir em `requirements.txt` ou `requirements-dev.txt` conforme o uso
  (produção ou desenvolvimento);
- Fixar versão mínima compatível.

## 10. Commits e revisão

- Commits pequenos e incrementais, com escopo claro;
- Antes de cada PR: `pytest` e `ruff check .` sem erro;
- Não commitar `.env`, `.venv/`, artefatos de build ou caches
  (regras em `.gitignore`);
- Alterações que afetam contratos com os repositórios `nit-ba-etl`,
  `nit-ba-frontend` ou `nit-ba-infra` devem ser sinalizadas na descrição
  do PR e coordenadas com as equipes responsáveis.
