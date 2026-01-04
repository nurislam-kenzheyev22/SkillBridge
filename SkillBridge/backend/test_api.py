"""
Quick test script for API
"""
import requests
import json

BASE_URL = "http://localhost:8000"

def test_api():
    print("🧪 Testing SkillBridge API...\n")
    
    # Test root
    print("1. Testing root endpoint...")
    response = requests.get(f"{BASE_URL}/")
    print(f"   Status: {response.status_code}")
    print(f"   Response: {response.json()}\n")
    
    # Test get courses
    print("2. Testing get courses...")
    response = requests.get(f"{BASE_URL}/api/courses")
    print(f"   Status: {response.status_code}")
    courses = response.json()
    print(f"   Courses count: {len(courses)}")
    if courses:
        print(f"   First course: {courses[0]['title']}\n")
    
    # Test get user
    print("3. Testing get current user...")
    response = requests.get(f"{BASE_URL}/api/users/me")
    print(f"   Status: {response.status_code}")
    if response.status_code == 200:
        user = response.json()
        print(f"   User: {user['name']} ({user['email']})\n")
    
    print("✅ API tests completed!")

if __name__ == "__main__":
    try:
        test_api()
    except requests.exceptions.ConnectionError:
        print("❌ Error: Cannot connect to server")
        print("   Make sure server is running: ./start_with_db.sh")
    except Exception as e:
        print(f"❌ Error: {e}")
