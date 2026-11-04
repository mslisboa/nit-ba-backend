
# Arquitetura do Backend

## 1. Visão geral

Este repositório contém o backend do módulo de integração estadual dos NITs da Bahia.

O backend será responsável por disponibilizar uma API REST para consulta e visualização das informações armazenadas no PostgreSQL.

O sistema integra informações sobre:

- NITs;
- Instituições/ICTs;
- Pesquisadores;
- Propriedade Intelectual;
- Municípios;
- Territórios de Identidade.

A aplicação será desenvolvida utilizando Python e FastAPI.

O backend é independente dos repositórios de frontend e ETL, mas compartilha com eles os contratos de integração e o banco de dados.

## 2. Responsabilidades

O backend é responsável por:

1. Definir e manter o modelo canônico de dados.
2. Administrar as migrações do banco principal.
3. Disponibilizar APIs REST.
4. Implementar regras de negócio e validações.
5. Consultar e relacionar as entidades.
6. Disponibilizar filtros e indicadores.
7. Expor informações sobre fontes e períodos de referência.
8. Garantir integridade referencial.
9. Controlar o acesso aos dados.
10. Documentar os contratos de integração.

O backend NÃO é responsável por:

- Realizar extração de fontes externas;
- Executar os pipelines de ETL;
- Normalizar arquivos brutos;
- Implementar a interface;
- Gerenciar containers de toda a aplicação;
- Implementar funcionalidades fora do MVP.

## 3. Arquitetura geral

O fluxo de comunicação entre os componentes é:

Fontes de dados
    |
    v
ETL (Python)
    |
    v
PostgreSQL
    |
    v
Backend (FastAPI)
    |
    v
API REST / JSON
    |
    v
Frontend (Next.js)

O backend disponibiliza os dados processados pelo ETL.

O frontend não deve acessar diretamente o PostgreSQL.

O ETL não deve acessar funcionalidades internas do backend como forma de substituir o contrato de carga definido para o banco.

## 4. Responsabilidade sobre o banco de dados

O backend é responsável pelo schema canônico do PostgreSQL.

Isso significa que ele controla:

- Definição das tabelas definitivas;
- Chaves primárias;
- Chaves estrangeiras;
- Restrições de unicidade;
- Restrições de integridade;
- Índices;
- Relacionamentos;
- Migrações;
- Evolução do modelo de dados.

O ETL pode realizar cargas nos schemas e tabelas autorizados, mas não deve alterar diretamente a estrutura canônica.

Toda alteração estrutural deverá ser realizada através de migrações versionadas no backend.

As mudanças no schema devem ser comunicadas à equipe de ETL.

## 5. Organização interna

A arquitetura deve separar responsabilidades.

Estrutura de referência:

backend/
|
├── app/
│   ├── api/
│   │   ├── routes/
│   │   └── dependencies.py
│   │
│   ├── core/
│   │   ├── config.py
│   │   ├── database.py
│   │   └── security.py
│   │
│   ├── models/
│   │   ├── nit.py
│   │   ├── instituicao.py
│   │   ├── unidade_institucional.py
│   │   ├── pesquisador.py
│   │   ├── propriedade_intelectual.py
│   │   ├── municipio.py
│   │   ├── territorio.py
│   │   ├── fonte_dados.py
│   │   └── importacao.py
│   │
│   ├── schemas/
│   │   ├── nit.py
│   │   ├── instituicao.py
│   │   ├── pesquisador.py
│   │   ├── propriedade_intelectual.py
│   │   └── territorio.py
│   │
│   ├── repositories/
│   │
│   ├── services/
│   │
│   └── main.py
│
├── migrations/
│
├── tests/
│
├── docs/
│
├── Dockerfile
├── .dockerignore
├── .env.example
├── pyproject.toml
└── README.md

Essa estrutura é uma referência, não uma exigência de organização.

Antes de implementar, inspecionar o repositório e verificar se já existem padrões estabelecidos.

Não reorganizar código existente sem necessidade.

## 6. Camadas da aplicação

### 6.1 API / Routes

Responsável por:

