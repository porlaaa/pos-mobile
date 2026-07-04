# POS Mobile Demo

This Flutter app is a mobile demo client for the Web POS project. It is built to show how the existing restaurant POS workflow can also work on a mobile screen.

## Purpose

- Demo companion app for the Web POS system
- Connects to the same Node/Express backend API used by the web app
- Includes employee login, tables, orders, menu ordering, and dashboard screens
- Intended for portfolio and job application presentation

## Tech Stack

- Flutter
- Dart
- HTTP API client
- Android Emulator support

## Default API

The app uses this default API URL for Android Emulator:

```text
http://10.0.2.2:5000
```

You can override it when running the app:

```powershell
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

## Run

Start the backend first, then run the mobile app:

```powershell
cd D:\PROJECT\pos-mobile
flutter pub get
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

## Note

This repository is a demo mobile version of the Web POS project, not a replacement for the main web application.
