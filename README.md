# NIT-BA Backend

Backend do módulo de integração estadual dos NITs da Bahia, integrado ao
Observatório de CT&I da Bahia.

Aplicação em Python + FastAPI que disponibiliza os dados processados pelo ETL
armazenados no PostgreSQL por meio de uma API REST.

## Estrutura

```
app/                  # Aplicação FastAPI
tests/                # Testes
requirements.txt      # Dependências de produção
requirements-dev.txt  # Dependências de desenvolvimento (testes e lint)
Dockerfile            # Imagem de produção do backend
```

A orquestração conjunta dos serviços (banco, backend, frontend, ETL) é
responsabilidade do repositório `nit-ba-infra`. Este repositório possui
apenas o container do backend.

## Requisitos

- Python 3.12+
- Docker

## Ambiente de desenvolvimento

Criar o ambiente virtual e instalar as dependências (incluindo as de
desenvolvimento):

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements-dev.txt
```

### Rodar a aplicação

```bash
.venv/bin/uvicorn app.main:app --reload --port 8000
```

A documentação interativa (OpenAPI) fica disponível em
`http://localhost:8000/docs`.

As configurações são lidas de variáveis de ambiente. Use `.env.example`
como referência — não versionar o arquivo `.env` real.

### Testes e lint

```bash
.venv/bin/pytest
.venv/bin/ruff check .
```

## Container

```bash
docker build -t nit-ba-backend .
docker run --rm -p 8000:8000 nit-ba-backend
```

Verificar o healthcheck:

```bash
curl http://localhost:8000/health
```

Variáveis suportadas pelo container (com defaults): `PORT` (porta exposta
pelo uvicorn).

## Roadmap

Neste estágio o exposto é apenas o healthcheck. As próximas fases adicionam:

1. Integração com PostgreSQL e migrações do schema canônico;
2. Recursos de domínio: instituições, NITs, pesquisadores, propriedade
   intelectual e territórios;
3. Filtros, paginação e indicadores.
