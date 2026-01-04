#!/bin/bash
# Verification script - проверка соответствия MockData моделям

echo "=== Checking Model Structures ==="
echo ""

echo "1. User Model:"
grep -A 10 "init(" Core/Models/User.swift | head -12
echo ""

echo "2. Course Model:"
grep -A 15 "init(" Core/Models/Course.swift | head -18
echo ""

echo "3. Curriculum Model:"
grep -A 10 "init(" Core/Models/Curriculum.swift | head -12
echo ""

echo "=== Checking MockData Usage ==="
echo ""

echo "User creation:"
grep -A 5 "mockUser = User" Core/Mocks/MockData.swift
echo ""

echo "Course creation:"
grep -A 12 "Course(" Core/Mocks/MockData.swift | head -15
echo ""

echo "✅ Verification complete"
