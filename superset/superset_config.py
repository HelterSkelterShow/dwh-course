import os
SECRET_KEY = os.environ["SUPERSET_SECRET_KEY"]
SQLALCHEMY_DATABASE_URI = (
    "postgresql+psycopg2://superset:superset@postgres:5432/superset"
)
WTF_CSRF_ENABLED = True
TALISMAN_ENABLED = False  # Учебный localhost по HTTP.
FEATURE_FLAGS = {"DASHBOARD_NATIVE_FILTERS": True}
