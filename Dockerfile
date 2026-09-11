FROM python:3.11-slim

WORKDIR /code

ENV FLASK_APP=app/app.py \
  FLASK_RUN_HOST=0.0.0.0 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

RUN addgroup --system appgroup && adduser --system --group appuser

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 5000

CMD ["flask", "run"]