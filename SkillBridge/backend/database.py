"""
Database setup and models for SkillBridge
"""

import sqlite3
import json
from datetime import datetime
from typing import List, Dict, Any, Optional
import uuid

class Database:
    def __init__(self, db_path: str = "skillbridge.db"):
        self.db_path = db_path
        self.init_database()
    
    def get_connection(self):
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row  # Return rows as dictionaries
        return conn
    
    def init_database(self):
        """Initialize database tables"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        # Users table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id TEXT PRIMARY KEY,
                email TEXT UNIQUE NOT NULL,
                name TEXT NOT NULL,
                role TEXT NOT NULL,
                password_hash TEXT,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Courses table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS courses (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                provider TEXT NOT NULL,
                description TEXT,
                duration_weeks INTEGER,
                price REAL,
                level TEXT,
                skills TEXT,  -- JSON array
                url TEXT,
                rating REAL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Gap Reports table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS gap_reports (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                readiness_score REAL,
                skill_gaps TEXT,  -- JSON array
                generated_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        ''')
        
        # Roadmaps table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS roadmaps (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                title TEXT NOT NULL,
                status TEXT,
                estimated_total_hours INTEGER,
                steps TEXT,  -- JSON array
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        ''')
        
        conn.commit()
        conn.close()
        
        # Initialize sample data
        self.init_sample_data()
    
    def init_sample_data(self):
        """Initialize sample data if tables are empty"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        # Check if users exist
        cursor.execute("SELECT COUNT(*) FROM users")
        if cursor.fetchone()[0] == 0:
            # Add sample user
            user_id = str(uuid.uuid4())
            cursor.execute('''
                INSERT INTO users (id, email, name, role)
                VALUES (?, ?, ?, ?)
            ''', (user_id, "student@iitu.kz", "Nurislam Kenzheyev", "student"))
            
            # Add sample courses
            courses = [
                {
                    "id": str(uuid.uuid4()),
                    "title": "iOS Development with SwiftUI",
                    "provider": "Apple",
                    "description": "Learn iOS development using SwiftUI framework",
                    "duration_weeks": 8,
                    "price": 0.0,
                    "level": "Beginner",
                    "skills": json.dumps(["Swift", "SwiftUI", "iOS"]),
                    "url": "https://developer.apple.com/swiftui",
                    "rating": 4.8
                },
                {
                    "id": str(uuid.uuid4()),
                    "title": "Advanced Swift Programming",
                    "provider": "Udemy",
                    "description": "Master advanced Swift concepts",
                    "duration_weeks": 6,
                    "price": 49.99,
                    "level": "Intermediate",
                    "skills": json.dumps(["Swift", "iOS"]),
                    "url": "https://udemy.com/swift",
                    "rating": 4.6
                },
                {
                    "id": str(uuid.uuid4()),
                    "title": "SwiftUI Masterclass",
                    "provider": "Coursera",
                    "description": "Complete SwiftUI course",
                    "duration_weeks": 10,
                    "price": 79.99,
                    "level": "Advanced",
                    "skills": json.dumps(["SwiftUI", "iOS", "Combine"]),
                    "url": "https://coursera.org/swiftui",
                    "rating": 4.9
                }
            ]
            
            for course in courses:
                cursor.execute('''
                    INSERT INTO courses (id, title, provider, description, duration_weeks, price, level, skills, url, rating)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    course["id"],
                    course["title"],
                    course["provider"],
                    course["description"],
                    course["duration_weeks"],
                    course["price"],
                    course["level"],
                    course["skills"],
                    course["url"],
                    course["rating"]
                ))
        
        conn.commit()
        conn.close()
    
    # User methods
    def create_user(self, email: str, name: str, role: str = "student") -> Dict[str, Any]:
        """Create a new user"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        user_id = str(uuid.uuid4())
        cursor.execute('''
            INSERT INTO users (id, email, name, role)
            VALUES (?, ?, ?, ?)
        ''', (user_id, email, name, role))
        
        conn.commit()
        user = self.get_user_by_id(user_id)
        conn.close()
        return user
    
    def get_user_by_id(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get user by ID"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            return dict(row)
        return None
    
    def get_user_by_email(self, email: str) -> Optional[Dict[str, Any]]:
        """Get user by email"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE email = ?", (email,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            return dict(row)
        return None
    
    def get_all_users(self) -> List[Dict[str, Any]]:
        """Get all users"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]
    
    # Course methods
    def get_all_courses(self) -> List[Dict[str, Any]]:
        """Get all courses"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM courses")
        rows = cursor.fetchall()
        conn.close()
        
        courses = []
        for row in rows:
            course = dict(row)
            # Parse skills JSON
            if course["skills"]:
                course["skills"] = json.loads(course["skills"])
            else:
                course["skills"] = []
            courses.append(course)
        return courses
    
    def create_course(self, course_data: Dict[str, Any]) -> Dict[str, Any]:
        """Create a new course"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        course_id = str(uuid.uuid4())
        skills_json = json.dumps(course_data.get("skills", []))
        
        cursor.execute('''
            INSERT INTO courses (id, title, provider, description, duration_weeks, price, level, skills, url, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            course_id,
            course_data["title"],
            course_data["provider"],
            course_data.get("description", ""),
            course_data.get("duration_weeks", 0),
            course_data.get("price", 0.0),
            course_data.get("level", "Beginner"),
            skills_json,
            course_data.get("url"),
            course_data.get("rating")
        ))
        
        conn.commit()
        course = self.get_course_by_id(course_id)
        conn.close()
        return course
    
    def get_course_by_id(self, course_id: str) -> Optional[Dict[str, Any]]:
        """Get course by ID"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM courses WHERE id = ?", (course_id,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            course = dict(row)
            if course["skills"]:
                course["skills"] = json.loads(course["skills"])
            else:
                course["skills"] = []
            return course
        return None
    
    # Gap Report methods
    def create_gap_report(self, user_id: str, readiness_score: float, skill_gaps: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Create a gap report"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        report_id = str(uuid.uuid4())
        skill_gaps_json = json.dumps(skill_gaps)
        
        cursor.execute('''
            INSERT INTO gap_reports (id, user_id, readiness_score, skill_gaps)
            VALUES (?, ?, ?, ?)
        ''', (report_id, user_id, readiness_score, skill_gaps_json))
        
        conn.commit()
        report = self.get_gap_report_by_user_id(user_id)
        conn.close()
        return report
    
    def get_gap_report_by_user_id(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get gap report by user ID"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM gap_reports WHERE user_id = ? ORDER BY generated_at DESC LIMIT 1", (user_id,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            report = dict(row)
            if report["skill_gaps"]:
                report["skill_gaps"] = json.loads(report["skill_gaps"])
            else:
                report["skill_gaps"] = []
            return report
        return None
    
    # Roadmap methods
    def create_roadmap(self, user_id: str, title: str, status: str, estimated_total_hours: int, steps: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Create a roadmap"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        roadmap_id = str(uuid.uuid4())
        steps_json = json.dumps(steps)
        
        cursor.execute('''
            INSERT INTO roadmaps (id, user_id, title, status, estimated_total_hours, steps)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (roadmap_id, user_id, title, status, estimated_total_hours, steps_json))
        
        conn.commit()
        roadmap = self.get_roadmap_by_user_id(user_id)
        conn.close()
        return roadmap
    
    def get_roadmap_by_user_id(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get roadmap by user ID"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM roadmaps WHERE user_id = ? ORDER BY created_at DESC LIMIT 1", (user_id,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            roadmap = dict(row)
            if roadmap["steps"]:
                roadmap["steps"] = json.loads(roadmap["steps"])
            else:
                roadmap["steps"] = []
            return roadmap
        return None
    
    def update_roadmap_step(self, roadmap_id: str, step_id: str, status: str):
        """Update roadmap step status"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        # Get roadmap
        cursor.execute("SELECT * FROM roadmaps WHERE id = ?", (roadmap_id,))
        row = cursor.fetchone()
        if not row:
            conn.close()
            return None
        
        roadmap = dict(row)
        steps = json.loads(roadmap["steps"]) if roadmap["steps"] else []
        
        # Update step
        for step in steps:
            if step["id"] == step_id:
                step["status"] = status
                break
        
        # Save updated steps
        steps_json = json.dumps(steps)
        cursor.execute('''
            UPDATE roadmaps SET steps = ? WHERE id = ?
        ''', (steps_json, roadmap_id))
        
        conn.commit()
        conn.close()
        return self.get_roadmap_by_id(roadmap_id)
    
    def get_roadmap_by_id(self, roadmap_id: str) -> Optional[Dict[str, Any]]:
        """Get roadmap by ID"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM roadmaps WHERE id = ?", (roadmap_id,))
        row = cursor.fetchone()
        conn.close()
        
        if row:
            roadmap = dict(row)
            if roadmap["steps"]:
                roadmap["steps"] = json.loads(roadmap["steps"])
            else:
                roadmap["steps"] = []
            return roadmap
        return None

# Global database instance
db = Database()
