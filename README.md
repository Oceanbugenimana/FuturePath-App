# FuturePath AI — Flutter

AI-powered career path simulator built with Flutter/Dart.  
Converted from the original Kotlin/Jetpack Compose Android app.

## Features

- 🚀 **Career Simulator** — 3 AI-generated career paths (Optimistic, Realistic, High-Risk)
- 📈 **Salary Trajectory** — 5-year income projection chart
- 🗺️ **Learning Roadmap** — Personalised 6-month action plan
- 🧠 **Skill Gap Analysis** — What you need to learn
- 🤖 **AI Mentor (Alpha-9)** — Chat with a Gemini-powered career advisor
- 🔭 **Future Scenarios** — Visualise where you'll be in 1, 2, 3, 5 years
- 💎 **Premium** — Unlock advanced features
- 🏗️ **Blueprint** — System architecture overview

## Setup

### 1. Install Flutter
https://docs.flutter.dev/get-started/install

### 2. Clone & install dependencies
```bash
flutter pub get
```

### 3. Add your Gemini API key
The app works offline with a procedural fallback engine.  
To enable live AI responses, pass your key at build time:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

Get a free key at: https://aistudio.google.com/app/apikey

### 4. Run
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── data/
│   ├── models.dart              # UserProfile, ChatMessage, CareerSimulation
│   ├── database.dart            # SQLite via sqflite
│   ├── gemini_client.dart       # Gemini REST API client
│   └── repository.dart          # Business logic + AI fallback engine
├── viewmodel/
│   └── futurepath_viewmodel.dart # State management (ChangeNotifier)
└── ui/
    ├── app_shell.dart           # Top/bottom nav + screen router
    ├── theme/
    │   └── app_theme.dart       # Cyber dark theme + colour palette
    ├── widgets/
    │   └── common_widgets.dart  # Shared UI components
    └── screens/
        ├── splash_screen.dart
        ├── onboarding_screen.dart
        ├── auth_screen.dart
        ├── assessment_screen.dart
        ├── dashboard_screen.dart
        ├── career_simulator_screen.dart
        ├── salary_trajectory_screen.dart
        ├── learning_roadmap_screen.dart
        ├── skill_gap_screen.dart
        ├── ai_mentor_screen.dart
        ├── future_scenario_screen.dart
        ├── premium_screen.dart
        └── architect_screen.dart
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | Flutter 3.x |
| State | Provider 6.x |
| Database | sqflite 2.x |
| AI | Google Gemini 1.5 Flash |
| Charts | fl_chart 0.68 |
| HTTP | http 1.2 |
