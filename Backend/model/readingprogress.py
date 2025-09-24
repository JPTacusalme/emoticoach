from sqlmodel import SQLModel, Field, Relationship
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ReadingProgress(SQLModel, table=True):
    __tablename__ = "readingprogress"

    ProgressID: str = Field(primary_key=True)
    ReadingsID: Optional[str] = Field(default=None, foreign_key="readingsinfo.ReadingsID")
    CurrentPage: Optional[int] = Field(default=None) # Current Page
    LastReadAt: Optional[datetime] = Field(default=None)
    CompletedAt: Optional[datetime] = Field(default=None)
    MobileNumber: Optional[str] = Field(default=None)

    # Relationship
    reading: Optional["ReadingsInfo"] = Relationship(back_populates="progresses")

class ReadingProgressCreate(BaseModel):
    ReadingsID: str
    CurrentPage: int
    LastReadAt: Optional[datetime] = None  # ISO date string
    CompletedAt: Optional[datetime] = None  # ISO date string
    MobileNumber: str

class ReadingProgressRead(BaseModel):
    ProgressID: str
    ReadingsID: str
    CurrentPage: Optional[int] = None
    LastReadAt: Optional[datetime] = None
    CompletedAt: Optional[datetime] = None
    MobileNumber: str

    class Config:
        from_attributes = True
