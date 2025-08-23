from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db, Base, engine
from .. import schemas, models
from ..crud import bogie_checksheet as crud
from ..deps import require_auth

router = APIRouter(prefix="/api/forms", tags=["Bogie Checksheet"])

# create tables on first import (simple for assignment). In prod, use Alembic.
Base.metadata.create_all(bind=engine)

@router.post("/bogie-checksheet", response_model=schemas.BogieChecksheetOut, status_code=201, dependencies=[Depends(require_auth)])
def create_bogie_checksheet(payload: schemas.BogieChecksheetIn, db: Session = Depends(get_db)):
    row = crud.create_bogie_checksheet(db, payload.form_no, payload.submitted_by, payload.data)
    return schemas.BogieChecksheetOut(id=row.id, form_no=row.form_no, submitted_by=row.submitted_by, created_at=row.created_at.isoformat(), data=row.payload)

@router.get("/bogie-checksheet/{record_id}", response_model=schemas.BogieChecksheetOut, dependencies=[Depends(require_auth)])
def get_bogie_checksheet(record_id: int, db: Session = Depends(get_db)):
    row = crud.get_bogie_checksheet(db, record_id)
    if not row:
        raise HTTPException(status_code=404, detail="Not found")
    return schemas.BogieChecksheetOut(id=row.id, form_no=row.form_no, submitted_by=row.submitted_by, created_at=row.created_at.isoformat(), data=row.payload)
