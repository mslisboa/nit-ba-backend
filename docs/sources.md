
# Fontes de Dados — Backend

## 1. Objetivo

Este documento descreve as fontes de dados que alimentam o banco PostgreSQL do módulo de integração estadual dos NITs da Bahia.

O backend recebe informações processadas pelo ETL e disponibiliza esses dados por meio de APIs REST.

O objetivo deste documento é:

- Registrar as fontes utilizadas;
- Identificar quais entidades são alimentadas por cada fonte;
- Documentar a semântica dos dados;
- Estabelecer os contratos com o ETL;
- Identificar limitações conhecidas;
- Garantir a procedência das informações;
- Orientar a disponibilização dos dados pela API.

O backend não deve realizar diretamente a extração das fontes externas.

## 2. Fluxo de dados

O fluxo esperado é:

Fontes externas
    |
    v
ETL (repositório independente)
    |
    v
Transformação e validação
    |
    v
PostgreSQL
    |
    v
Backend (FastAPI)
    |
    v
API REST
    |
    v
Frontend (Next.js)

O ETL é responsável por preparar os registros.

O backend é responsável por armazenar e disponibilizar as informações canônicas.

## 3. Inventário de fontes

| Categoria | Fonte | Entidades alimentadas |
|---|---|---|
| NITs | DATANIT | NIT |
| NITs | Relatórios dos NITs | NIT e informações complementares |
| Instituições/ICTs | Fontes institucionais | Instituição e Unidade Institucional |
| Pesquisadores | Observatório/SIMCC | Pesquisador e Pesquisador-Instituição |
| Propriedade Intelectual | BADEPI | Propriedade Intelectual, PI-Instituição e PI-Pesquisador |
| Territórios | Observatório/SIMCC | Município e Território de Identidade |

A estrutura definitiva dos campos depende da inspeção dos arquivos reais e dos contratos definidos entre ETL e backend.

## 4. DATANIT — NITs

### 4.1 Finalidade

A DATANIT é uma das principais referências para identificar os NITs que deverão integrar o módulo.

O universo inicial de NITs deverá ser validado com base na base e em fontes institucionais complementares.

### 4.2 Entidade de destino

NIT.

### 4.3 Informações esperadas

- Identificação do NIT;
- Nome;
- Sigla;
- Instituição relacionada;
- Caracterização;
- Informações disponíveis sobre sua atuação;
- Identificador original.

Nem todas essas informações necessariamente estarão disponíveis na DATANIT.

### 4.4 Regras de integração

- Preservar o identificador original.
- Normalizar o nome e a sigla.
- Identificar a instituição relacionada.
- Validar a correspondência institucional.
- Não criar NITs duplicados.
- Registrar a fonte e o período de referência.

### 4.5 Limitações

A DATANIT não deve ser considerada automaticamente um inventário definitivo de todas as estruturas de inovação da Bahia.

Registros adicionais podem ser obtidos por meio de relatórios e informações institucionais.

## 5. Relatórios dos NITs

### 5.1 Finalidade

Os relatórios dos NITs complementam as informações obtidas na DATANIT.

Podem conter dados institucionais e indicadores referentes a diferentes anos.

### 5.2 Entidades de destino

- NIT;
- Instituição;
- Propriedade Intelectual, quando aplicável;
- Informações de procedência.

### 5.3 Informações esperadas

Investigar:

- Identificação;
- Instituição relacionada;
- Município;
- Informações institucionais;
- Dados de propriedade intelectual;
- Informações sobre atuação do NIT;
- Período de referência.

### 5.4 Regras de integração

Os relatórios podem apresentar formatos e níveis de detalhamento diferentes.

Os indicadores devem manter seus respectivos períodos de referência.

Não somar automaticamente valores de relatórios de anos diferentes.

Não assumir que todo indicador possui o mesmo conceito ou critério de contagem em todos os NITs.

Os dados devem ser armazenados de acordo com o modelo canônico e seus metadados de origem.

## 6. Fontes institucionais — Instituições/ICTs

### 6.1 Finalidade

As fontes institucionais serão utilizadas para cadastrar e complementar informações das instituições.

A fonte definitiva para determinados campos ainda precisa ser consolidada.

### 6.2 Entidades de destino

- Instituição;
- Unidade Institucional;
- Município.

