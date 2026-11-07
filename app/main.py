"""Aplicação FastAPI do backend do módulo de integração estadual dos NITs da Bahia.

Neste estágio (scaffolding mínimo) a aplicação expõe apenas o endpoint de
healthcheck. Os recursos de domínio (NITs, instituições, pesquisadores,
propriedade intelectual e territórios) serão adicionados nas próximas fases.
"""

from fastapi import FastAPI

app = FastAPI(
    title="NIT-BA Backend",
    version="0.1.0",
    description=(
        "API REST do módulo de integração estadual dos NITs da Bahia, "
        "integrado ao Observatório de CT&I da Bahia."
    ),
)


@app.get("/health", tags=["health"])
def health() -> dict[str, str]:
    """Healthcheck da aplicação (liveness)."""

    return {"status": "ok"}
