from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from .. import schemas
from ..crud import wheel_specifications as crud
from ..deps import require_auth

router = APIRouter(prefix="/api/forms", tags=["Wheel Specifications"])


@router.get("/wheel-specifications", response_model=list[schemas.WheelSpecOut], dependencies=[Depends(require_auth)])
def list_wheel_specs(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    rows = crud.list_specs(db, skip=skip, limit=limit)
    return rows


@router.post("/wheel-specifications", response_model=schemas.WheelSpecOut, status_code=201, dependencies=[Depends(require_auth)])
def upsert_wheel_spec(body: schemas.WheelSpecIn, db: Session = Depends(get_db)):
    row = crud.create_or_update(
        db,
        wheel_code=body.wheel_code,
        diameter_mm=body.diameter_mm,
        material=body.material,
        manufacturer=body.manufacturer,
        notes=body.notes,
    )
    return row
