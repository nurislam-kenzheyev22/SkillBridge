#!/bin/bash

echo "🚀 Starting SkillBridge Backend (Simple Version)..."
echo ""

if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

echo "🔧 Activating virtual environment..."
source venv/bin/activate

echo "⬆️  Upgrading pip..."
pip install --upgrade pip --quiet

echo "📥 Installing dependencies (simple version)..."
pip install -r requirements_simple.txt

echo ""
echo "✅ Starting server on http://localhost:8000"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""
python main_simple.py
