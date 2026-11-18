"""Shared MySQL connection helper. Credentials come from ../.env (never committed)."""
import os
import re
from urllib.parse import quote_plus

from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".env"))


def get_engine(database="olist"):
    user = os.getenv("DB_USER", "root")
    pw = quote_plus(os.getenv("DB_PASS", ""))
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "3306")
    db = f"/{database}" if database else ""
    return create_engine(f"mysql+mysqlconnector://{user}:{pw}@{host}:{port}{db}")


def split_sql(path):
    """Split a .sql file into statements (drops -- comments, splits on ';')."""
    with open(path, encoding="utf-8") as f:
        lines = [l for l in f if not l.strip().startswith("--")]
    return [s.strip() for s in "".join(lines).split(";") if s.strip()]


def named_queries(path):
    """Return {"Q1. Monthly revenue ...": "SELECT ..."} from a file with '-- Qn.' headers."""
    with open(path, encoding="utf-8") as f:
        content = f.read()
    parts = re.split(r"^-- (Q\d+\..*)$", content, flags=re.M)
    return {parts[i].strip(): parts[i + 1].strip().rstrip(";")
            for i in range(1, len(parts), 2)}


def run_sql_file(engine, path):
    with engine.begin() as conn:
        for stmt in split_sql(path):
            conn.execute(text(stmt))
