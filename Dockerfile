FROM python:3.12.3

WORKDIR /app

COPY requirements.txt pyproject.toml ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

COPY . .

ENV PORT=8000

# Use MCP CLI with SSE transport instead of uvicorn
CMD ["mcp", "serve", "linkedin_api_tools:mcp", "--transport", "sse", "--host", "0.0.0.0", "--port", "8000"]
