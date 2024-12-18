# Device Info App

A Flutter application that collects and logs device information using a custom Android SDK.

## Project Overview

This application demonstrates the integration of a native Android SDK (deviceinfosdk.aar) with Flutter, enabling the collection and logging of device information such as contacts, SMS messages, and call logs.

## Features

- Native Android SDK integration
- Permission handling for sensitive data access
- Secure data logging to a remote server
- User-friendly interface
- Real-time feedback on data collection status

## Prerequisites

Before you begin, ensure you have the following installed:
- Flutter (latest stable version)
- Android Studio
- Java Development Kit (JDK) 17 or later
- Android SDK

## Project Structure

```
device_info_app/
├── android/
│   ├── app/
│   │   ├── libs/
│   │   │   └── deviceinfosdk.aar
│   │   ├── src/
│   │   └── build.gradle
├── lib/
│   ├── main.dart
│   └── device_info_bridge.dart
└── pubspec.yaml
```

## Setup and Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd device_info_app
```

2. Place the deviceinfosdk.aar file in the android/app/libs directory

3. Install dependencies:
```bash
flutter pub get
```

4. Update the server URL in `lib/main.dart`:
```dart
await DeviceInfoBridge.initializeSDK('YOUR_SERVER_URL');
```

## Required Permissions

The app requires the following Android permissions:
- READ_CONTACTS
- READ_CALL_LOG
- READ_SMS
- INTERNET

These permissions are requested at runtime using the permission_handler package.

## Building the App

Debug build:
```bash
flutter build apk --debug
```

Release build:
```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/`

## Usage

1. Launch the app
2. Grant the requested permissions
3. Tap "Log Device Data" to collect and send data
4. Check the server logs to verify data transmission

## Technical Details

### Native SDK Integration

The app uses Platform Channels to communicate between Flutter and the native Android SDK:
```kotlin
private val CHANNEL = "com.example.deviceinfosdk/device_info"
```

### Permission Handling

Permissions are managed using the permission_handler package:
```dart
Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.sms,
      Permission.phone,
    ].request();
}
```

### Data Logging

Data is logged to the server using OkHttp in the native SDK:
```kotlin
DataLogger.logData(jsonData)
```

## Troubleshooting

Common issues and solutions:

1. Permission Denied
    - Ensure all required permissions are granted in app settings
    - Check AndroidManifest.xml for proper permission declarations

2. Build Failures
    - Verify JDK version (17+ required)
    - Check AAR file placement in libs directory
    - Ensure all dependencies are properly declared

3. Data Not Logging
    - Verify server URL is correct
    - Check network connectivity
    - Verify server endpoint is accessible

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
TBD

## Contact
TBD