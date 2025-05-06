# Dockerfile
FROM python:3.12.3
WORKDIR /app

COPY requirements.txt pyproject.toml ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

COPY . .

# Expose the port Azure will forward
EXPOSE 8080

# Start MCP in SSE mode on 0.0.0.0:8080  ➜  /sse endpoint appears
CMD ["mcp", "serve", "linkedin_api_tools:mcp",
     "--transport", "sse",
     "--host", "0.0.0.0",
     "--port", "8080"]
