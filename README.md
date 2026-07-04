# POS Mobile Demo

This Flutter app is a mobile demo client for the Web POS project. It shows how the existing restaurant POS workflow can also work on a mobile screen.

## What It Is

The mobile app is a companion demo for the main Web POS system. It reuses the same backend API and presents a smaller mobile-focused interface for common restaurant workflows.

## How It Works

1. A staff member signs in from the mobile app.
2. The app keeps the authenticated session with the backend.
3. The app loads tables, menus, items, orders, and dashboard data from the API.
4. Staff can create orders and update order status from the mobile interface.
5. The backend remains the single source of truth for both web and mobile clients.

## Tech Stack

- Flutter
- Dart
- HTTP API client
- Android Emulator support

## Main Features

- Employee login and registration
- Table overview
- Order list and order status actions
- Menu browsing and cart flow
- Dashboard summary

## Run

Start the backend first, then run the mobile app:

```powershell
flutter pub get
flutter run
```

## Note

This repository is a demo mobile version of the Web POS project, not a replacement for the main web application. Sensitive configuration and deployment values should be managed locally, not documented or committed to Git.
