# 🗄️ База данных SQLite

## Структура базы данных:

### Таблицы:

1. **users**
   - id (TEXT PRIMARY KEY)
   - email (TEXT UNIQUE)
   - name (TEXT)
   - role (TEXT)
   - password_hash (TEXT)
   - created_at (TEXT)

2. **courses**
   - id (TEXT PRIMARY KEY)
   - title (TEXT)
   - provider (TEXT)
   - description (TEXT)
   - duration_weeks (INTEGER)
   - price (REAL)
   - level (TEXT)
   - skills (TEXT - JSON array)
   - url (TEXT)
   - rating (REAL)
   - created_at (TEXT)

3. **gap_reports**
   - id (TEXT PRIMARY KEY)
   - user_id (TEXT - FK to users)
   - readiness_score (REAL)
   - skill_gaps (TEXT - JSON array)
   - generated_at (TEXT)

4. **roadmaps**
   - id (TEXT PRIMARY KEY)
   - user_id (TEXT - FK to users)
   - title (TEXT)
   - status (TEXT)
   - estimated_total_hours (INTEGER)
   - steps (TEXT - JSON array)
   - created_at (TEXT)

## Использование:

База данных создается автоматически при первом запуске.
Файл: `skillbridge.db` в папке `backend/`

## Просмотр данных:

```bash
sqlite3 backend/skillbridge.db

# Просмотр таблиц
.tables

# Просмотр пользователей
SELECT * FROM users;

# Просмотр курсов
SELECT * FROM courses;

# Выход
.quit
```

## Резервное копирование:

```bash
sqlite3 skillbridge.db .dump > backup.sql
```

## Восстановление:

```bash
sqlite3 skillbridge.db < backup.sql
```
