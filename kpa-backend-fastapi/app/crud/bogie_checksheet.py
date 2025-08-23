from sqlalchemy.orm import Session
from .. import models


def create_bogie_checksheet(db: Session, form_no: str | None, submitted_by: str | None, payload: dict) -> models.BogieChecksheet:
    row = models.BogieChecksheet(form_no=form_no, submitted_by=submitted_by, payload=payload)
    db.add(row)
    db.commit()
    db.refresh(row)
    return row


def get_bogie_checksheet(db: Session, record_id: int) -> models.BogieChecksheet | None:
    return db.query(models.BogieChecksheet).filter(models.BogieChecksheet.id == record_id).first()
