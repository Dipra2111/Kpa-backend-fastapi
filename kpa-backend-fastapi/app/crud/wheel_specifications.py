from sqlalchemy.orm import Session
from .. import models


def list_specs(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.WheelSpecification).offset(skip).limit(limit).all()


def get_by_code(db: Session, wheel_code: str):
    return db.query(models.WheelSpecification).filter(models.WheelSpecification.wheel_code == wheel_code).first()


def create_or_update(db: Session, *, wheel_code: str, diameter_mm: int, material: str, manufacturer: str, notes: str | None):
    existing = get_by_code(db, wheel_code)
    if existing:
        existing.diameter_mm = diameter_mm
        existing.material = material
        existing.manufacturer = manufacturer
        existing.notes = notes
        db.commit()
        db.refresh(existing)
        return existing
    row = models.WheelSpecification(
        wheel_code=wheel_code,
        diameter_mm=diameter_mm,
        material=material,
        manufacturer=manufacturer,
        notes=notes,
    )
    db.add(row)
    db.commit()
    db.refresh(row)
    return row
