# Thaheen LMS – Complete Technical Documentation

---

## 1. Project Overview

### Project Name
**Thaheen LMS (ذاهين)** – Mini Offline-First Learning Management System for Medical Education.

### Purpose
Thaheen LMS is an offline-capable mobile learning platform developed with Flutter. It is designed to provide medical students and healthcare professionals uninterrupted access to accredited curriculum lectures, anatomical demonstrations, and clinical physiology modules, regardless of internet connectivity.

### Target Users
- Undergraduate Medical and Health Sciences Students (Medicine, Nursing, Pharmacy, Preparatory Year).
- Clinical interns and resident physicians requiring on-the-go offline video study.
- Learners in low-connectivity or zero-connectivity clinical environments (hospital wards, transit, remote centers).

### Main Use Case
A student opens the application without internet connectivity, views their enrolled medical courses, tracks cumulative completion, resumes playback from their exact saved timestamps, watches bundled 1080p MP4 lectures with variable playback speeds, and automatically unlocks sequential lessons upon completing 90% of preceding lectures.

### Current Project Scope
- Fully functional offline course catalog pre-seeded with two medical courses (Fundamentals of Anatomy and Introduction to Medical Physiology).
- Offline asset playback featuring three bundled clinical MP4 videos under 10 MB each.
- Local persistence through Hive NoSQL storage for lesson playback timestamps, completion statuses, and course progress.
- Strict sequential lesson unlocking enforcing a 90% watch-time requirement.
- Full bilingual localization (Arabic RTL default and English LTR fallback) covering all UI labels and course metadata.
- Premium modern medical visual identity adhering to the Stitch design specification.

### Offline-First Concept
Thaheen operates 100% offline out-of-the-box:
- Courses and curricula are bundled and parsed locally from `assets/data/courses.json`.
- Video media is packaged directly in the application bundle (`assets/videos/`).
- Progress state is stored strictly on device storage via Hive with zero cloud or backend dependency.
- Network status is passively monitored via `connectivity_plus` only to notify the user of local offline availability.

---

## 2. Assignment Requirements & Implementation Traceability

| Requirement | Specification | Implementation in Project | Verified Status |
|---|---|---|---|
| **Platform** | Flutter Mobile Application | Flutter 3.29.0 / Dart 3.6.1 with Android SDK 34 support | Pass |
| **Offline Architecture** | 100% functional without internet | All media, JSON data, and Hive databases are bundled locally | Pass |
| **Course Catalog** | Display courses, sections, and lessons | Structured JSON deserialized into clean domain entities | Pass |
| **Video Playback** | MP4 playback from local assets | `video_player` plugin initializing bundled assets | Pass |
| **Under 10 MB Assets** | Video clips strictly under 10 MB | All 3 bundled MP4 files are under 8.5 MB | Pass |
| **Resume Playback** | Save position and resume automatically | Exact playback seconds stored in Hive and loaded on launch | Pass |
| **90% Completion Rule** | Auto-mark completed at 90% duration | `hasReachedCompletionThreshold` in pure domain logic | Pass |
| **Sequential Unlocking** | Unlock next lesson only when previous is done | `isLessonUnlocked` cross-section dependency validation | Pass |
| **Course Progress** | Accurate aggregate percentage calculation | `calculateCourseProgress` based on completed lessons | Pass |
| **Continue Watching** | Prominently display active lesson | `getContinueWatchingLesson` detects active in-progress item | Pass |
| **Unit Testing** | Minimum 3 unit tests for core rules | 46 comprehensive unit, logic, widget, and translation tests | Pass |
| **Bilingual Support** | Arabic (RTL) and English (LTR) | GetX localization with 80+ synchronized keys and bilingual JSON | Pass |
| **Clean Architecture** | Feature-First / Clean Layering | Separation into Data, Domain, and Presentation layers | Pass |

---

## 3. Technology Stack

