<p align="center">
  <img src="./assets/logo/logo.png" width="120" alt="Tparking Logo"/>
</p>

<h1 align="center">Tparking</h1>
<p align="center"><b>Smart Car Parking Application</b></p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-v3.1.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-Database%20%7C%20Auth%20%7C%20Realtime-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase"/></a>
  <a href="https://pub.dev/packages/get"><img src="https://img.shields.io/badge/GetX-State%20Management-8B39B7?style=for-the-badge&logo=dart&logoColor=white" alt="GetX"/></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-v3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/></a>
  <a href="https://www.tni.ac.th"><img src="https://img.shields.io/badge/TNI-Thai--Nichi%20Institute%20of%20Technology-blue?style=for-the-badge" alt="TNI"/></a>
</p>

<br/>

**Tparking** is an intelligent, real-time car parking reservation and management application built with **Flutter** (Dart) and backed by **Supabase**. Designed and developed as a university project for **Thai-Nichi Institute of Technology (TNI)**, the application optimizes parking search, dynamic slot booking, and check-in workflows on campus.

---

## 📖 Table of Contents

- [✨ Key Features](#-key-features)
- [🔒 Business Rules & Constraints](#-business-rules--constraints)
- [🛠️ Tech Stack & Architecture](#️-tech-stack--architecture)
- [📂 Project Directory Structure](#-project-directory-structure)
- [🚀 Getting Started](#-getting-started)
- [🗄️ Database Setup (Supabase)](#️-database-setup-supabase)
- [📱 Application Screens](#-application-screens)

---

## ✨ Key Features

### 1. Real-time Parking Slot Syncing

- Live status syncs for parking slots (Empty, Booked, Parked) using **Supabase Realtime** subscriptions.
- Categorized parking zones based on university buildings: **A Building**, **B Building**, and **C Building** via a dynamic dropdown selection.
- Supports visual layouts for 8 active parking slots displaying structural entry (ENTRY) and exit (EXIT) paths.

### 2. Efficient Single-Write Reservation Timer

- When a booking is made, the app records `parked_from` (start time) and `parked_to` (expiry time) as **ISO 8601 UTC timestamps** in a **single database write** — eliminating the old approach of spamming updates every second.
- The countdown timer runs **entirely on the client side** using a local `Timer`, keeping it smooth and network-friendly.
- Navigating away and returning to the app correctly resumes the timer from the accurate remaining time, with no resets.

### 3. Auto-Release via Supabase pg_cron

- A **`pg_cron`** job runs every minute on the Supabase backend to automatically release expired reservations (where `parked_to <= NOW()`).
- The cleanup function uses `SECURITY DEFINER SET search_path = public` and has `EXECUTE` privileges revoked from `PUBLIC`, `anon`, and `authenticated` roles to prevent misuse via the public API.

### 4. Cross-Building Active Reservation Detection

- On app launch, the system automatically searches all building tables (`parking_slots_a`, `parking_slots_b`, `parking_slots_c`) for an existing active booking by the logged-in user.
- If found, the app switches to the correct building tab and resumes the countdown timer seamlessly.

### 5. Geofenced GPS Check-In

- **Preventing "No-Show" Bookings:** Users must physically arrive at the TNI campus before they can tap the **CHECK-IN** button.
- Uses the **Location** package to query live device coordinates and calculate distance to TNI campus center (Latitude: `13.7380`, Longitude: `100.6284`).
- Users must be within a **150-meter radius** of TNI coordinates. If outside this boundary, the app prevents check-in with a "You are not at TNI" alert.

### 6. Parking Status UI

- When a user checks in successfully, the circular timer is replaced by a **Lottie animation** of a parked car with a **"Currently Parked"** badge.
- The active reservation card on the home screen displays the **booked slot name** and the **vehicle license plate** used for the reservation.

### 7. Vehicle Registration & User Profiles

- Secure authentication (Sign-Up / Login) managed via **Supabase Auth**.
- Local registration of vehicle license plates cached in `SharedPreferences` and dynamically loaded in the booking screen via a searchable dropdown (`DropdownSearch`).
- User profile editing, including profile picture changes via camera or gallery (`image_picker`).

---

## 🔒 Business Rules & Constraints

- **Role-Based Booking Restrictions (Student vs Staff):**
  - Users with the `Student` role cannot reserve parking spots **before 15:00 (3 PM)**. This prioritizes slots for faculty and staff during working hours.
- **Operating Hours Constraint:**
  - Reservations are allowed between **05:00 and 19:00** only.
  - All slots are automatically reset nightly via `resetAllSlotsAtNight()` to ensure a clean state each morning.

---

## 🛠️ Tech Stack & Architecture

Tparking uses **Dart** and **Flutter** with a Clean Feature-First Architecture for readability, decoupled state management, and maintainability:

| Category | Technology |
|---|---|
| **State Management** | [GetX](https://pub.dev/packages/get) |
| **Backend & Database** | [Supabase](https://supabase.com) (PostgreSQL + Realtime + Auth) |
| **Server-side Scheduling** | Supabase `pg_cron` extension |
| **Push Notifications** | Firebase Cloud Messaging (`firebase_messaging`) |
| **Local Notifications** | `flutter_local_notifications` |
| **Animations** | `lottie`, `animations`, `flutter_staggered_animations` |
| **Navigation** | `salomon_bottom_bar` |
| **Timer UI** | `circular_countdown_timer` |
| **Location Services** | `location` |
| **Image Picker** | `image_picker` |
| **Dropdown Search** | `dropdown_search` |

---

## 📂 Project Directory Structure

```text
tparking/
├── android/                                            # Android-specific configuration and native code
├── ios/                                                # iOS-specific configuration and native code
├── assets/                                             # Static application assets
│   ├── animation/                                      # Lottie JSON animation files (e.g., Parked_by.json)
│   ├── images/                                         # Graphic images, illustrations, and icons
│   └── logo/                                           # Application branding logos
├── lib/                                                # Dart source code of the Flutter application
│   ├── main.dart                                       # Application entrypoint & Supabase initialization
│   └── src/
│       ├── common_widgets/                             # Reusable global widgets and layout constants
│       │   └── constants/                              # Application-wide constants (colors, sizes, strings)
│       ├── features/                                   # Core application modules (Feature-First Architecture)
│       │   ├── authentication/                         # Register, Login, Welcome, and Splash features
│       │   │   ├── controllers/                        # GetX Controllers for auth flows
│       │   │   ├── models/                             # UserModel representation
│       │   │   └── screens/                            # Views for auth onboarding
│       │   ├── controllers/                            # Shared controllers
│       │   │   ├── parking_controllers.dart            # Core: booking, timer, reservation state, cron cleanup
│       │   │   └── notification_local.dart             # Local notification scheduler
│       │   └── core/                                   # Post-authentication core screens and modules
│       │       ├── controllers/                        # Controllers for core application flow
│       │       └── screens/                            # Primary user dashboard views
│       │           ├── homepage.dart                   # Overview: active card, timer, Lottie, check-in
│       │           ├── reserves/                       # Real-time slot booking and list views
│       │           │   ├── reserve.dart                # Visual map selector of parking slots
│       │           │   └── booking_page.dart           # Booking form with time slider
│       │           ├── profiles/                       # Profile settings and update forms
│       │           └── forget_password/                # Forgot password recovery screens
│       └── repository/                                 # Data access layers
│           ├── authentication_repository/              # Supabase Auth integrations
│           └── parkingSlot/                            # Supabase slot widget and building settings
```

---

## 🚀 Getting Started

### 📋 Prerequisites

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) v3.1.0 or higher.
2. Install [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter & Dart extensions.
3. Create a [Supabase](https://supabase.com) project and set up the required tables (see Database Setup below).

### 💻 Installation & Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/Full-Stack-boi/tparking.git
   cd tparking
   git checkout Supabase-integration
   ```

2. **Fetch Dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Supabase:**
   - Open `lib/main.dart` and replace with your Supabase project credentials:
     ```dart
     await Supabase.initialize(
       url: 'YOUR_SUPABASE_URL',
       anonKey: 'YOUR_SUPABASE_ANON_KEY',
     );
     ```

4. **Verify Environment Integrity:**

   ```bash
   flutter doctor
   flutter analyze
   ```

5. **Build and Run:**
   ```bash
   flutter run
   ```

---

## 🗄️ Database Setup (Supabase)

### Tables Required

Create three identical tables for each building: `parking_slots_a`, `parking_slots_b`, `parking_slots_c`.

| Column | Type | Description |
|---|---|---|
| `id` | `uuid` | Primary key |
| `slotName` | `text` | Display name (e.g. "A-1") |
| `booked` | `boolean` | Whether slot is reserved |
| `isParked` | `boolean` | Whether vehicle is checked in |
| `car_registration` | `text` | License plate of booking vehicle |
| `parking_hours` | `text` | Reserved duration in hours |
| `parked_from` | `text` | ISO 8601 UTC reservation start time |
| `parked_to` | `text` | ISO 8601 UTC reservation expiry time |
| `building` | `text` | Building identifier (A, B, or C) |

### pg_cron Auto-Release Setup

Run the following in **Supabase SQL Editor** to enable automatic slot cleanup:

```sql
-- Enable pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Safe cleanup of any existing job
SELECT cron.unschedule(jobid)
FROM cron.job
WHERE jobname = 'release-expired-slots-job';

-- Create the cleanup function (hardened with SECURITY DEFINER)
CREATE OR REPLACE FUNCTION release_expired_parking_slots()
RETURNS void AS $$
BEGIN
  UPDATE parking_slots_a SET booked = false, isParked = false, car_registration = '', parking_hours = '0', parked_from = NULL, parked_to = NULL
  WHERE booked = true AND isParked = false AND parked_to IS NOT NULL AND parked_to <= NOW();

  UPDATE parking_slots_b SET booked = false, isParked = false, car_registration = '', parking_hours = '0', parked_from = NULL, parked_to = NULL
  WHERE booked = true AND isParked = false AND parked_to IS NOT NULL AND parked_to <= NOW();

  UPDATE parking_slots_c SET booked = false, isParked = false, car_registration = '', parking_hours = '0', parked_from = NULL, parked_to = NULL
  WHERE booked = true AND isParked = false AND parked_to IS NOT NULL AND parked_to <= NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Revoke public access to prevent misuse via RPC
REVOKE EXECUTE ON FUNCTION public.release_expired_parking_slots() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.release_expired_parking_slots() FROM anon, authenticated;

-- Schedule to run every minute
SELECT cron.schedule('release-expired-slots-job', '* * * * *', 'SELECT release_expired_parking_slots();');
```

---

## 📱 Application Screens

- **Welcome & Authenticate:** Animated splash and welcome screen with role-based Login & Sign-Up.
- **Home Dashboard:** Active reservation card with circular countdown timer (or Lottie parked animation), vehicle plate display, TNI-geofenced Check-In, and Check-Out.
- **Reserve Slots:** Interactive visual map of Building A, B, and C with remaining time shown on booked slots.
- **Car Registry & Profile:** Register vehicle plates, update personal details, and upload profile pictures.