### 6.3 Informações esperadas

- Nome oficial;
- Sigla;
- Natureza;
- Tipo;
- Site;
- Identificadores institucionais;
- Município da sede;
- Campi e unidades, quando disponíveis.

### 6.4 Regras de integração

- Priorizar identificadores institucionais.
- Normalizar nomes e siglas.
- Evitar duplicações.
- Registrar variações de nomenclatura quando necessário.
- Diferenciar sede e unidades.
- Não considerar automaticamente o município da sede como localização de todos os campi.

### 6.5 Limitações

A fonte definitiva para as informações institucionais deverá ser validada.

Não implementar integrações com fontes ainda em avaliação.

O VIP para identificação de estruturas de inovação e produção tecnológica está fora do escopo atual.

## 7. Observatório/SIMCC — Pesquisadores

### 7.1 Finalidade

O Observatório/SIMCC será utilizado para identificar pesquisadores e seus vínculos institucionais.

### 7.2 Entidades de destino

- Pesquisador;
- Pesquisador-Instituição;
- Unidade Institucional, quando aplicável.

### 7.3 Informações esperadas

- Nome;
- Identificador SIMCC;
- Identificador Lattes, quando disponível;
- ORCID, quando disponível;
- Área de atuação;
- Instituição;
- Unidade institucional, quando identificada.

### 7.4 Regras de integração

- Preservar identificadores da fonte.
- Não utilizar nome como identificador único.
- Permitir múltiplos vínculos institucionais.
- Diferenciar vínculo atual e histórico quando os dados permitirem.
- Não presumir que todos os pesquisadores estejam cobertos pela fonte.

### 7.5 Correspondência com BADEPI

Os pesquisadores podem aparecer na BADEPI com variações de nomes.

A correspondência deve priorizar identificadores confiáveis.

Quando não existir identificador suficiente, não realizar associação definitiva exclusivamente pelo nome.

O relacionamento deve permanecer pendente de validação quando houver dúvida.

### 7.6 Limitações

A cobertura de pesquisadores depende da disponibilidade da fonte e das informações fornecidas pelas instituições.

A ausência de um pesquisador no SIMCC não significa necessariamente que ele não possua produção de propriedade intelectual.

## 8. BADEPI — Propriedade Intelectual

### 8.1 Finalidade

A BADEPI será utilizada como fonte principal dos registros de propriedade intelectual.

### 8.2 Entidades de destino

- Propriedade Intelectual;
- PI-Instituição;
- PI-Pesquisador;
- Fonte de Dados;
- Lote de Importação.

### 8.3 Modalidades

Considerar as modalidades efetivamente disponibilizadas pela fonte, incluindo quando existentes:

- Patentes de invenção;
- Modelos de utilidade;
- Programas de computador;
- Marcas;
- Desenhos industriais;
- Indicações geográficas;
- Outras modalidades.

### 8.4 Informações esperadas

Inspecionar a disponibilidade de:

- Identificador original;
- Título;
- Tipo de PI;
- Número do processo;
- Data de depósito;
- Data de publicação;
- Situação;
- Depositantes;
- Titulares;
- Inventores;
- Autores.

Não pressupor que todos os campos estejam disponíveis para todas as modalidades.

### 8.5 Regras de integração

- Manter um registro principal por ativo.
- Preservar o identificador original da BADEPI.
- Diferenciar modalidades de PI.
- Diferenciar titulares, depositantes, inventores e autores.
- Representar participantes através das entidades associativas.
- Não duplicar registros por quantidade de participantes.
- Não associar automaticamente a PI ao NIT da instituição.

### 8.6 Informações históricas

Datas de depósito e publicação devem ser preservadas.

O backend deve permitir consultas históricas por ano, sempre considerando a data e o critério utilizado.

Não confundir quantidade de depósitos, quantidade de registros publicados e quantidade de ativos em determinada situação.

### 8.7 Limitações

A integração entre BADEPI, SIMCC e fontes institucionais depende da disponibilidade de identificadores comuns.

Correspondências não confirmadas não devem ser apresentadas como definitivas.

### 8.8 Escopo

Transferência de Tecnologia, contratos e licenciamentos não fazem parte do MVP.

Não disponibilizar endpoints específicos para essas categorias nesta versão.

