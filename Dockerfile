# ────────────────────────
# Build-time stage
# ────────────────────────
FROM python:3.12-slim AS base

# Helpful defaults
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# —— install Python deps first (layer caching) ——
COPY pyproject.toml .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .


# —— copy the actual source ——
COPY . .

# ────────────────────────
# Run-time stage  (same image; no multi-stage needed)
# ────────────────────────

# Azure passes the port in $PORT (80 or 8080).  Default to 80 locally.
ENV PORT=80
EXPOSE 80

#   main.py now contains:
#       mcp  = FastMCP(...)
#       mcp_app = mcp.http_app(path="/linkedin")
#       app = FastAPI(lifespan=mcp_app.lifespan)
#       app.mount("/linkedin", mcp_app)
#
# ──>  Start Uvicorn against that FastAPI instance
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--proxy-headers"]
