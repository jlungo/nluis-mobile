# NLUIS Collect - Setup Guide

## Prerequisites

- Flutter SDK
- Android Studio
- Emulator

## Installation Steps

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Database Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App

```bash
flutter run
```

## Testing Authentication

**Requirements:**

- User must have `user_type = 5` (mobile user)
- User must have assigned modules

## API Configuration

The app connects to:

```
Base URL: http://144.91.125.106:8000/api/v1
```

To change the base URL:

- Edit `lib/core/env/env.dart`
- Or set environment variable: `BASE_URL`

## Troubleshooting

### Build Runner Errors

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Database Issues

Delete app data and reinstall:

```bash
flutter clean
flutter run
```

## Development

### Adding New Features

Follow Clean Architecture + BLoC pattern:

1. Create domain entities
2. Define repository interface
3. Implement data models & datasources
4. Implement repository
5. Create BLoC (events, states, bloc)
6. Build UI
