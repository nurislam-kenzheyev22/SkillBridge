# 📱 Подключение iOS к реальному API

## ✅ Бэкенд работает!

Сервер запущен на: **http://localhost:8000**

## 📱 Шаг 1: Обновить APIService.swift

Найдите файл: `SkillBridge/Core/Network/APIService.swift`

Найдите строку 35:
```swift
init(networkService: NetworkServiceProtocol = NetworkService.shared, useMockData: Bool = true) {
```

Измените на:
```swift
init(networkService: NetworkServiceProtocol = NetworkService.shared, useMockData: Bool = false) {
```

## 🔧 Шаг 2: Проверить baseURL

В `Constants.swift` должно быть:
```swift
static let baseURL = "http://localhost:8000"
```

## ✅ Шаг 3: Запустить iOS приложение

1. Откройте проект в Xcode
2. Запустите на симуляторе
3. Данные будут из базы данных!

## 🧪 Проверка:

1. Откройте http://localhost:8000/docs
2. Попробуйте GET /api/courses
3. В iOS приложении откройте Course Catalog
4. Курсы должны быть из БД!

## ✅ Готово!

**iOS приложение подключено к реальному API!** 🎉
