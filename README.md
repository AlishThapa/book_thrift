# KitabSathi

**KitabSathi** is a modern, student-focused thrift book marketplace designed to make buying and selling used books easy, affordable, and local. Built with Flutter, it provides a seamless experience for students to find required textbooks, novels, and educational resources near them.

---

## 🚀 Key Features

- **Personalized Dashboard**: Dynamic home screen featuring "New Listings Near You," "Picks for You," and "Trending" books based on user location and preferences.
- **Location-Based Discovery**: Integrated geolocation services to find sellers within your immediate vicinity.
- **Secure Authentication**: Robust user sign-up and login flow.
- **Smart Search**: Comprehensive search functionality with history tracking and filters to find the exact book you need.
- **Messaging System**: Real-time chat interface for buyers and sellers to negotiate and coordinate pickups.
- **Listing Management**: Easy-to-use "Sell" flow for uploading book details, images, and setting prices.
- **Wishlist & Cart**: Save books for later or manage your current selections for purchase.
- **Modern UI/UX**: Follows a "Clean & Alive" design philosophy with dark mode support, soft shadows, and fluid animations.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Flutter Bloc](https://pub.dev/packages/flutter_bloc) (Strictly Bloc/Cubit)
- **Navigation**: [AutoRoute](https://pub.dev/packages/auto_route)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it)
- **Local Database**: [Hive](https://pub.dev/packages/hive) (For caching, preferences, and offline data)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Location Services**: [Geolocator](https://pub.dev/packages/geolocator)
- **Utilities**: [Equatable](https://pub.dev/packages/equatable), [Logger](https://pub.dev/packages/logger), [Intl](https://pub.dev/packages/intl)

---

## 🏗️ Project Architecture

The project follows a strict modularized feature-first architecture. Each feature is isolated into its own directory under `lib/features/` with the following structure:

```text
lib/features/feature_name/
├── bloc/          # Business logic (Events & States)
├── models/        # Data models & JSON serialization
├── repo/          # API & Data fetching logic
├── widgets/       # Feature-specific UI components
└── feature_name_page.dart  # Main entry point for the feature
```

For detailed coding standards, please refer to [AGENTS.md](./AGENTS.md).

---

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/kitabsathi.git
   cd kitabsathi
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate boilerplate code**:
   (Since we use `auto_route` and `hive`, you must run build_runner)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 🎨 Development Guidelines

- **No `setState`**: Use Blocs or Cubits for state management as per project standards.
- **Theme Awareness**: Use `Theme.of(context).colorScheme` instead of hardcoded colors.
- **Design Tokens**: Adhere to `AppSpacing`, `AppRadius`, and `AppTextStyles` defined in the project.
- **Lifecycle Management**: Always dispose of controllers (Animation, Text, Scroll) to prevent memory leaks.

---

## 📄 License

This project is licensed under the MIT License.

---

*Made with ❤️ for students, by students.*
