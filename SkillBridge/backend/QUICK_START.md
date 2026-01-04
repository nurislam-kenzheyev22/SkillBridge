# 🚀 Быстрый старт

## Проблема с Python 3.14?

Используйте Python 3.11 или 3.12:

### Вариант 1: Установить Python 3.11
```bash
brew install python@3.11
cd backend
python3.11 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
python main.py
```

### Вариант 2: Использовать системный Python 3.11/3.12
```bash
cd backend
rm -rf venv
python3.11 -m venv venv  # или python3.12
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
python main.py
```

### Вариант 3: Упрощенный вариант (без pydantic)
Если проблемы продолжаются, можно использовать упрощенную версию без pydantic.

## После успешной установки:

```bash
python main.py
```

Сервер: http://localhost:8000
Документация: http://localhost:8000/docs