### Core Frameworks
- **Flutter SDK**: `^3.29.0` (Dart SDK `^3.6.1`)
- **Null Safety**: 100% sound null safety enforced.

### State Management & Routing
- **GetX (`get: ^4.6.6`)**:
  - `GetxController`: reactive controllers managing UI state, video events, and course progress.
  - `Obx` / `Rx`: Fine-grained micro-updates without unnecessary widget rebuilds.
  - `GetPage` & `Get.toNamed`: Declarative and strongly typed screen transitions.
  - `Get.updateLocale`: Real-time runtime locale switching without app restart.

### Local Persistence
- **Hive (`hive: ^2.2.3`, `hive_flutter: ^1.1.0`)**:
  - Embedded, high-performance, lightweight key-value NoSQL database written in pure Dart.
  - Used for storing `LessonProgressModel` indexed by unique `lessonId`.
  - Zero native SQL overhead, synchronous and asynchronous fast disk I/O.

### Media Playback
- **Video Player (`video_player: ^2.11.1`)**:
  - Official Flutter plugin for playing back bundled video assets (`VideoPlayerController.asset`).
  - Supports variable playback speed (`1.0x`, `1.25x`, `1.5x`, `2.0x`), seeking, duration tracking, and fullscreen landscape.

### Localization & Internationalization
- **GetX Translations (`Translations`)**:
  - Symmetrical translation dictionaries (`ar`, `en`).
  - Runtime locale resolution via `LanguageController`.
  - Text direction switching (`TextDirection.rtl` vs `TextDirection.ltr`).
- **Flutter Localizations (`flutter_localizations`)**:
  - `GlobalMaterialLocalizations`, `GlobalWidgetsLocalizations`, `GlobalCupertinoLocalizations`.

### Responsive Layout
- **Flutter ScreenUtil (`flutter_screenutil: ^5.9.0`)**:
  - Standard base design canvas: `Size(375, 812)`.
  - Scaled units: `.w` (width), `.h` (height), `.sp` (font scale), `.r` (radius).

### App Startup & Branding
- **Flutter Native Splash (`flutter_native_splash: ^2.4.7`)**:
  - Seamless native launch screen to prevent blank screen flicker.
- **Flutter Launcher Icons (`flutter_launcher_icons: ^0.14.4`)**:
  - Automated adaptive icon generation across Android mipmap directories.

### Connectivity
- **Connectivity Plus (`connectivity_plus: ^6.1.4`)**:
  - Passive network connection monitoring to display offline sync banners.

### Development & Testing
- **`flutter_test`**: Standard unit and widget testing harness.
- **`mocktail: ^1.0.3`**: Type-safe mocking for data sources and services.
- **`flutter_lints: ^5.0.0`**: Strict lint rules for clean Dart style.

---

## 4. Project Architecture

The project follows a **Feature-First Clean Architecture** design. This ensures that features remain modular, decoupled, and self-contained, while pure business rules remain completely agnostic of Flutter UI frameworks.

