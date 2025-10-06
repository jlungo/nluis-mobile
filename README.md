# NLUIS - National Land Use Information System

A modern, offline-first Flutter mobile application for field data collection, built for Android and iOS.

## Features

### Implemented ✅
- **Authentication**: Secure login with token-based authentication
- **Module System**: Support for multiple modules (Land Use, CCRO, M&E, Compliance)
- **Offline-First Architecture**: Works without internet connection
- **Land Use Dashboard**: View assigned projects with pull-to-refresh
- **Project Management**: Browse and manage land use projects
- **Modern UI**: Material Design 3 with Kiswahili localization
- **Secure Storage**: Token and sensitive data encryption

### Architecture
- **State Management**: Riverpod 2.x
- **Navigation**: go_router with declarative routing
- **Database**: Drift (SQLite) for offline storage
- **Network**: Dio with interceptors for auth and token refresh
- **Theme**: Light/Dark mode support
- **Localization**: Kiswahili (sw) as default, English (en) support

## Getting Started

### Prerequisites
- Flutter SDK 3.1.0 or higher
- Android SDK (for Android development)
- Xcode (for iOS development on macOS)

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run code generation** (for Drift database)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### API Base URL
Update the base URL in [lib/core/env/env.dart](lib/core/env/env.dart):
```dart
static const String baseUrl = 'http://144.91.125.106:8000/api/v1';
```

## Project Structure

```
lib/
├── app/                    # App initialization & routing
├── core/                   # Core functionality (network, errors, utils)
├── data/                   # Data layer (repositories, database)
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── land_use/          # Land Use module
│   └── settings/          # Settings
└── shared/                # Shared code (models, theme, widgets)
```

## API Integration

### Authentication
```
POST /auth/login/
POST /auth/refresh/
```

### Projects
```
GET /projects/assigned/
GET /projects/{id}/
```

## Development

### Code Generation
Run after modifying Drift tables or Riverpod providers:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
flutter test
flutter analyze
```

## Troubleshooting

### Build Errors
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

**Version**: 1.0.0
**Documentation**: See [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) for detailed progress
