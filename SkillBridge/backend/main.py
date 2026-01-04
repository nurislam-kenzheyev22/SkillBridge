"""
SkillBridge Backend API
Simple FastAPI backend for iOS app
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import uvicorn
import uuid

app = FastAPI(title="SkillBridge API", version="1.0.0")

# CORS middleware for iOS app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your iOS app's URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ========== Models ==========

class User(BaseModel):
    id: str
    email: str
    name: str
    role: str

class LoginRequest(BaseModel):
    email: str
    password: str

class RegisterRequest(BaseModel):
    email: str
    password: str
    name: str

class LoginResponse(BaseModel):
    token: str
    user: User

class Skill(BaseModel):
    id: str
    name: str
    category: str
    proficiency: Optional[str] = None

class SkillGap(BaseModel):
    id: str
    skillName: str
    currentLevel: float
    requiredLevel: float
    priority: str

class GapReport(BaseModel):
    id: str
    userId: str
    readinessScore: float
    skillGaps: List[SkillGap]
    generatedAt: str

class RoadmapStep(BaseModel):
    id: str
    stepOrder: int
    title: str
    description: str
    estHours: int
    status: str

class Roadmap(BaseModel):
    id: str
    userId: str
    title: str
    status: str
    estimatedTotalHours: int
    steps: List[RoadmapStep]
    createdAt: str

class Course(BaseModel):
    id: str
    title: str
    provider: str
    description: str
    durationWeeks: int
    price: float
    level: str
    skills: List[str]
    url: Optional[str] = None
    rating: Optional[float] = None

# ========== In-Memory Database (Simple Storage) ==========

# Mock data storage
users_db = {}
courses_db = []
gap_reports_db = {}
roadmaps_db = {}

# Initialize with sample data
def init_sample_data():
    # Sample user
    user_id = str(uuid.uuid4())
    users_db[user_id] = {
        "id": user_id,
        "email": "student@iitu.kz",
        "name": "Nurislam Kenzheyev",
        "role": "student"
    }
    
    # Sample courses
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
        },
        {
            "id": str(uuid.uuid4()),
            "title": "Advanced Swift Programming",
            "provider": "Udemy",
            "description": "Master advanced Swift concepts",
            "durationWeeks": 6,
            "price": 49.99,
            "level": "Intermediate",
            "skills": ["Swift", "iOS"],
            "url": "https://udemy.com/swift",
            "rating": 4.6
        }
    ])

init_sample_data()

# ========== Authentication ==========

def generate_token(user_id: str) -> str:
    """Simple token generation (in production, use JWT)"""
    return f"token_{user_id}_{uuid.uuid4().hex[:16]}"

# ========== API Endpoints ==========

@app.get("/")
async def root():
    return {"message": "SkillBridge API", "version": "1.0.0"}

@app.post("/api/auth/login", response_model=LoginResponse)
async def login(request: LoginRequest):
    """Login endpoint"""
    # Simple authentication (in production, verify password hash)
    user_id = None
    for uid, user in users_db.items():
        if user["email"] == request.email:
            user_id = uid
            break
    
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    user = users_db[user_id]
    token = generate_token(user_id)
    
    return LoginResponse(
        token=token,
        user=User(**user)
    )

@app.post("/api/auth/register", response_model=LoginResponse)
async def register(request: RegisterRequest):
    """Register endpoint"""
    # Check if user exists
    for user in users_db.values():
        if user["email"] == request.email:
            raise HTTPException(status_code=400, detail="User already exists")
    
    # Create new user
    user_id = str(uuid.uuid4())
    new_user = {
        "id": user_id,
        "email": request.email,
        "name": request.name,
        "role": "student"
    }
    users_db[user_id] = new_user
    
    token = generate_token(user_id)
    
    return LoginResponse(
        token=token,
        user=User(**new_user)
    )

@app.get("/api/users/me", response_model=User)
async def get_current_user():
    """Get current user (simplified - in production, verify token)"""
    # Return first user for demo
    if users_db:
        user_id = list(users_db.keys())[0]
        return User(**users_db[user_id])
    raise HTTPException(status_code=404, detail="User not found")

@app.get("/api/courses", response_model=List[Course])
async def get_courses():
    """Get all courses"""
    return [Course(**course) for course in courses_db]

@app.get("/api/gap-reports/{user_id}", response_model=GapReport)
async def get_gap_report(user_id: str):
    """Get gap report for user"""
    if user_id in gap_reports_db:
        return GapReport(**gap_reports_db[user_id])
    
    # Generate mock gap report
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
            },
            {
                "id": str(uuid.uuid4()),
                "skillName": "Combine Framework",
                "currentLevel": 20.0,
                "requiredLevel": 70.0,
                "priority": "High"
            }
        ],
        "generatedAt": datetime.now().isoformat()
    }
    gap_reports_db[user_id] = gap_report
    return GapReport(**gap_report)

@app.post("/api/roadmaps/generate", response_model=Roadmap)
async def generate_roadmap(request: RoadmapRequest):
    """Generate roadmap for user"""
    user_id = request.userId
    if user_id in roadmaps_db:
        return Roadmap(**roadmaps_db[user_id])
    
    # Generate mock roadmap
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
            },
            {
                "id": str(uuid.uuid4()),
                "stepOrder": 2,
                "title": "SwiftUI Fundamentals",
                "description": "Learn SwiftUI framework",
                "estHours": 30,
                "status": "Pending"
            }
        ],
        "createdAt": datetime.now().isoformat()
    }
    roadmaps_db[user_id] = roadmap
    return Roadmap(**roadmap)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
