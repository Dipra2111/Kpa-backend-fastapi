import os
from pydantic import BaseSettings, Field

class Settings(BaseSettings):
    APP_NAME: str = "KPA Backend API"
    ENV: str = Field("dev", env="ENV")
    POSTGRES_HOST: str = Field("localhost", env="POSTGRES_HOST")
    POSTGRES_PORT: int = Field(5432, env="POSTGRES_PORT")
    POSTGRES_DB: str = Field("kpa", env="POSTGRES_DB")
    POSTGRES_USER: str = Field("kpa_user", env="POSTGRES_USER")
    POSTGRES_PASSWORD: str = Field("kpa_pass", env="POSTGRES_PASSWORD")
    DATABASE_URL: str | None = Field(None, env="DATABASE_URL")

    # very simple demo auth (optional)
    LOGIN_PHONE: str = Field("7760873976", env="LOGIN_PHONE")
    LOGIN_PASSWORD: str = Field("to_share@123", env="LOGIN_PASSWORD")

    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()


def get_db_url() -> str:
    if settings.DATABASE_URL:
        return settings.DATABASE_URL
    return (
        f"postgresql+psycopg2://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}"
        f"@{settings.POSTGRES_HOST}:{settings.POSTGRES_PORT}/{settings.POSTGRES_DB}"
    )