```
lib/
├── config/
│   ├── app_environment.dart
│   ├── app_routes.dart
│   ├── app_theme.dart
│   ├── asset_paths.dart
│   └── stitch_colors.dart
├── core/
│   ├── controllers/
│   │   ├── language_controller.dart
│   │   └── theme_controller.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── localization/
│   │   ├── app_translations.dart
│   │   └── localized_content.dart
│   ├── services/
│   │   ├── network_service.dart
│   │   └── storage_service.dart
│   └── widgets/
│       ├── connectivity_banner_widget.dart
│       ├── custom_button.dart
│       └── custom_text_field.dart
├── features/
│   ├── courses/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── courses_local_data_source.dart
│   │   │   │   └── lesson_progress_local_data_source.dart
│   │   │   └── models/
│   │   │       ├── course_model.dart
│   │   │       ├── lesson_model.dart
│   │   │       ├── lesson_progress_model.dart
│   │   │       ├── lesson_progress_model.g.dart
│   │   │       └── section_model.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── course.dart
│   │   │   │   ├── lesson.dart
│   │   │   │   └── section.dart
│   │   │   ├── enums/
│   │   │   │   └── lesson_status.dart
│   │   │   └── logic/
│   │   │       └── lesson_progress_logic.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── courses_controller.dart
│   │       ├── screens/
│   │       │   └── courses_screen.dart
│   │       └── widgets/
│   │           ├── clinical_identity_bar.dart
│   │           ├── continue_watching_card.dart
│   │           ├── course_card.dart
│   │           ├── course_search_bar_with_filters.dart
│   │           ├── courses_empty_state.dart
│   │           ├── courses_error_state.dart
│   │           ├── courses_header.dart
│   │           ├── courses_loading_shimmer.dart
│   │           ├── enrolled_courses_list.dart
│   │           └── live_sync_health_strip.dart
│   ├── course_details/
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   └── course_details_controller.dart
│   │   │   ├── screens/
│   │   │   │   └── course_details_screen.dart
│   │   │   └── widgets/
│   │   │       ├── course_details_action_strip.dart
│   │   │       ├── course_details_top_bar.dart
│   │   │       ├── course_hero_media_card.dart
│   │   │       ├── course_syllabus_section_list.dart
│   │   │       ├── lesson_tile.dart
│   │   │       ├── locked_lesson_dialog.dart
│   │   │       ├── section_header.dart
│   │   │       └── sequential_learning_banner.dart
│   ├── lesson_player/
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── lesson_player_controller.dart
│   │       ├── screens/
│   │       │   └── lesson_player_screen.dart
│   │       └── widgets/
│   │           ├── lesson_completion_banner.dart
│   │           ├── lesson_mini_syllabus_timeline.dart
│   │           ├── lesson_overview_header.dart
│   │           ├── lesson_player_bottom_bar.dart
│   │           ├── lesson_player_bottom_controls.dart
│   │           ├── lesson_player_center_controls.dart
│   │           ├── lesson_player_controls_overlay.dart
│   │           ├── lesson_player_error_view.dart
│   │           ├── lesson_player_tabs.dart
│   │           ├── lesson_player_top_bar.dart
│   │           └── player_controls_widgets.dart
│   └── splash/
│       └── presentation/
│           ├── screens/
│           │   └── splash_screen.dart
│           └── widgets/
│               ├── splash_brand_content.dart
│               ├── splash_offline_footer.dart
│               ├── splash_pulse_logo.dart
│               ├── splash_sync_card.dart
│               ├── splash_top_bar.dart
│               └── synaptic_background_painter.dart
├── app.dart
├── di.dart
└── main.dart
```

### Architectural Layer Responsibilities
- **`config/`**: Global configurations, constants, theme schemes, routes, and Stitch design tokens (`StitchColors`).
- **`core/`**: Cross-cutting utilities, base exceptions/failures, shared services (`NetworkService`, `StorageService`), and common widgets.
- **`data/`**: External communication and serialization:
  - `datasources`: Directly accesses assets or local storage (`Hive.box`).
  - `models`: Data Transfer Objects (DTOs) with JSON serialization and Hive adapters.
- **`domain/`**: Pure enterprise business rules:
  - `entities`: Plain Dart objects independent of database and framework concerns.
  - `logic`: Pure algorithms without Flutter dependencies (`lesson_progress_logic.dart`).
- **`presentation/`**: Reactive UI components:
  - `controllers`: State holders mediating between domain logic and views.
  - `screens`: Top-level composition scaffolds.
  - `widgets`: Decomposed visual components.

---

## 5. Complete Application Flow

