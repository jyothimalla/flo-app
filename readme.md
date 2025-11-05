# Ovulation Tracker (Flutter)

A tiny, privacy-first Flutter app that logs periods, estimates ovulation, and highlights the fertile window.

> **Disclaimer:** Predictions are estimates only and **not medical advice**.

---

## Table of Contents
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Prediction Model](#prediction-model)
- [Configuration](#configuration)
- [Privacy](#privacy)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

---

## Features
- Log period **start/end** with date pickers
- **Cycle predictions** (rolling average; clamped 20–45 days)
- **Ovulation** = next period − luteal days (default 14; editable)
- **Fertile window** highlight
- **Calendar** month grid with color-coded days
- **Insights** (next period & fertile range)
- **Settings** (cycle length & luteal phase)

---

## Screenshots
> Add images in `/docs/images` and link them here.
<!--
![Calendar](docs/images/calendar.png)
![Insights](docs/images/insights.png)
-->

---

## Tech Stack
- Flutter (Material 3)
- Pure Dart state (MVP)
- Optional: Hive (local storage), Riverpod, Local Notifications, TableCalendar

---

## Quick Start

**MVP (single-file)**
```bash
flutter create ovulation_mvp
cd ovulation_mvp
# Replace lib/main.dart with your MVP code
flutter run
