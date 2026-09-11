FROM python:3.13-slim

WORKDIR /code

ENV FLASK_APP=app/app.py \
  FLASK_RUN_HOST=0.0.0.0 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN addgroup --system appgroup && adduser --system --group appuser

COPY requirements.txt requirements.txt
RUN python -m pip install --upgrade pip setuptools==78.1.1 wheel==0.46.2 && \
    pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 5000

CMD ["flask", "run"]