```
[App Entry (main.dart)]
        │
        ▼
[Dependency Injection (di.dart)] ──> Hive.init, Register Adapters, Open Box
        │
        ▼
[Splash Screen] ───────────────────> Timer (2.8s) or "Enter Learning Portal"
        │
        ▼
[Courses Screen] ──────────────────> Load courses.json + Read Hive Progress
   │           │
   │           ├── [Continue Watching Card Tap] ──┐
   │           ▼                                  │
   ├── [Course Card Tap]                          │
   │           │                                  │
   ▼           ▼                                  │
[Course Details Screen]                           │
   │                                              │
   ├── [Tap Locked Lesson] ──> Locked Dialog      │
   │                                              │
   └── [Tap Unlocked Lesson] ─────────────────────┤
                                                  │
                                                  ▼
                                       [Lesson Player Screen]
                                                  │
                                                  ├── Initialize Video Asset
                                                  ├── Seek to Saved Hive Position
                                                  ├── Stream Playback Position (Throttle 4s)
                                                  │
                                                  ├── Position >= 90% Duration?
                                                  │         │
                                                  │         ▼
                                                  │   Mark Lesson Completed in Hive
                                                  │   Unlock Next Lesson
                                                  │
                                                  └── Exit Player ──> Refresh Progress
```

---

## 6. Screens & Presentation Breakdown

### 1. Splash Screen ([splash_screen.dart](file:///c:/Users/Sami/Desktop/PROJECT-SAMI/Thaheen%20-ofLine%20Task/lib/features/splash/presentation/screens/splash_screen.dart))
- **Purpose**: Displays clinical platform branding, prepares offline state, and provides manual or automated transition into the learning portal.
- **UI Structure**:
  - `SynapticBackgroundPainter`: Custom canvas rendering biological synaptic neural curves.
  - `SplashTopBar`: Offline synchronization badge and dynamic language switcher (`ar` / `en`).
  - `SplashPulseLogo`: Smooth looping pulsing scale animation (`AnimationController`).
  - `SplashBrandContent`: Academic tag, platform title, curriculum subtitle, and specialization pills (Medicine, Nursing, Pharmacy, Prep).
  - `SplashSyncCard`: 100% offline indicator and "Enter Learning Portal" button.
  - `SplashOfflineFooter`: Offline compatibility note.
- **Behavior**: Automatically transitions to `AppRoutes.courses` after 2800ms, or immediately on button press.

### 2. Courses Screen ([courses_screen.dart](file:///c:/Users/Sami/Desktop/PROJECT-SAMI/Thaheen%20-ofLine%20Task/lib/features/courses/presentation/screens/courses_screen.dart))
- **Purpose**: Main dashboard displaying active study sessions, course cards, progress gauges, and filters.
- **UI Structure**:
  - `CoursesHeader`: Brand logo and student profile actions.
  - `ClinicalIdentityBar`: Academic avatar, student grade, offline synchronization pill, and locale toggle.
  - `LiveSyncHealthStrip`: Live Hive cache indicator.
  - `CourseSearchBarWithFilters`: Interactive search bar with medical specialty chips (Anatomy, Physiology, Biochemistry, Pharmacology).
  - `EnrolledCoursesList`: Composes `ContinueWatchingCard` (if any in-progress lesson exists) and all `CourseCard` items.
- **State Handling**: Shimmer loading via `CoursesLoadingShimmer`, error banner via `CoursesErrorState`, empty placeholder via `CoursesEmptyState`.

### 3. Course Details Screen ([course_details_screen.dart](file:///c:/Users/Sami/Desktop/PROJECT-SAMI/Thaheen%20-ofLine%20Task/lib/features/course_details/presentation/screens/course_details_screen.dart))
- **Purpose**: Comprehensive syllabus view for a selected course, outlining modules, lock states, and completion rules.
- **UI Structure**:
  - `CourseDetailsTopBar`: Sliver navigation bar with back navigation and course title.
  - `CourseDetailsActionStrip`: Certified medical content badge and offline download pill.
  - `CourseHeroMediaCard`: Course thumbnail, instructor credentials, clinical metrics (16 hours training, lecture count, Hive sync), linear progress bar, and custom circular ring painter (`_RingPainter`).
  - `SequentialLearningBanner`: Explains the 90% completion unlocking policy.
  - `CourseSyllabusSectionList`: Sections with `SectionHeader` and `LessonTile` widgets showing dynamic lock, in-progress, or completed states.
