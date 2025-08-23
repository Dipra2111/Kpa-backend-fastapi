from typing import Any, Optional, List
from pydantic import BaseModel, Field

# ------- Auth (optional helper to match given login) -------
class LoginRequest(BaseModel):
    phone: str
    password: str

class LoginResponse(BaseModel):
    token: str

# ------- Bogie Checksheet -------
# Keep schema permissive but ensure object is present
class BogieChecksheetIn(BaseModel):
    form_no: Optional[str] = Field(None, description="Form number/reference if provided in Swagger")
    submitted_by: Optional[str] = None
    data: dict = Field(..., description="The full nested checksheet object as per Postman example")

class BogieChecksheetOut(BaseModel):
    id: int
    form_no: Optional[str]
    submitted_by: Optional[str]
    created_at: str
    data: dict

    class Config:
        from_attributes = True

# ------- Wheel Specifications -------
class WheelSpecIn(BaseModel):
    wheel_code: str
    diameter_mm: int
    material: str
    manufacturer: str
    notes: Optional[str] = None

class WheelSpecOut(WheelSpecIn):
    id: int

    class Config:
        from_attributes = True