- Definir endpoints;
- Receber parâmetros;
- Aplicar dependências;
- Validar requisições;
- Retornar respostas HTTP;
- Encaminhar as operações para os services.

As rotas não devem conter consultas complexas ou regras de negócio extensas.

### 6.2 Schemas

Responsável pela validação e serialização dos dados.

Utilizar schemas específicos para:

- Respostas;
- Parâmetros;
- Filtros;
- Paginação;
- Dados relacionados.

Não retornar diretamente objetos do ORM.

### 6.3 Models

Representam as entidades persistidas no PostgreSQL.

Devem respeitar o modelo de dados documentado em data-model.md.

### 6.4 Repositories

Responsáveis pelo acesso e pelas consultas ao banco de dados.

Devem encapsular consultas e operações de persistência.

### 6.5 Services

Responsáveis pelas regras de negócio.

Exemplos:

- Consultar informações de um NIT;
- Obter indicadores de PI;
- Consultar distribuição territorial;
- Relacionar pesquisadores e instituições;
- Consolidar informações para a visão geral.

A lógica de negócio não deve ficar concentrada nas rotas.

### 6.6 Core

Responsável por configurações compartilhadas:

- Configuração de ambiente;
- Conexão com PostgreSQL;
- Sessões de banco;
- Segurança;
- Configurações globais.

## 7. API REST

A API deverá disponibilizar os dados necessários para o frontend.

Sugestão de prefixo:

/api/v1

Os endpoints devem seguir convenções REST e utilizar nomes consistentes.

### 7.1 Recursos principais

NITs:

- GET /api/v1/nits
- GET /api/v1/nits/{id}

Instituições:

- GET /api/v1/instituicoes
- GET /api/v1/instituicoes/{id}

Pesquisadores:

- GET /api/v1/pesquisadores
- GET /api/v1/pesquisadores/{id}

Propriedade Intelectual:

- GET /api/v1/propriedades-intelectuais
- GET /api/v1/propriedades-intelectuais/{id}

Municípios:

- GET /api/v1/municipios
- GET /api/v1/municipios/{id}

Territórios:

- GET /api/v1/territorios
- GET /api/v1/territorios/{id}

Indicadores:

- GET /api/v1/indicadores/resumo
- GET /api/v1/indicadores/territoriais
- GET /api/v1/indicadores/propriedade-intelectual

Esses endpoints são uma proposta inicial e devem ser ajustados aos padrões de nomenclatura e integração do Observatório.

### 7.2 Consultas e filtros

As listagens devem permitir, quando aplicável:

- Pesquisa textual;
- Filtro por instituição;
- Filtro por NIT;
- Filtro por município;
- Filtro por território;
- Filtro por modalidade de PI;
- Filtro por pesquisador;
- Filtro por período.

Implementar paginação em consultas que possam retornar muitos registros.

Utilizar parâmetros documentados e validados.

### 7.3 Respostas

As respostas devem possuir estrutura consistente.

Exemplo conceitual:

{
  "data": [],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total": 0,
    "total_pages": 0
  }
}

Esse formato é uma referência e deve ser compatibilizado com os padrões existentes no Observatório.

## 8. Documentação da API

Utilizar os recursos OpenAPI disponibilizados pelo FastAPI.

Documentar:

- Descrição dos endpoints;
- Parâmetros;
- Tipos de resposta;
- Códigos HTTP;
- Filtros;
- Paginação;
- Exemplos.

A documentação deve refletir os contratos realmente implementados.

Não documentar funcionalidades que ainda não existem como se estivessem disponíveis.

## 9. PostgreSQL

Utilizar PostgreSQL como banco principal.

O acesso deverá ocorrer por meio de uma camada de persistência organizada.

Respeitar:

- Integridade referencial;
- Chaves primárias e estrangeiras;
- Restrições;
- Transações;
- Índices;
- Consultas parametrizadas.

Evitar consultas N+1 e consultas desnecessariamente complexas.

Utilizar carregamento adequado de relacionamentos.

### 9.1 Migrações

As migrações do schema canônico são responsabilidade exclusiva deste repositório.