- **Interaction**: Tapping an unlocked lesson opens `LessonPlayerScreen`. Tapping a locked lesson invokes `LockedLessonDialog`.

### 4. Lesson Player Screen ([lesson_player_screen.dart](file:///c:/Users/Sami/Desktop/PROJECT-SAMI/Thaheen%20-ofLine%20Task/lib/features/lesson_player/presentation/screens/lesson_player_screen.dart))
- **Purpose**: Offline video lecture player supporting playback control, resume, auto-completion, and syllabus browsing.
- **UI Structure**:
  - `VideoPlayer`: Local asset player with 16:10 portrait aspect ratio or full-screen aspect ratio.
  - `LessonPlayerControlsOverlay`: Animated gradient overlay containing:
    - `LessonPlayerTopBar`: Back button, lesson title, offline tag, and 1080p pill.
    - `LessonPlayerCenterControls`: 10s rewind, play/pause, 10s fast-forward.
    - `LessonPlayerBottomControls`: `VideoProgressBar`, playback speed selector, and fullscreen toggle.
  - `LessonCompletionBanner`: Dynamic alert that changes style when 90% is achieved.
  - `LessonOverviewHeader`: Active lecture title, instructor card, and note-taking action.
  - `LessonPlayerTabs`: Segmented selector for Module Contents, Lecture Summary, and Notes.
  - `LessonMiniSyllabusTimeline`: Compact 3-lecture playlist displaying real-time status.
  - `LessonPlayerBottomBar`: Sequential "Next Lesson" trigger and Hive storage confirmation.

---

## 7. Stitch Design System & Aesthetics

The application implements the **Stitch Medical UI Design System** based on high-fidelity clinical prototypes:

### Color Palette (`lib/config/stitch_colors.dart`)
- **Primary (`#006590`)**: Clinical deep cyan blue representing academic precision.
- **Primary Container (`#00A6EB`)**: Vibrant sky cyan used for active elements and gradients.
- **Primary Fixed (`#C8E6FF`)**: Soft ice blue for badges and icon containers.
- **Secondary (`#2F6388`)**: Slate navy used for supporting headings and secondary tags.
- **Tertiary (`#006C49`)**: Surgical emerald green representing completion, success, and verified health.
- **Tertiary Fixed (`#6FFBBE`)**: Mint highlight used for 90% threshold markers and sync tags.
- **Surface / Background (`#F9F9FF`)**: Pristine clinical neutral white with a subtle cool undertone.
- **Inverse Surface (`#263143`)**: Dark slate navy used for media cards and player overlays.

### Typography
- **Cairo Font Family**: Integrated across 4 weights (`Regular 400`, `Medium 500`, `SemiBold 600`, `Bold 700`).
- Consistent readability across Arabic RTL script and English Latin alphanumeric figures.

### Elevation & Shapes
- Rounded containers with `12.r` to `20.r` border radii.
- Soft multi-stop shadows (`StitchColors.cardShadow` at `0x0A000000`).

---

## 8. Data Layer Implementation

### Data Source: `assets/data/courses.json`
Bilingual JSON schema separating Arabic and English strings while keeping structural identifiers language-agnostic:

```json
[
  {
    "id": "course_anatomy",
    "title": {
      "ar": "أساسيات علم التشريح",
      "en": "Fundamentals of Anatomy"
    },
    "instructor": {
      "ar": "د. أحمد محمد",
      "en": "Dr. Ahmed Mohammed"
    },
    "thumbnail": "assets/images/anatomy_course.jpg",
    "sections": [
      {
        "id": "section_anatomy_intro",
        "title": {
          "ar": "مقدمة في علم التشريح",
          "en": "Introduction to Anatomy"
        },
        "lessons": [
          {
            "id": "lesson_anatomy_intro_01",
            "title": {
              "ar": "مقدمة عن جسم الإنسان",
              "en": "Introduction to the Human Body"
            },
            "duration": "00:15",
            "videoAsset": "assets/videos/human_skeleton_anatomy.mp4",
            "order": 1
          }
        ]
      }
    ]
  }
]
```

