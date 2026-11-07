# Imagem base slim (sem privilégios desnecessários, tamanho reduzido)
FROM python:3.12-slim

# Evita arquivos .pyc e buffers de log bloqueados
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Dependências de produção apenas (sem grupo de desenvolvimento)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Código da aplicação
COPY app ./app

# Execução como usuário não-root
RUN useradd --create-home appuser
USER appuser

# Porta configurável
ENV PORT=8000
EXPOSE ${PORT}

# Healthcheck de liveness, sem dependência externa (python stdlib)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:' + __import__('os').environ['PORT'] + '/health')" || exit 1

CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT}"]
