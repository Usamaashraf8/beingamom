# BeingA Mom - Flutter Mobile App Setup

## Prerequisites

### 1. Install Flutter SDK
Follow the official Flutter installation guide: https://flutter.dev/docs/get-started/install

For macOS:
```bash
cd ~/Desktop
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:~/Desktop/flutter/bin"
flutter --version
```

### 2. Configure IDE
- **VS Code**: Install the Flutter extension
- **Android Studio**: Install Flutter plugin
- **Xcode** (for iOS): Run `sudo xcode-select --switch /Applications/Xcode.app`

### 3. Create the Flutter Project
```bash
cd /Users/ashraf/Desktop/beingamom
flutter create being_a_mom --org com.beingamom
```

### 4. Add Dependencies
Edit `being_a_mom/pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.3.0
  provider: ^6.0.5
  flutter_secure_storage: ^9.0.0
  image_picker: ^1.0.4
  cached_network_image: ^3.3.0
  intl: ^0.18.1
  google_fonts: ^6.1.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### 5. Run the App
```bash
cd being_a_mom
flutter pub get
flutter run
```

## Project Structure
```
lib/
├── main.dart
├── models/
│   ├── user.dart
│   ├── child.dart
│   └── message.dart
├── services/
│   ├── api_service.dart
│   ├── openai_service.dart
│   └── storage_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── chat_screen.dart
│   ├── child_profile_screen.dart
│   └── image_analysis_screen.dart
├── widgets/
│   ├── chat_bubble.dart
│   ├── quick_actions.dart
│   └── age_badge.dart
└── theme/
    └── app_theme.dart
```

## API Configuration
Update the API base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_SERVER_IP:8000';
```

## OpenAI API Key
Set your OpenAI API key in the Django backend (`chat/api.py`):
```python
openai.api_key = "YOUR_OPENAI_API_KEY"
```

## Next Steps
1. Install Flutter SDK
2. Create the project using the commands above
3. Copy the project structure files
4. Run and test the app