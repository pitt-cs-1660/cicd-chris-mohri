# BUILDER
FROM python:3.11-buster AS build

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi

# APPLICATION

FROM python:3.11-buster AS app

WORKDIR /app

COPY --from=build /app /app
COPY entrypoint.sh /entrypoint.sh

RUN pip install uvicorn

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
