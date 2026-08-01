<div align="center">

# 🏋️ GymBro

**A clean, dark-themed iOS fitness companion for building and tracking your workouts.**

![Swift](https://img.shields.io/badge/Swift-5.9-F05138?style=flat&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-16%2B-000000?style=flat&logo=apple&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=flat&logo=swift&logoColor=white)
![CoreData](https://img.shields.io/badge/CoreData-persistence-gray?style=flat)
![Status](https://img.shields.io/badge/status-in%20development-orange?style=flat)

</div>

---

## Overview

GymBro is a native iOS app built entirely in SwiftUI that helps you plan, run, and review your gym sessions. It ships with a set of professional workout templates and lets you build your own from a library of 120+ exercises — all without an account or internet connection.

---

## Features

### 🏠 Home
- **Build Session** — pick a workout template to start immediately
  - Filter bar: *Recent* · *My Templates* · *Built-In*
  - Built-in programmes (Chest & Triceps, Back & Biceps, Legs & Glutes, Shoulders & Core, Full Body)
  - Create custom templates with the **+** button
  - Recently completed sessions auto-appear in *Recent*
- **Today's Workout** — see and launch your selected session
- **Training Calendar** — weekly overview of completed sessions

### ➕ Custom Template Builder
- Name, duration, and exercise configuration
- Browse 120+ exercises filtered by **muscle category**:
  *All · Chest · Shoulders · Arms · Back · Core · Legs · Glutes*
- Per-exercise set count editor
- Saves to CoreData — survives app restarts
- Long-press any custom card to delete

### 🍒 Nutrition Tracker
- Daily macro tracking (calories, protein, carbs, fat)
- Meal logging with progress ring

### 📊 Statistics
- Full workout history with session details
- Per-exercise progress over time

### ⚙️ Settings
- Account & profile management
- Goals configuration
- Weight unit toggle (kg / lbs)

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| State management | `@StateObject` / `@ObservedObject` / `@EnvironmentObject` |
| Persistence | CoreData |
| Concurrency | Swift async / await |
| Architecture | MVVM + Repository pattern |
| Data | Local JSON (exercise catalogue) |

---

## Architecture

```
GymBro/
├── Core/
│   ├── CoreData/          # NSManagedObject subclasses
│   └── Mapping/           # Entity ↔ Model mappers
├── Data/
│   ├── Exercises.json     # 120+ exercise catalogue
│   └── MuscleGroup.swift  # MuscleGroup + MuscleCategory enums
├── Models/
│   ├── Domain/            # ExerciseDefinition, UserProfile …
│   ├── TrainingSessionModels/
│   └── WorkoutTemplateModels/
├── Protocols/             # Repository & provider abstractions
├── Services/
│   └── CoreData/          # Concrete repository implementations
├── ViewModels/            # ObservableObject classes per feature
└── VIews/
    ├── MainView/          # Home, BuildSession, CreateTemplate, ExercisePicker
    ├── TodaySession/      # Active workout tracking
    ├── FoodTracker/       # Nutrition
    ├── Statistics/        # History & charts
    └── Settings/          # Preferences
```

---

## Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/StanniZ/GymBro.git
   cd GymBro
   ```

2. **Open in Xcode**
   ```bash
   open GymBro.xcodeproj
   ```

3. **Run** — select a simulator (iPhone 15 or later recommended) and press **⌘R**.

> No API keys, no backend, no SPM packages required. Everything runs locally.

---

## Requirements

- Xcode 15+
- iOS 16+
- Swift 5.9+

---

## Roadmap

- [ ] Apple Health integration
- [ ] Rest timer between sets
- [ ] iCloud sync for templates
- [ ] Workout streaks & achievements
- [ ] App Store release

---

<div align="center">

Built with SwiftUI · Dark side only 🖤

</div>