Utilizar a ferramenta já estabelecida no projeto.

Caso não exista, avaliar uma solução compatível com o ORM escolhido.

Todas as alterações estruturais devem ser versionadas.

Não modificar o banco manualmente sem uma migração correspondente.

## 10. Integração com o ETL

O ETL é um repositório independente.

O backend define o contrato das tabelas que receberão os dados processados.

O ETL realiza a carga respeitando esse contrato.

Mudanças em:

- Nomes de tabelas;
- Campos;
- Tipos;
- Restrições;
- Identificadores;
- Relacionamentos;

devem ser comunicadas ao repositório de ETL.

O ETL não deve depender de estruturas internas dos repositories ou services do backend.

## 11. Integração com o frontend

O frontend consome exclusivamente a API REST.

O backend deve disponibilizar contratos claros e documentados.

Alterações incompatíveis em endpoints e schemas devem ser coordenadas com a equipe de frontend.

Sempre considerar:

- Tipagem;
- Estrutura das respostas;
- Paginação;
- Filtros;
- Estados de ausência de dados;
- Procedência das informações.

## 12. Tratamento de erros

Implementar respostas HTTP apropriadas.

Distinguir:

- Recurso não encontrado;
- Parâmetros inválidos;
- Erros de validação;
- Erros de banco;
- Falhas internas.

Não retornar detalhes internos ou informações sensíveis em mensagens públicas.

Utilizar logs para registrar detalhes técnicos.

## 13. Segurança

- Não armazenar credenciais no código.
- Utilizar variáveis de ambiente.
- Manter .env.example sem segredos.
- Validar todos os parâmetros recebidos.
- Utilizar consultas parametrizadas.
- Limitar exposição de dados pessoais.
- Respeitar a LGPD.
- Não expor informações internas do banco.
- Aplicar controle de acesso se necessário ao ambiente do Observatório.

Não implementar autenticação paralela sem antes verificar o mecanismo utilizado pelo Observatório.

## 14. Docker

O backend deve possuir Dockerfile próprio.

O repositório nit-ba-infra é responsável pela orquestração conjunta dos serviços.

O container deve:

- Executar a aplicação FastAPI;
- Utilizar variáveis de ambiente;
- Expor a porta configurada;
- Permitir healthcheck;
- Executar sem privilégios desnecessários;
- Não armazenar dados persistentes localmente.

As migrações devem ser executadas de maneira controlada antes de disponibilizar a aplicação.

Não executar migrações simultaneamente em múltiplas instâncias.

## 15. Testes

Implementar testes unitários, de integração e de API.

Testar:

- Consultas;
- Relacionamentos;
- Filtros;
- Paginação;
- Indicadores;
- Validações;
- Integridade referencial;
- Respostas HTTP;
- Tratamento de erros.

Utilizar banco de testes isolado.

Não executar testes destrutivos no banco de desenvolvimento ou produção.

## 16. Desenvolvimento

Antes de implementar:

1. Inspecionar o repositório.
2. Verificar dependências e versões.
3. Identificar ORM e ferramenta de migração.
4. Identificar padrões existentes.
5. Verificar integração com PostgreSQL.
6. Consultar o modelo de dados.
7. Consultar os contratos com o ETL.

Implementar incrementalmente.

Não antecipar regras de negócio que não estejam definidas.

## 17. Critérios de conclusão do MVP

O backend deverá:

- Disponibilizar consultas de NITs;
- Disponibilizar consultas de instituições;
- Disponibilizar consultas de pesquisadores;
- Disponibilizar consultas de PI;
- Disponibilizar consultas territoriais;
- Expor filtros e indicadores;
- Preservar fonte e período de referência;
- Respeitar as cardinalidades;
- Disponibilizar documentação OpenAPI;
- Possuir testes;
- Executar em container Docker.

## 18. Princípio fundamental

O backend é a camada responsável por expor informações integradas de forma consistente.

Deve preservar a integridade do modelo canônico e oferecer contratos estáveis para os demais componentes.

Não implementar funcionalidades fora do escopo do MVP sem autorização.