### Models & Mapping
- `CourseModel.fromJson` → constructs `Course` domain entity.
- `SectionModel.fromJson` → constructs `Section` domain entity.
- `LessonModel.fromJson` → constructs `Lesson` domain entity.
- `LocalizedContent.fromJson` → constructs bilingual object resolving text on demand.

---

## 9. Domain Layer & Pure Business Rules

Located in `lib/features/courses/domain/logic/lesson_progress_logic.dart`. Completely decoupled from Flutter widgets and Hive storage, allowing 100% deterministic unit testing:

1. **Duration Parser (`_parseDurationSeconds`)**: Converts `"mm:ss"` string to integer seconds.
2. **Status Evaluation (`getLessonStatus`)**: Returns `completed`, `inProgress`, or `notStarted`.
3. **Threshold Check (`hasReachedCompletionThreshold`)**:
   $$\text{Progress Ratio} = \frac{\text{clampedPosition}}{\text{totalSeconds}} \ge 0.90$$
4. **Sequential Lock Check (`isLessonUnlocked`)**:
   - Lesson at index 0 is always unlocked.
   - Lesson at index $N$ is unlocked if and only if lesson at index $N-1$ has `completed == true`.
5. **Course Progress (`calculateCourseProgress`)**:
   $$\text{Course Progress} = \frac{\text{Completed Lessons Count}}{\text{Total Lessons Count}}$$
6. **Continue Watching Selection (`getContinueWatchingLesson`)**:
   Returns the first lesson in global course order that has $\text{position} > 0$ and $\text{completed} == \text{false}$.

---

## 10. Persistence System (Hive)

- **Box Name**: `'lesson_progress'`
- **Model**: `LessonProgressModel` (Type ID: `0`)
  - `String lessonId` (HiveField 0)
  - `int position` (HiveField 1) - Saved playback seconds
  - `bool completed` (HiveField 2) - Completion flag
- **Write Throttling**: The video player throttles disk writes to once every 4 seconds or on significant events (pause, seek, lesson change, app close) to maximize performance and prevent storage wear.

---

## 11. Sequential Unlocking Logic

- Lessons are ordered globally across sections by their `order` integer field.
- Unlocking rules cross section boundaries seamlessly: completing the last lesson of Section 1 automatically unlocks the first lesson of Section 2.
- Skipping ahead is strictly prohibited at both the UI level (non-clickable tiles) and routing level (`_handleLessonTap` validation).

---

## 12. Video Player Features & Lifecycle

- **Asset Playback**: Loads bundled MP4 assets via `VideoPlayerController.asset`.
- **Auto-Resume**: Automatically queries Hive on initialization and seeks to `savedSeconds`.
- **Speed Selector**: Supports `1.0x`, `1.25x`, `1.5x`, and `2.0x`.
- **Landscape Fullscreen**:
  - `SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)`.
  - `SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])`.
  - Automatically resets to `portraitUp` and `edgeToEdge` upon exit or screen disposal.
- **Auto-Completion**: Continuously monitors playback position; triggers `_markCompleted()` the moment 90% duration is reached.
- **Resource Disposal**: Cancels timers, removes controller listeners, and disposes native video player texture on controller teardown.

---

## 13. Localization & Internationalization

- **Default Locale**: Arabic (`Locale('ar')`).
- **Fallback Locale**: Arabic (`Locale('ar')`).
- **Supported Locales**: Arabic (`ar`), English (`en`).
- **Dynamic Content Resolution**: `LocalizedContent` evaluates `Get.locale?.languageCode == 'en'` and displays English or Arabic text dynamically without rebuilding the entire domain layer.
- **Key Parity**: 100% key synchronization between Arabic and English verified via automated tests.

