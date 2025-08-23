from fastapi import Header, HTTPException, status
from .config import settings

# Extremely simple header-based token auth for demo/testing

FAKE_TOKEN = "demo-static-token"


def require_auth(authorization: str | None = Header(None)):
    if authorization != f"Bearer {FAKE_TOKEN}":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Unauthorized")


def login(phone: str, password: str) -> str:
    if phone == settings.LOGIN_PHONE and password == settings.LOGIN_PASSWORD:
        return FAKE_TOKEN
    raise HTTPException(status_code=401, detail="Invalid credentials")
