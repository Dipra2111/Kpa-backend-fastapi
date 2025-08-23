from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from .routers import bogie_checksheet, wheel_specifications
from .schemas import LoginRequest, LoginResponse
from .deps import login

app = FastAPI(title="KPA Form Data APIs", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(bogie_checksheet.router)
app.include_router(wheel_specifications.router)


@app.post("/api/auth/login", response_model=LoginResponse, tags=["Auth"])  # optional helper
def do_login(req: LoginRequest):
    token = login(req.phone, req.password)
    return {"token": token}


@app.get("/", tags=["Health"])  # simple health check
async def root():
    return {"status": "ok"}