---

## 14. Asset Catalog

### Video Assets (`assets/videos/`)
| Filename | Resolution | Size | Content |
|---|---|---|---|
| `human_skeleton_anatomy.mp4` | 1080p | 2.73 MB | Skeletal system 3D visualization |
| `medical_cells_biology.mp4` | 1080p | 2.63 MB | Microscopic cellular physiology |
| `skeleton_human_body.mp4` | 1080p | 8.36 MB | Full body skeletal anatomy |

### Graphic & Font Assets
- **Logo**: `assets/images/Thaheen logo.jpg`
- **Course 1 Thumbnail**: `assets/images/anatomy_course.jpg`
- **Course 2 Thumbnail**: `assets/images/physiology_course.jpg`
- **Fonts**: `assets/fonts/cairo/` (Cairo Regular, Medium, SemiBold, Bold).

---

## 15. Dependencies & Third-Party Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.6.6                    # State management, navigation, translations
  hive: ^2.2.3                   # NoSQL persistent storage
  hive_flutter: ^1.1.0           # Hive Flutter initialization & extensions
  flutter_screenutil: ^5.9.0     # Responsive dimension adaptions
  intl: ^0.20.2                  # Localization & date/number utilities
  equatable: ^2.0.5              # Value equality comparison for models
  flutter_native_splash: ^2.4.7  # Native splash preservation
  connectivity_plus: ^6.1.4      # Passive network connectivity monitor
  video_player: ^2.11.1          # Native hardware-accelerated video playback

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0          # Recommended code quality linter
  build_runner: ^2.4.14          # Code generator for Hive adapters
  mocktail: ^1.0.3               # Unit test mock framework
  flutter_launcher_icons: ^0.14.4# App icon builder
```

---

## 16. Automated Test Suite

The test suite contains **46 automated tests** structured under `test/`:

1. **Translations Parity Tests** (`test/core/localization/app_translations_test.dart`):
   - Confirms Arabic and English keysets are identical.
   - Validates fallback behavior.
2. **Connectivity Banner Tests** (`test/core/widgets/connectivity_banner_widget_test.dart`):
   - Validates network notification rendering.
3. **Core Domain Logic Tests** (`test/features/courses/domain/logic/lesson_progress_logic_test.dart`):
   - 90% completion rule verification.
   - Sequential lock and unlock logic.
   - Cross-section unlocking logic.
   - Cumulative course progress calculation.
   - Continue watching identification.
   - Edge cases (empty course, zero-duration, corrupted position).

---

## 17. Error Handling & Edge Cases

- **Corrupted Course JSON**: `CoursesLocalDataSourceImpl` catches `FormatException` and throws `CacheException`. The UI displays `CoursesErrorState` with a retry action.
- **Missing or Corrupted Video**: Caught inside `LessonPlayerController`, setting `hasError = true` and presenting `LessonPlayerErrorView`.
- **Database Write Failure**: Local Hive writes are wrapped in `try/catch` blocks to prevent unhandled asynchronous crashes.

---

## 18. Responsive Design & Screen Adaptation

- Base layout scaled through `ScreenUtilInit` for screen sizes from 4.7-inch phones to large tablets.
- **Landscape Video Player**:
  - Speed selector sheet constrained to `isLandscape ? height * 0.85 : 360.h` with compact visual density to prevent `RenderFlex` bottom overflow.
  - Video player aspect ratio dynamically expands to `StackFit.expand` in fullscreen mode.

---

## 19. Code Quality & Standards

- **Zero-Comment Rule**: Strict adherence to no comments (`//`, `///`, `/* */`) across all source code files. Code is designed to be completely self-documenting through clean naming.
- **Component Decomposition**: Screens are kept compact by delegating sub-trees to focused, single-responsibility widgets.
- **Sound Null Safety**: Zero dynamic runtime type risks across domain entities and state models.

