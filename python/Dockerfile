ARG PYTHON_VERSION=3.13.2
ARG DISTRO_VERSION=slim
ARG IMAGE_TAG=${PYTHON_VERSION}-${DISTRO_VERSION}

FROM python:${IMAGE_TAG} AS builder

COPY --from=ghcr.io/astral-sh/uv:0.6.3 /uv /bin/

WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-editable

COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-editable

COPY ./src ./src

#FROM gcr.io/distroless/python3-debian12:nonroot AS runner
# https://github.com/GoogleContainerTools/distroless/issues/1543#issuecomment-2432044825
FROM python:${IMAGE_TAG} AS runner

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src /app

WORKDIR /app

EXPOSE 8000

CMD ["/app/.venv/bin/uvicorn", "main:app", "--port", "8000", "--host", "0.0.0.0"]