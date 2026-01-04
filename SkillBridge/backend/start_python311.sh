#!/bin/bash

# Start SkillBridge Backend Server with Python 3.11

echo "🚀 Starting SkillBridge Backend with Python 3.11..."
echo ""

# Check if Python 3.11 is available
if ! command -v python3.11 &> /dev/null; then
    echo "❌ Python 3.11 not found!"
    echo "📥 Install Python 3.11:"
    echo "   brew install python@3.11"
    echo ""
    echo "Or use Python 3.12:"
    echo "   brew install python@3.12"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv311" ]; then
    echo "📦 Creating virtual environment with Python 3.11..."
    python3.11 -m venv venv311
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv311/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip --quiet

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Start server
echo ""
echo "✅ Starting server on http://localhost:8000"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""
python main.py
