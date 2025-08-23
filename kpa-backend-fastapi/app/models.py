from sqlalchemy import Column, Integer, String, DateTime, func, JSON, ForeignKey
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship
from .database import Base

# Store the full Bogie Checksheet payload as JSONB for fidelity + a few indexed columns
class BogieChecksheet(Base):
    __tablename__ = "bogie_checksheet"

    id = Column(Integer, primary_key=True, index=True)
    form_no = Column(String(64), index=True, nullable=True)
    submitted_by = Column(String(128), nullable=True)
    payload = Column(JSONB, nullable=False)  # nested data preserved as-is
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # optional: child rows if you want to query specific arrays later


class WheelSpecification(Base):
    __tablename__ = "wheel_specifications"

    id = Column(Integer, primary_key=True, index=True)
    wheel_code = Column(String(64), index=True, unique=True)
    diameter_mm = Column(Integer, nullable=False)
    material = Column(String(64), nullable=False)
    manufacturer = Column(String(128), nullable=False)
    notes = Column(String(512), nullable=True)