## 9. Observatório/SIMCC — Territórios de Identidade

### 9.1 Finalidade

Utilizar os dados territoriais para estabelecer a relação entre municípios e Territórios de Identidade.

### 9.2 Entidades de destino

- Município;
- Território de Identidade;
- Unidade Institucional.

### 9.3 Informações esperadas

- Código IBGE;
- Nome do município;
- UF;
- Identificador do território, quando disponível;
- Nome do Território de Identidade.

### 9.4 Regras de integração

- Utilizar código IBGE.
- Manter nomes normalizados.
- Validar o relacionamento município-território.
- Evitar relacionamentos criados apenas por comparação textual.
- Permitir atualização controlada da referência territorial.

### 9.5 Utilização pelo backend

Os dados territoriais serão utilizados para:

- Filtrar instituições;
- Filtrar NITs;
- Consultar distribuição territorial de pesquisadores;
- Consultar distribuição territorial de PI;
- Disponibilizar indicadores por território.

A agregação deve respeitar a localização efetivamente associada aos registros.

## 10. Matriz de correspondência entre fontes e entidades

| Entidade | Fonte | Regra principal |
|---|---|---|
| NIT | DATANIT | Identificador original e validação institucional |
| NIT | Relatórios | Complementação e validação |
| Instituição | Fontes institucionais | Identificadores e nomenclatura oficial |
| Unidade Institucional | Fontes institucionais | Vínculo com instituição e município |
| Pesquisador | SIMCC | Identificador do pesquisador |
| Pesquisador-Instituição | SIMCC | Vínculos institucionais |
| Propriedade Intelectual | BADEPI | Identificador e processo |
| PI-Instituição | BADEPI | Papel da instituição |
| PI-Pesquisador | BADEPI + SIMCC | Correspondência validada |
| Município | SIMCC | Código IBGE |
| Território | SIMCC | Referência territorial validada |

## 11. Contrato de integração com o ETL

O backend define o modelo canônico e o ETL deve respeitar sua estrutura.

O contrato deve documentar:

- Tabela de destino;
- Nome do campo;
- Tipo;
- Obrigatoriedade;
- Chave primária;
- Chave estrangeira;
- Restrições;
- Regra de transformação;
- Identificador de origem;
- Procedência.

O ETL não deve alterar estruturas canônicas de maneira independente.

Toda mudança deve ser coordenada com o backend.

O contrato pode ser documentado adicionalmente em arquivos específicos e atualizado a cada alteração do schema.

## 12. Disponibilização pela API

A API deve disponibilizar os dados de forma normalizada.

As respostas devem apresentar informações de procedência quando relevantes.

Exemplos de metadados que podem ser apresentados:

- Fonte;
- Período de referência;
- Data da última atualização;
- Situação da validação.

O backend não deve expor arquivos brutos ou dados intermediários de staging.

Os dados disponibilizados devem ser aqueles carregados e validados no modelo canônico.

## 13. Limitações conhecidas

As seguintes questões dependem da inspeção das fontes:

### DATANIT
- Versão utilizada;
- Identificadores disponíveis;
- Cobertura;
- Campos efetivamente fornecidos.

### Relatórios dos NITs
- Formatos;
- Períodos;
- Padronização;
- Campos disponíveis.

### Instituições
- Fonte definitiva;
- Identificadores institucionais;
- Informações sobre unidades.

### SIMCC
- Estrutura dos dados;
- Identificadores;
- Cobertura;
- Histórico de vínculos.

### BADEPI
- Versão utilizada;
- Estrutura das modalidades;
- Identificadores;
- Representação de participantes;
- Critérios de situação dos registros.

### Territórios
- Códigos de referência;
- Relacionamentos com municípios;
- Atualização da base territorial.

## 14. Evolução das fontes

Novas fontes poderão ser incorporadas ao módulo futuramente.

Toda inclusão deve exigir:

1. Justificativa;
2. Avaliação de confiabilidade;
3. Identificação das entidades afetadas;
4. Inspeção dos campos;
5. Definição dos identificadores;
6. Mapeamento para o modelo canônico;
7. Regras de validação;
8. Atualização do contrato com o ETL;
9. Atualização da documentação da API, quando necessário.

Não implementar novas integrações automaticamente.

Toda mudança deve respeitar o escopo aprovado do projeto.
