# SkillBridge Backend

FastAPI backend сервер с SQLite базой данных для SkillBridge iOS приложения.

## 🚀 Быстрый старт

### Требования

- **Python** 3.11 или 3.12 (рекомендуется)
- **pip** (менеджер пакетов Python)

### Установка и запуск

1. Перейдите в папку backend:
```bash
cd backend
```

2. Запустите скрипт установки:
```bash
./start_with_db.sh
```

Скрипт автоматически:
- Создаст виртуальное окружение
- Установит все зависимости
- Создаст базу данных SQLite
- Запустит сервер

3. Сервер запустится на: **http://127.0.0.1:8000**

4. Документация API: **http://127.0.0.1:8000/docs**

## 📊 База данных

### Автоматическое создание

База данных `skillbridge.db` создается автоматически при первом запуске.

### Структура таблиц

#### users
- `id` (TEXT PRIMARY KEY) - UUID пользователя
- `email` (TEXT UNIQUE) - Email
- `name` (TEXT) - Имя
- `role` (TEXT) - Роль (student, counselor, admin)
- `password_hash` (TEXT) - Хеш пароля
- `created_at` (TEXT) - Дата создания

#### courses
- `id` (TEXT PRIMARY KEY) - UUID курса
- `title` (TEXT) - Название
- `provider` (TEXT) - Провайдер
- `description` (TEXT) - Описание
- `duration_weeks` (INTEGER) - Длительность в неделях
- `price` (REAL) - Цена
- `level` (TEXT) - Уровень (Beginner, Intermediate, Advanced)
- `skills` (TEXT) - JSON массив навыков
- `url` (TEXT) - Ссылка на курс
- `rating` (REAL) - Рейтинг
- `created_at` (TEXT) - Дата создания

#### gap_reports
- `id` (TEXT PRIMARY KEY) - UUID отчета
- `user_id` (TEXT) - UUID пользователя (FK)
- `readiness_score` (REAL) - Оценка готовности
- `skill_gaps` (TEXT) - JSON массив пробелов
- `generated_at` (TEXT) - Дата генерации

#### roadmaps
- `id` (TEXT PRIMARY KEY) - UUID дорожной карты
- `user_id` (TEXT) - UUID пользователя (FK)
- `title` (TEXT) - Название
- `status` (TEXT) - Статус (Draft, Active, Paused, Completed)
- `estimated_total_hours` (INTEGER) - Оценка часов
- `steps` (TEXT) - JSON массив шагов
- `created_at` (TEXT) - Дата создания

## 🔌 API Endpoints

### Корневой эндпоинт
- `GET /` - Информация о API

### Аутентификация
- `POST /api/auth/login` - Вход в систему
  - Body: `{ "email": "string", "password": "string" }`
  - Returns: `{ "token": "string", "user": {...} }`

- `POST /api/auth/register` - Регистрация
  - Body: `{ "email": "string", "password": "string", "name": "string" }`
  - Returns: `{ "token": "string", "user": {...} }`

### Пользователи
- `GET /api/users/me` - Получить текущего пользователя
  - Returns: `{ "id": "string", "email": "string", "name": "string", "role": "string" }`

### Курсы
- `GET /api/courses` - Получить все курсы
  - Returns: `[{ "id": "string", "title": "string", ... }]`

- `POST /api/courses` - Создать курс
  - Body: `{ "title": "string", "provider": "string", ... }`
  - Returns: `{ "id": "string", "title": "string", ... }`

### Отчеты о пробелах
- `GET /api/gap-reports/{user_id}` - Получить отчет о пробелах
  - Returns: `{ "id": "string", "userId": "string", "readinessScore": float, "skillGaps": [...], "generatedAt": "string" }`

### Дорожные карты
- `POST /api/roadmaps/generate` - Сгенерировать дорожную карту
  - Body: `{ "userId": "string" }`
  - Returns: `{ "id": "string", "userId": "string", "title": "string", "status": "string", "estimatedTotalHours": int, "steps": [...], "createdAt": "string" }`

- `PUT /api/roadmaps/{roadmap_id}/steps/{step_id}` - Обновить шаг
  - Body: `{ "status": "string" }`
  - Returns: Обновленная дорожная карта

## 🗄️ Работа с базой данных

### Просмотр данных

```bash
sqlite3 skillbridge.db

# Просмотр таблиц
.tables

# Просмотр пользователей
SELECT * FROM users;

# Просмотр курсов
SELECT * FROM courses;

# Просмотр отчетов
SELECT * FROM gap_reports;

# Выход
.quit
```

### Резервное копирование

```bash
sqlite3 skillbridge.db .dump > backup.sql
```

### Восстановление

```bash
sqlite3 skillbridge.db < backup.sql
```

## 🔧 Разработка

### Зависимости

Все зависимости указаны в `requirements_simple.txt`:
- `fastapi==0.115.0` - Web framework
- `uvicorn[standard]==0.32.0` - ASGI server

### Структура кода

- `main_with_db.py` - Основное FastAPI приложение
- `database.py` - Модуль работы с SQLite
- `start_with_db.sh` - Скрипт запуска

### Добавление новых эндпоинтов

1. Откройте `main_with_db.py`
2. Добавьте новый эндпоинт:
```python
@app.get("/api/new-endpoint")
async def new_endpoint():
    return {"message": "Hello"}
```
3. Перезапустите сервер

## 🐛 Решение проблем

### Проблема: Порт 8000 занят

```bash
lsof -ti:8000 | xargs kill -9
```

### Проблема: Ошибка установки зависимостей

Используйте Python 3.11 или 3.12:
```bash
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements_simple.txt
```

### Проблема: База данных не создается

Убедитесь, что у вас есть права на запись в папку `backend/`.

## 📝 Примечания

- База данных создается автоматически при первом запуске
- Инициализируются примерные данные (пользователь и курсы)
- Все данные хранятся в SQLite файле `skillbridge.db`
- CORS настроен для работы с iOS симулятором

---

**Версия:** 1.0.0  
**Дата:** 2025
