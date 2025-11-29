# 🌸 Flo App — MVP Product Plan

## 1. Overview
Flo App is a simple menstrual cycle tracker that helps users log periods, view cycles on a calendar, get predictions, and see basic analysis.  
This document contains the Epics, User Stories, Acceptance Criteria, and Roadmap for the MVP version.

---

## 2. MVP Scope (What must be included)
- Period tracking (start/end dates)
- Calendar with highlighted period days
- Basic prediction (next period)
- Basic analysis (average cycle length, period length)
- Simple profile (age + dark mode)

---

# 3. EPICS + USER STORIES + ACCEPTANCE CRITERIA

---

## 🟥 EPIC 1: Period Tracking

### User Stories
1. As a user, I want to edit my period start date so that the app can give accurate predictions.  
2. As a user, I want to delete a wrong period log so that my cycle data stays clean and predictions stay correct.  
3. As a user, I want to see a confirmation message after logging my period so that I know it was saved successfully.

### Acceptance Criteria
- User can change start date and it saves correctly  
- User can delete logs with confirmation  
- Calendar refreshes after changes  
- Predictions update automatically  
- Success messages appear for every change  

---

## 🟩 EPIC 2: Calendar

### User Stories
1. As a user, I want to see my period days highlighted on the calendar so that I can easily understand my cycle history.  
2. As a user, I want to move to previous and next months so that I can review past and future dates.  
3. As a user, I want to tap a date on the calendar so that I can quickly log or edit my period.  
4. As a user, I want today’s date clearly marked so that I never lose track of the current day.

### Acceptance Criteria
- Calendar loads with highlighted period days  
- Month navigation works smoothly  
- Selecting a date shows log/edit options  
- Today’s date is visually distinct  

---

## 🟦 EPIC 3: Predictions

### User Stories
1. As a user, I want to see my next expected period date so that I can plan ahead.  
2. As a user, I want the app to use my past cycles to estimate my next cycle so that predictions are personalised.  
3. As a user, I want predicted dates highlighted in a different colour so that I can easily separate predictions from real logs.  
4. As a user, I want predictions to update automatically when I edit any period dates so that results stay accurate.

### Acceptance Criteria
- Prediction shown clearly on UI  
- Based on past cycle lengths  
- Highlighted differently on the calendar  
- Updates anytime logs change  

---

## 🟪 EPIC 4: Analysis

### User Stories
1. As a user, I want to see my average cycle length so that I can understand my overall pattern.  
2. As a user, I want to see my average period length so that I know what is normal for me.  
3. As a user, I want to see information about my latest cycle so that I can track changes easily.  
4. As a user, I want to know if my cycles are regular or irregular so that I can understand my health better.

### Acceptance Criteria
- Show average cycle length  
- Show average period length  
- Show last cycle summary  
- Show regular/irregular label with color indicator  

---

## 🟧 EPIC 5: Profile

### User Stories
1. As a user, I want to update my age in the profile so that my information stays accurate.  
2. As a user, I want to switch the app theme to dark so that it feels comfortable for my eyes.

### Acceptance Criteria
- Age saved locally  
- Dark mode toggle works  
- Theme persists after restart  

---

# 4. ROADMAP

### 🟢 MVP (v0.1.0)
- Log period start/end  
- Calendar with highlights  
- Basic prediction  
- Basic analysis  
- Profile with age + dark mode  

### 🔵 v1.0 — Polished app
- Better UI design  
- Edit end date  
- Cycle history list page  
- Better prediction logic  
- Basic charts in analysis  

### 🟣 v2.0 — Advanced version
- Mood & symptoms tracking  
- Reminders & notifications  
- More themes  
- Onboarding flow  

---

# 5. DEVELOPMENT CHECKLIST (for coding)

## App foundation
- [ ] Navigation working between all screens  
- [ ] AppState model ready  
- [ ] Hive storage working

## Period Tracking
- [ ] Log start date  
- [ ] Log end date  
- [ ] Edit start date  
- [ ] Delete log  
- [ ] Show success messages

## Calendar
- [ ] Calendar widget set up  
- [ ] Highlight period days  
- [ ] Tap to select date  
- [ ] Month navigation  
- [ ] Today marker

## Predictions
- [ ] Compute next predicted period  
- [ ] Show predicted date on home  
- [ ] Highlight prediction on calendar  
- [ ] Auto-update on changes

## Analysis
- [ ] Average cycle length  
- [ ] Average period length  
- [ ] Last cycle summary  
- [ ] Regular vs Irregular indicator

## Profile
- [ ] Age field  
- [ ] Dark mode toggle  
- [ ] Save theme mode persistently

---

# 6. NOTES
- All data is stored locally (no backend).  
- App should be simple, clear, and beginner-friendly.  
- Later versions may add more tracking or AI assistance.

