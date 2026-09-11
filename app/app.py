import os
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from flask import Flask

app = Flask(__name__)


def get_client():
    vault_url = os.environ.get("KEYVAULT_URL")
    if not vault_url:
        return None

    try:
        return SecretClient(vault_url=vault_url, credential=DefaultAzureCredential())
    except Exception:
        return None


@app.route("/")
def hello_world():
    client = get_client()
    if client is None:
        return "<p>Hello, World! KEYVAULT_URL not configured.</p>"

    try:
        secret = client.get_secret("DbConnectionString")
        return f"<p>Hello, World! Secret loaded: {secret.value[:20]}...</p>"
    except Exception as exc:
        return f"<p>Hello, World! Key Vault access failed: {exc}</p>"


def get_db_connection_string():
    client = get_client()
    if client is None:
        raise ValueError("KEYVAULT_URL no está configurado")

    secret = client.get_secret("DbConnectionString")
    return secret.value

# uso:
# conn_str = get_db_connection_string()