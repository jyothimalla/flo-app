# 🌸 Flo App — MVP Product Plan

A simple menstrual cycle tracker that allows users to log periods, view a calendar, get predictions, and see basic analysis.  
This document lists Epics, User Stories, Acceptance Criteria, Story Points, Task Lists, and the Roadmap.

---

# 1. MVP Scope
- Period tracking (start/end dates)
- Calendar with highlights
- Basic prediction (next period)
- Basic analysis (average cycle length, period length)
- Simple profile (age + dark mode)

---

# 2. EPICS + DETAILS (User Stories + Acceptance Criteria + Story Points + Tasks)

---

# 🟥 EPIC 1: Period Tracking

## Story 1: Edit Period Start Date  
**As a user, I want to edit my period start date so that the app can give accurate predictions.**  
**Story Points: 3**

### Acceptance Criteria
- Edit option available  
- Updated date saved correctly  
- Calendar refreshes  
- Prediction updates  
- Success message shown  

### Tasks
- [ ] Add UI to edit date  
- [ ] Open date picker with existing date  
- [ ] Update AppState → `editPeriodStart()`  
- [ ] Save to Hive  
- [ ] Refresh calendar  
- [ ] Show SnackBar  

---

## Story 2: Delete Wrong Period Log  
**As a user, I want to delete a wrong period log so that my cycle data stays clean and predictions stay correct.**  
**Story Points: 2**

### Acceptance Criteria
- User can delete a log  
- Confirmation before deleting  
- Log removed from calendar  
- Predictions update  
- Success message appears  

### Tasks
- [ ] List all logs  
- [ ] Add delete icon  
- [ ] Add confirmation dialog  
- [ ] Call `deletePeriod()`  
- [ ] Save to Hive  
- [ ] Refresh UI  

---

## Story 3: Confirmation After Logging  
**As a user, I want to see a confirmation message after logging my period so that I know it was saved successfully.**  
**Story Points: 1**

### Acceptance Criteria
- SnackBar appears after saving any log  
- Auto-dismiss  
- No crashes  

### Tasks
- [ ] Add SnackBar method  
- [ ] Trigger after start/end/edit/delete  
- [ ] Test messages  

---

# 🟩 EPIC 2: Calendar

## Story 1: Highlight Period Days  
**As a user, I want to see my period days highlighted on the calendar so that I can understand my cycle history.**  
**Story Points: 3**

### Acceptance Criteria
- Highlighted period dates  
- Past cycles visible  
- No UI overlap  

### Tasks
- [ ] Setup TableCalendar  
- [ ] Load dates from AppState  
- [ ] Use `CalendarBuilders`  
- [ ] Style highlights  

---

## Story 2: Navigate Months  
**As a user, I want to move to previous and next months so that I can review past and future dates.**  
**Story Points: 1**

### Acceptance Criteria
- Smooth navigation  
- No crashes  

### Tasks
- [ ] Enable month navigation  
- [ ] Update `focusedDay`  
- [ ] Test months  

---

## Story 3: Tap to Select Date  
**As a user, I want to tap a date on the calendar so I can quickly log or edit my period.**  
**Story Points: 2**

### Acceptance Criteria
- Date can be selected  
- Options for log/edit appear  
- Clear visual selection  

### Tasks
- [ ] Detect date tap  
- [ ] Store selected date  
- [ ] Show actions  
- [ ] Wire actions to AppState  

---

## Story 4: Today Marker  
**As a user, I want today clearly marked so I always know the current date.**  
**Story Points: 1**

### Acceptance Criteria
- Today highlighted  
- Works across months  

### Tasks
- [ ] Add today highlight rule  
- [ ] Style with color/border  

---

# 🟦 EPIC 3: Predictions

## Story 1: Next Expected Period Date  
**As a user, I want to see my next expected period date so I can plan ahead.**  
**Story Points: 3**

### Acceptance Criteria
- Prediction calculated  
- Card shown on UI  
- Updates on changes  

### Tasks
- [ ] Compute in AppState  
- [ ] Show on Home screen  
- [ ] Handle missing data  

---

## Story 2: Estimate Using Past Cycles  
**As a user, I want predictions based on my past cycle lengths so it feels personalised.**  
**Story Points: 2**

### Acceptance Criteria
- Past cycles used  
- Average calculated  
- Works with 1–2 logs  

### Tasks
- [ ] Extract cycle lengths  
- [ ] Compute average  
- [ ] Integrate into prediction  

---

## Story 3: Highlight Predicted Dates on Calendar  
**As a user, I want predicted dates highlighted differently so I don’t confuse them with real logs.**  
**Story Points: 2**

### Acceptance Criteria
- Different color for prediction  
- Legend/explanation  
- Updates automatically  

### Tasks
- [ ] Add highlight rule  
- [ ] Style predicted date  
- [ ] Add legend UI  

---

## Story 4: Auto-Update Predictions  
**As a user, I want predictions to update whenever I edit my cycle data.**  
**Story Points: 1**

### Acceptance Criteria
- Predictions refresh instantly  
- No stale values  

### Tasks
- [ ] Trigger recompute on change  
- [ ] Ensure UI rebuild  

---

# 🟪 EPIC 4: Analysis

## Story 1: Average Cycle Length  
**As a user, I want to see my average cycle length so I understand my pattern.**  
**Story Points: 2**

### Acceptance Criteria
- Accurate average  
- Updates automatically  

### Tasks
- [ ] Compute cycle lengths  
- [ ] Compute average  
- [ ] Display in UI  

---

## Story 2: Average Period Length  
**As a user, I want to see my average period duration.**  
**Story Points: 2**

### Acceptance Criteria
- Accurate calculation  
- Updates on changes  

### Tasks
- [ ] Calculate period duration  
- [ ] Compute average  
- [ ] Update UI  

---

## Story 3: Last Cycle Summary  
**As a user, I want last cycle details in one simple card.**  
**Story Points: 1**

### Acceptance Criteria
- Start/end date  
- Duration  
- Easy to read  

### Tasks
- [ ] Extract last cycle  
- [ ] Render UI card  

---

## Story 4: Regular vs Irregular Indicator  
**As a user, I want to know if my cycles are regular or irregular.**  
**Story Points: 3**

### Acceptance Criteria
- Variation calculated  
- Green/orange indicator  
- Simple explanation  

### Tasks
- [ ] Compare cycle lengths  
- [ ] Decide irregular threshold  
- [ ] Add color-coded UI  

---

# 🟧 EPIC 5: Profile

## Story 1: Update Age  
**As a user, I want to update my age so my profile stays accurate.**  
**Story Points: 1**

### Acceptance Criteria
- Age saved  
- Shows in profile  

### Tasks
- [ ] Age input  
- [ ] Save to AppState  
- [ ] Save to Hive  

---

## Story 2: Dark Mode Toggle  
**As a user, I want to switch to dark mode so the app is comfortable for my eyes.**  
**Story Points: 3**

### Acceptance Criteria
- Theme changes instantly  
- Persists after restart  

### Tasks
- [ ] Add toggle  
- [ ] Update MaterialApp themeMode  
- [ ] Save theme in AppState/Hive  

---

# 3. ROADMAP

### 🟢 MVP (v0.1.0)
- Period logging (start/end)
- Calendar with highlights
- Basic prediction
- Basic analysis
- Profile: age + dark mode

### 🔵 v1.0 — Polished App
- Better UI
- Edit end date
- History page
- Improved predictions
- Basic charts

### 🟣 v2.0 — Advanced App
- Mood tracking
- Symptoms tracking
- Reminders/notifications
- Multiple themes
- Onboarding flow

---

# END OF DOCUMENT