---

## 20. Build & Verification Guide

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Code Analyzer
```bash
flutter analyze lib/ test/
```
*(Expected: `No issues found!`)*

### 3. Run Automated Tests
```bash
flutter test
```
*(Expected: `All 46 tests passed!`)*

### 4. Run Application (Debug)
```bash
flutter run
```

### 5. Build Release APK
```bash
flutter build apk --release
```
*(Expected: Built `build/app/outputs/flutter-apk/app-release.apk`)*

---

## 21. Git & Version Control State

- **Active Branch**: `main`
- **Working Tree**: Clean (`git status` reports nothing to commit).
- **Recent Commits**:
  - `0fc6a12 refactor screen 1`
  - `64e03b3 add localization, and presentation screens`
  - `c3a38e9 add mobile UI redesign screens, widgets, and assets for LMS application`
- **Ignored Files (`.gitignore`)**: Standard Flutter exclusions (`.dart_tool/`, `build/`, `.gradle/`, `.idea/`).

---

## 22. Known System Limitations

1. **Local Asset Scope**: The application currently loads courses and videos bundled directly inside the APK. Dynamic download of additional video assets over HTTP is not implemented.
2. **Fixed Speed Options**: Playback speeds are limited to `[1.0, 1.25, 1.5, 2.0]` without continuous slider speed control.

---

## 23. Manual QA Acceptance Checklist

- [x] **App Launch**: Smooth splash screen with pulsing logo; transitions automatically to courses.
- [x] **Bilingual Switching**: Tapping language toggle immediately switches Arabic (RTL) / English (LTR).
- [x] **Offline Capability**: Operates fully in airplane mode with zero internet connectivity.
- [x] **Catalog Browsing**: All courses and lessons render with localized titles and instructor names.
- [x] **Sequential Lock Enforcement**: Only the first lesson is accessible initially; subsequent lessons are locked.
- [x] **Locked Lesson Dialog**: Tapping a locked tile presents an alert and prevents access.
- [x] **Video Playback**: Unlocked video begins playing smoothly with audio.
- [x] **Resume Position**: Exiting mid-lecture and reopening resumes from the exact second.
- [x] **90% Completion**: Watching past 90% triggers completion badge and unlocks the next lesson.
- [x] **Continue Watching**: Active in-progress lesson appears prominently on the main dashboard.
- [x] **Fullscreen Orientation**: Fullscreen switches to landscape; exiting restores portrait mode.
- [x] **Playback Speed Sheet**: Speed modal fits properly in both landscape and portrait without overflow.

---

## 24. Submission Readiness

| Area | Status | Notes |
|---|---|---|
| Functional LMS Requirements | **100% Ready** | Unlocking, progress, resume, and video playback complete |
| Offline Assets | **100% Ready** | All videos bundled and verified under 10 MB |
| Stitch UI Design System | **100% Ready** | High-fidelity implementation of all Stitch specifications |
| Code Architecture | **100% Ready** | Modular components, feature-first structure, zero comments |
| Automated Test Coverage | **100% Ready** | 46 tests passing |
| Static Analysis | **100% Ready** | `flutter analyze` reports 0 issues |
| Production Release Build | **100% Ready** | `app-release.apk` builds successfully |

---

## 25. Technical Summary

The **Thaheen LMS** Flutter application is a robust, production-grade, offline-first educational platform. Built upon Clean Architecture and Feature-First organization, the application cleanly decouples business rules (`lesson_progress_logic.dart`) from local persistence (`Hive`) and UI frameworks (`GetX`). 

Every visual component has been decomposed into modular, reusable widgets adhering to the modern Stitch medical design system. State is managed reactively, ensuring zero visual lag and responsive playback control across both Arabic (RTL) and English (LTR) locales.
