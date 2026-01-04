"""
SkillBridge Backend API - Simplified Version (without pydantic)
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Dict, Any
import uvicorn
import uuid
from datetime import datetime

app = FastAPI(title="SkillBridge API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# In-Memory Database
users_db = {}
courses_db = []
gap_reports_db = {}
roadmaps_db = {}

def init_sample_data():
    user_id = str(uuid.uuid4())
    users_db[user_id] = {
        "id": user_id,
        "email": "student@iitu.kz",
        "name": "Nurislam Kenzheyev",
        "role": "student"
    }
    
    courses_db.extend([
        {
            "id": str(uuid.uuid4()),
            "title": "iOS Development with SwiftUI",
            "provider": "Apple",
            "description": "Learn iOS development using SwiftUI framework",
            "durationWeeks": 8,
            "price": 0.0,
            "level": "Beginner",
            "skills": ["Swift", "SwiftUI", "iOS"],
            "url": "https://developer.apple.com/swiftui",
            "rating": 4.8
        }
    ])

init_sample_data()

@app.get("/")
async def root():
    return {"message": "SkillBridge API", "version": "1.0.0"}

@app.post("/api/auth/login")
async def login(request: Dict[str, Any]):
    email = request.get("email")
    password = request.get("password")
    
    user_id = None
    for uid, user in users_db.items():
        if user["email"] == email:
            user_id = uid
            break
    
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    return {
        "token": f"token_{user_id}",
        "user": users_db[user_id]
    }

@app.post("/api/auth/register")
async def register(request: Dict[str, Any]):
    email = request.get("email")
    name = request.get("name")
    
    for user in users_db.values():
        if user["email"] == email:
            raise HTTPException(status_code=400, detail="User already exists")
    
    user_id = str(uuid.uuid4())
    new_user = {
        "id": user_id,
        "email": email,
        "name": name,
        "role": "student"
    }
    users_db[user_id] = new_user
    
    return {
        "token": f"token_{user_id}",
        "user": new_user
    }

@app.get("/api/users/me")
async def get_current_user():
    if users_db:
        user_id = list(users_db.keys())[0]
        return users_db[user_id]
    raise HTTPException(status_code=404, detail="User not found")

@app.get("/api/courses")
async def get_courses():
    return courses_db

@app.get("/api/gap-reports/{user_id}")
async def get_gap_report(user_id: str):
    if user_id in gap_reports_db:
        return gap_reports_db[user_id]
    
    gap_report = {
        "id": str(uuid.uuid4()),
        "userId": user_id,
        "readinessScore": 65.5,
        "skillGaps": [
            {
                "id": str(uuid.uuid4()),
                "skillName": "SwiftUI",
                "currentLevel": 40.0,
                "requiredLevel": 80.0,
                "priority": "High"
            }
        ],
        "generatedAt": datetime.now().isoformat()
    }
    gap_reports_db[user_id] = gap_report
    return gap_report

@app.post("/api/roadmaps/generate")
async def generate_roadmap(request: Dict[str, Any]):
    user_id = request.get("userId")
    
    if user_id in roadmaps_db:
        return roadmaps_db[user_id]
    
    roadmap = {
        "id": str(uuid.uuid4()),
        "userId": user_id,
        "title": "iOS Developer Roadmap",
        "status": "Active",
        "estimatedTotalHours": 120,
        "steps": [
            {
                "id": str(uuid.uuid4()),
                "stepOrder": 1,
                "title": "Learn Swift Basics",
                "description": "Master Swift fundamentals",
                "estHours": 20,
                "status": "Pending"
            }
        ],
        "createdAt": datetime.now().isoformat()
    }
    roadmaps_db[user_id] = roadmap
    return roadmap

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
