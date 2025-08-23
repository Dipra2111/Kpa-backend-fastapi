# KPA Backend – FastAPI (Bogie Checksheet + Wheel Specifications)

This submission implements two APIs from the KPA Form Data brief:

1. **POST /api/forms/bogie-checksheet** – Stores a nested bogie checksheet payload (JSONB) with minimal metadata.
2. **GET /api/forms/wheel-specifications** – Lists wheel specification master data (with **POST upsert** for quick seeding).

The app uses **FastAPI**, **PostgreSQL**, and **SQLAlchemy**.

## Quick Start (Docker)

```bash
# 1) Start services
docker compose up -d --build

# 2) Open docs
# http://localhost:8000/docs

# 3) Get auth token (optional helper)
curl -s -X POST http://localhost:8000/api/auth/login   -H 'Content-Type: application/json'   -d '{"phone":"7760873976","password":"to_share@123"}'
# Response: {"token":"demo-static-token"}

# 4) Create a wheel spec to seed data
curl -X POST http://localhost:8000/api/forms/wheel-specifications  -H 'Authorization: Bearer demo-static-token' -H 'Content-Type: application/json'  -d '{"wheel_code":"W-1001","diameter_mm":920,"material":"EN8","manufacturer":"ACME","notes":"Trial"}'

# 5) List wheel specs
curl -H 'Authorization: Bearer demo-static-token' http://localhost:8000/api/forms/wheel-specifications

# 6) Create a bogie checksheet (example shape)
curl -X POST http://localhost:8000/api/forms/bogie-checksheet  -H 'Authorization: Bearer demo-static-token' -H 'Content-Type: application/json'  -d '{
   "form_no":"KPA-BC-0001",
   "submitted_by":"Inspector A",
   "data":{
      "bogie_id":"BG-7788",
      "date":"2025-08-22",
      "wheels":[{"position":"L1","thickness":32.1},{"position":"R1","thickness":31.9}],
      "remarks":"OK"
   }
 }'
```

## Local (without Docker)

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# set envs or copy .env.example to .env and tweak DB to your local Postgres
uvicorn app.main:app --reload
```

## Tech Stack
- FastAPI, Pydantic v2
- PostgreSQL 15
- SQLAlchemy 2.x ORM
- Docker & Compose

## API Contracts

### Auth (helper for testing)
`POST /api/auth/login` → `{ token }` (use as `Authorization: Bearer <token>`) using the credentials from the brief.

### Bogie Checksheet
- `POST /api/forms/bogie-checksheet` – **Body**
  ```json
  {
    "form_no": "KPA-BC-0001",
    "submitted_by": "Inspector A",
    "data": { "...full nested object from Postman example..." }
  }
  ```
  **201** → stored record with `id`, `created_at`, and the same `data` echoed back.

- `GET /api/forms/bogie-checksheet/{id}` – fetches a single record.

### Wheel Specifications
- `POST /api/forms/wheel-specifications` – Upsert a spec (convenience for seeding/testing).
- `GET /api/forms/wheel-specifications?skip=0&limit=100` – List specs.

## Notes & Assumptions
- To closely mirror the Postman specimen, the full Bogie Checksheet is preserved as JSONB (`payload`) to avoid losing nested fields.
- Minimal auth is added only to demonstrate guarded routes; remove if not required by the FE.
- Tables are created on startup for simplicity. In production, use Alembic migrations.

## Postman
Import `postman_collection.json` and hit *Auth → Login* first to copy the token into collection variables. Then run the two folders.

## Bonus
- `.env` based config
- Dockerized app + DB
- OpenAPI live docs at `/docs` (Swagger UI) and `/redoc`.

## Submission
Include links to your zipped source/GitHub, exported Postman collection, README (this file), and a short demo video.

---

### Email Template (for submission)

Subject: KPA Backend Assignment – Dipra Banerjee

To: contact@suvidhaen.com

Body:
```
Hello Team,

Please find my submission for the Backend Assignment (KPA Form Data APIs).

CV: <attach your resume>
Source Code: https://drive.com/dipra_kpa_api_assignment.zip (or GitHub link)
Postman Collection: https://drive.com/dipra_kpa_postman_collection.json
README: https://drive.com/dipra_kpa_readme.txt
Screen Recording: <your Google Drive link>

Notes:
- Implemented APIs: POST /api/forms/bogie-checksheet, GET /api/forms/wheel-specifications (with POST upsert for seed)
- Tech: FastAPI, PostgreSQL, SQLAlchemy, Docker

Thanks & Regards,
Dipra Banerjee
```
