"""
SkillBridge Backend API with SQLite Database
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Dict, Any
import uvicorn
import uuid
from datetime import datetime
from database import db

app = FastAPI(title="SkillBridge API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "SkillBridge API", "version": "1.0.0", "database": "SQLite"}

@app.post("/api/auth/login")
async def login(request: Dict[str, Any]):
    """Login endpoint"""
    email = request.get("email")
    password = request.get("password")
    
    # Find user by email
    user = db.get_user_by_email(email)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    # Simple password check (in production, use hashed passwords)
    # For now, any password works for demo
    
    token = f"token_{user['id']}_{uuid.uuid4().hex[:16]}"
    
    return {
        "token": token,
        "user": {
            "id": user["id"],
            "email": user["email"],
            "name": user["name"],
            "role": user["role"]
        }
    }

@app.post("/api/auth/register")
async def register(request: Dict[str, Any]):
    """Register endpoint"""
    email = request.get("email")
    name = request.get("name")
    password = request.get("password")
    
    # Check if user exists
    existing_user = db.get_user_by_email(email)
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")
    
    # Create new user
    user = db.create_user(email=email, name=name, role="student")
    
    token = f"token_{user['id']}_{uuid.uuid4().hex[:16]}"
    
    return {
        "token": token,
        "user": {
            "id": user["id"],
            "email": user["email"],
            "name": user["name"],
            "role": user["role"]
        }
    }

@app.get("/api/users/me")
async def get_current_user():
    """Get current user (simplified - in production, verify token)"""
    # Return first user for demo
    users = db.get_all_users()
    if users:
        user = users[0]
        return {
            "id": user["id"],
            "email": user["email"],
            "name": user["name"],
            "role": user["role"]
        }
    raise HTTPException(status_code=404, detail="User not found")

@app.get("/api/courses")
async def get_courses():
    """Get all courses from database"""
    courses = db.get_all_courses()
    
    # Format for iOS app
    formatted_courses = []
    for course in courses:
        formatted_courses.append({
            "id": course["id"],
            "title": course["title"],
            "provider": course["provider"],
            "description": course.get("description", ""),
            "durationWeeks": course.get("duration_weeks", 0),
            "price": course.get("price", 0.0),
            "level": course.get("level", "Beginner"),
            "skills": course.get("skills", []),
            "url": course.get("url"),
            "rating": course.get("rating")
        })
    
    return formatted_courses

@app.post("/api/courses")
async def create_course(course_data: Dict[str, Any]):
    """Create a new course"""
    course = db.create_course(course_data)
    return {
        "id": course["id"],
        "title": course["title"],
        "provider": course["provider"],
        "description": course.get("description", ""),
        "durationWeeks": course.get("duration_weeks", 0),
        "price": course.get("price", 0.0),
        "level": course.get("level", "Beginner"),
        "skills": course.get("skills", []),
        "url": course.get("url"),
        "rating": course.get("rating")
    }

@app.get("/api/gap-reports/{user_id}")
async def get_gap_report(user_id: str):
    """Get gap report for user from database"""
    report = db.get_gap_report_by_user_id(user_id)
    
    if report:
        return {
            "id": report["id"],
            "userId": report["user_id"],
            "readinessScore": report["readiness_score"],
            "skillGaps": report["skill_gaps"],
            "generatedAt": report["generated_at"]
        }
    
    # Generate new gap report if doesn't exist
    skill_gaps = [
        {
            "id": str(uuid.uuid4()),
            "skillName": "SwiftUI",
            "currentLevel": 40.0,
            "requiredLevel": 80.0,
            "priority": "High"
        },
        {
            "id": str(uuid.uuid4()),
            "skillName": "Combine Framework",
            "currentLevel": 20.0,
            "requiredLevel": 70.0,
            "priority": "High"
        }
    ]
    
    report = db.create_gap_report(
        user_id=user_id,
        readiness_score=65.5,
        skill_gaps=skill_gaps
    )
    
    return {
        "id": report["id"],
        "userId": report["user_id"],
        "readinessScore": report["readiness_score"],
        "skillGaps": report["skill_gaps"],
        "generatedAt": report["generated_at"]
    }

@app.post("/api/roadmaps/generate")
async def generate_roadmap(request: Dict[str, Any]):
    """Generate roadmap for user and save to database"""
    user_id = request.get("userId")
    
    # Check if roadmap exists
    existing_roadmap = db.get_roadmap_by_user_id(user_id)
    if existing_roadmap:
        return {
            "id": existing_roadmap["id"],
            "userId": existing_roadmap["user_id"],
            "title": existing_roadmap["title"],
            "status": existing_roadmap["status"],
            "estimatedTotalHours": existing_roadmap["estimated_total_hours"],
            "steps": existing_roadmap["steps"],
            "createdAt": existing_roadmap["created_at"]
        }
    
    # Generate new roadmap
    steps = [
        {
            "id": str(uuid.uuid4()),
            "stepOrder": 1,
            "title": "Learn Swift Basics",
            "description": "Master Swift fundamentals",
            "estHours": 20,
            "status": "Pending"
        },
        {
            "id": str(uuid.uuid4()),
            "stepOrder": 2,
            "title": "SwiftUI Fundamentals",
            "description": "Learn SwiftUI framework",
            "estHours": 30,
            "status": "Pending"
        },
        {
            "id": str(uuid.uuid4()),
            "stepOrder": 3,
            "title": "Combine Framework",
            "description": "Learn reactive programming",
            "estHours": 25,
            "status": "Pending"
        }
    ]
    
    roadmap = db.create_roadmap(
        user_id=user_id,
        title="iOS Developer Roadmap",
        status="Active",
        estimated_total_hours=120,
        steps=steps
    )
    
    return {
        "id": roadmap["id"],
        "userId": roadmap["user_id"],
        "title": roadmap["title"],
        "status": roadmap["status"],
        "estimatedTotalHours": roadmap["estimated_total_hours"],
        "steps": roadmap["steps"],
        "createdAt": roadmap["created_at"]
    }

@app.put("/api/roadmaps/{roadmap_id}/steps/{step_id}")
async def update_roadmap_step(roadmap_id: str, step_id: str, request: Dict[str, Any]):
    """Update roadmap step status"""
    status = request.get("status", "Pending")
    roadmap = db.update_roadmap_step(roadmap_id, step_id, status)
    
    if not roadmap:
        raise HTTPException(status_code=404, detail="Roadmap not found")
    
    return {
        "id": roadmap["id"],
        "userId": roadmap["user_id"],
        "title": roadmap["title"],
        "status": roadmap["status"],
        "estimatedTotalHours": roadmap["estimated_total_hours"],
        "steps": roadmap["steps"],
        "createdAt": roadmap["created_at"]
    }

if __name__ == "__main__":
    print("🚀 Starting SkillBridge Backend with SQLite Database...")
    print("📊 Database: skillbridge.db")
    print("🌐 Server: http://localhost:8000")
    print("📚 Docs: http://localhost:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000)
