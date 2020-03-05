# Create base builder image
FROM python:3.8.0-alpine AS base

RUN apk update && \
    apk add --virtual build-deps gcc python-dev musl-dev && \
    apk add postgresql-dev && \
    apk add netcat-openbsd

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /usr/src/app
COPY flaskr/ flaskr/

COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

CMD [ "/usr/src/app/entrypoint.sh" ]


# Create image for linter
FROM base AS linter

WORKDIR /usr/src/app
COPY flaskr/ flaskr/
COPY tests/ tests/

CMD ["flake8", "flaskr", "tests"]


# Create image for tests
FROM base AS tests

WORKDIR /usr/src/app
COPY tests/ tests/

WORKDIR /usr/src/app/tests

CMD ["pytest"]
