from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    supabase_url: str = ""
    supabase_key: str = ""
    jwt_secret: str = "change-me"
    taqnyat_api_key: str = ""
    firebase_credentials_path: str = ""
    google_play_credentials: str = ""
    apple_shared_secret: str = ""
    database_url: str = ""


settings = Settings()
