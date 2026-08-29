# Cab Booking App — Complete UI Design System

> **Product:** Cab / Vehicle Booking Platform
> **Design goal:** Modern, premium, trustworthy, simple, and highly usable mobility app
> **Primary platforms:** Customer Mobile App, Driver Mobile App, Admin Web Dashboard
> **Recommended design approach:** High-fidelity UI prototype first, development later
>
> The underlying product structure is a three-role system: Customer, Driver, and Admin, with booking, driver allocation, vehicle pricing, and real-time ride tracking as the core experience. 

---

# 1. Brand Direction

## Design Personality

The interface should feel:

* Premium
* Trustworthy
* Fast
* Safe
* Modern
* Friendly
* Technology-driven
* Easy to understand
* Suitable for Indian users

### Avoid

* Excessive gradients
* Too many colors
* Excessive shadows
* Overly rounded interfaces
* Complicated navigation
* Too much information on one screen
* Neon colors

---

# 2. Primary Color Palette

## Primary Brand — Orange

| Token         | HEX       | Usage                       |
| ------------- | --------- | --------------------------- |
| `Primary/500` | `#F97316` | Main buttons, active states |
| `Primary/600` | `#EA580C` | Button pressed/hover        |
| `Primary/700` | `#C2410C` | Dark orange                 |
| `Primary/100` | `#FFEDD5` | Light backgrounds           |
| `Primary/50`  | `#FFF7ED` | Subtle orange background    |

### Primary color usage

Use `#F97316` for:

* Book Ride
* Confirm Booking
* Select Vehicle
* Active navigation
* Important CTAs
* Selected vehicle
* Progress indicators
* Important highlights

---

# 3. Dark Navy Palette

Use navy to balance the orange.

| Token      | HEX       | Usage                 |
| ---------- | --------- | --------------------- |
| `Navy/900` | `#0F172A` | Main headings         |
| `Navy/800` | `#1E293B` | Navigation            |
| `Navy/700` | `#334155` | Strong secondary text |
| `Navy/600` | `#475569` | Body text             |
| `Navy/500` | `#64748B` | Secondary text        |
| `Navy/400` | `#94A3B8` | Muted text            |

### Important

Your primary text should generally be:

`#0F172A`

rather than pure black `#000000`.

This will make the app feel softer and more premium.

---

# 4. Neutral Palette

| Token         | HEX       | Usage              |
| ------------- | --------- | ------------------ |
| `White`       | `#FFFFFF` | Cards, surfaces    |
| `Background`  | `#F8FAFC` | App background     |
| `Surface/50`  | `#F1F5F9` | Secondary surfaces |
| `Border`      | `#E2E8F0` | Borders/dividers   |
| `Border/Dark` | `#CBD5E1` | Strong borders     |

### Main application background

`#F8FAFC`

### Cards

`#FFFFFF`

This gives you:

```text
App Background
#F8FAFC

       ┌─────────────────────┐
       │       CARD          │
       │      #FFFFFF        │
       └─────────────────────┘
```

---

# 5. Status Colors

## Success

```text
Success 500: #16A34A
Success 100: #DCFCE7
```

Use for:

* Driver online
* Ride completed
* Payment successful
* Available vehicle
* Verified driver

---

## Warning

```text
Warning 500: #F59E0B
Warning 100: #FEF3C7
```

Use for:

* Driver arriving
* Pending verification
* Waiting
* Payment pending

---

## Error

```text
Error 500: #DC2626
Error 100: #FEE2E2
```

Use for:

* Cancellation
* Failed payment
* Invalid OTP
* Error messages

---

## Information

```text
Info 500: #2563EB
Info 100: #DBEAFE
```

Use for:

* Information messages
* Navigation indicators
* Informational alerts

---

# 6. Complete Color Tokens

```text
BRAND
────────────────────────

Primary 50      #FFF7ED
Primary 100     #FFEDD5
Primary 500     #F97316
Primary 600     #EA580C
Primary 700     #C2410C


NAVY
────────────────────────

Navy 900        #0F172A
Navy 800        #1E293B
Navy 700        #334155
Navy 600        #475569
Navy 500        #64748B
Navy 400        #94A3B8


NEUTRAL
────────────────────────

White           #FFFFFF
Background      #F8FAFC
Surface         #F1F5F9
Border          #E2E8F0
Border Strong   #CBD5E1


STATUS
────────────────────────

Success         #16A34A
Success Light   #DCFCE7

Warning         #F59E0B
Warning Light   #FEF3C7

Error           #DC2626
Error Light     #FEE2E2

Info            #2563EB
Info Light      #DBEAFE
```

---

# 7. Typography

## Primary Font

# **Inter**

Use **Inter** throughout the entire product.

Why:

* Excellent mobile readability
* Professional
* Modern
* Works extremely well with numbers/prices
* Excellent for dashboards
* Supports a large range of weights
* Good developer availability

---

# 8. Font Weights

Use only these weights:

```text
Regular       400
Medium        500
SemiBold      600
Bold          700
```

Avoid using too many font weights.

---

# 9. Typography Scale

## Display

```text
Display Large
48px / 56px
Weight: 700
```

Use rarely.

---

## Page Heading

```text
Heading 1
28px / 36px
Weight: 700
```

Example:

**Where are you going?**

---

## Section Heading

```text
Heading 2
20px / 28px
Weight: 700
```

Example:

**Choose your vehicle**

---

## Card Heading

```text
Heading 3
16px / 24px
Weight: 600
```

Example:

**Maruti Suzuki Ertiga**

---

## Body Large

```text
16px / 24px
Weight: 400
```

---

## Body

```text
14px / 20px
Weight: 400
```

---

## Caption

```text
12px / 16px
Weight: 400
```

---

## Button

```text
15px / 20px
Weight: 600
```

---

## Price

```text
24px / 32px
Weight: 700
```

Example:

**₹850**

---

# 10. Recommended Font System

```text
Font Family
Inter


Display
48 / 56 — Bold 700

H1
28 / 36 — Bold 700

H2
20 / 28 — Bold 700

H3
16 / 24 — SemiBold 600

Body Large
16 / 24 — Regular 400

Body
14 / 20 — Regular 400

Label
14 / 20 — Medium 500

Caption
12 / 16 — Regular 400

Button
15 / 20 — SemiBold 600

Price
24 / 32 — Bold 700
```

---

# 11. Hindi / English Typography

If you eventually support Hindi:

```text
English:
Inter

Hindi:
Noto Sans Devanagari
```

Use the same visual hierarchy between the two fonts.

Example:

**Book a Ride**

**राइड बुक करें**

---

# 12. Spacing System

Use an **8-point spacing system**.

```text
4px     XS
8px     SM
12px    Small
16px    MD
20px    LG
24px    XL
32px    2XL
40px    3XL
48px    4XL
64px    5XL
```

### Most frequently used

```text
8px
12px
16px
24px
32px
```

---

# 13. Border Radius

Use moderately rounded components.

```text
Small       8px
Medium      12px
Large       16px
XL          20px
Pill        999px
```

### Recommended

Buttons:

**12px**

Cards:

**16px**

Input fields:

**12px**

Status badges:

**999px**

---

# 14. Shadows

Keep shadows subtle.

### Card

```text
0 2px 8px rgba(15, 23, 42, 0.06)
```

### Elevated card

```text
0 8px 24px rgba(15, 23, 42, 0.08)
```

Don't use heavy black shadows.

---

# 15. Buttons

## Primary Button

```text
Background: #F97316
Text: #FFFFFF
Radius: 12px
Height: 52px
Font: Inter SemiBold 600
```

Example:

**Book Ride**

---

## Secondary Button

```text
Background: #FFF7ED
Text: #EA580C
Border: #FED7AA
Radius: 12px
Height: 52px
```

---

## Outline Button

```text
Background: #FFFFFF
Border: #E2E8F0
Text: #0F172A
Radius: 12px
Height: 52px
```

---

## Destructive Button

```text
Background: #DC2626
Text: #FFFFFF
Radius: 12px
Height: 52px
```

---

# 16. Input Fields

Standard input:

```text
Height: 52px
Radius: 12px
Background: #FFFFFF
Border: #E2E8F0
Text: #0F172A
Placeholder: #94A3B8
```

Focus:

```text
Border: #F97316
```

---

# 17. Location Input

This should become one of the signature components of the app.

```text
┌────────────────────────────────────┐
│ ●  Current Location                │
│    Mithapur, Bihar                 │
└────────────────────────────────────┘

                ↓

┌────────────────────────────────────┐
│ ○  Where to?                       │
│    Enter destination               │
└────────────────────────────────────┘
```

Use:

* Orange location indicator
* Navy text
* Gray secondary text

---

# 18. Vehicle Cards

Vehicle cards are one of the most important UI components.

```text
┌──────────────────────────────────────┐
│                                      │
│  🚗                                  │
│                                      │
│  Sedan                    ₹596       │
│  4 Seats • ₹14/km                    │
│                                      │
│  Estimated fare                      │
│                                      │
│                        Select →      │
└──────────────────────────────────────┘
```

### Selected vehicle

```text
Border: #F97316
Background: #FFF7ED
```

---

# 19. Driver Card

```text
┌──────────────────────────────────────┐
│  [PHOTO]  Amit Kumar           ⭐4.8 │
│           Professional Driver        │
│                                      │
│  🚗 Maruti Suzuki Ertiga             │
│  BR-XX-XXXX                          │
│                                      │
│  245 Trips       98% Positive        │
└──────────────────────────────────────┘
```

The driver profile should be highly visible because trust is extremely important in transportation.

The original PRD specifically calls for driver photo, vehicle information, vehicle photos, ratings/reviews, and ride information. 

---

# 20. Live Tracking UI

The map should occupy approximately:

**65–75% of the screen**

Bottom sheet:

```text
┌────────────────────────────────────┐
│ ─────                              │
│                                    │
│ Driver arriving                    │
│                                    │
│ [PHOTO] Amit Kumar       ⭐ 4.8     │
│         Maruti Ertiga              │
│         BR-XX-XXXX                 │
│                                    │
│ ETA                 6 min          │
│                                    │
│ [ Call ]       [ Message ]         │
└────────────────────────────────────┘
```

The live tracking flow is central to the product and should show driver location, route, ETA, and driver details. 

---

# 21. Map Style

Use a **light, minimal map style**.

Avoid a visually noisy map.

Recommended:

* Light gray roads
* White buildings
* Muted land
* Orange destination/pickup marker
* Dark vehicle marker
* Orange route

### Route

```text
Pickup ●━━━━━━━━━━━━🚗━━━━━━● Destination
```

Primary route:

`#F97316`

---

# 22. Navigation

## Customer Bottom Navigation

Use 4 items:

```text
Home
Trips
Notifications
Profile
```

Active:

```text
Icon: #F97316
Text: #F97316
```

Inactive:

```text
Icon: #94A3B8
Text: #64748B
```

---

# 23. Driver Navigation

Driver interface should be simpler:

```text
Home
Trips
Earnings
Profile
```

The driver home should prioritize availability and current booking because drivers need to interact with it quickly. 

---

# 24. Status Badges

### Online

```text
Background: #DCFCE7
Text: #16A34A
```

**● Online**

### Pending

```text
Background: #FEF3C7
Text: #D97706
```

**Pending**

### Completed

```text
Background: #DCFCE7
Text: #16A34A
```

**Completed**

### Cancelled

```text
Background: #FEE2E2
Text: #DC2626
```

**Cancelled**

---

# 25. Icon Style

Use **Lucide Icons** or another clean outline icon set.

Recommended:

* 24px primary icons
* 20px secondary icons
* 16px inline icons

Use consistent stroke width:

**2px**

Avoid mixing:

* Filled icons
* 3D icons
* Cartoon icons
* Different icon families

---

# 26. Images

Vehicle images:

**16:9**

Driver profile:

**1:1**

Vehicle gallery:

**4:3**

Use rounded corners:

**12–16px**

---

# 27. Customer Home Design

Recommended hierarchy:

```text
┌─────────────────────────────────────┐
│  👤  Hi, Rahul              🔔      │
│                                     │
│  Good evening                       │
│                                     │
│  Where are you going?               │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 📍 Current Location           │  │
│  │    Mithapur                   │  │
│  ├───────────────────────────────┤  │
│  │ 🔎 Enter destination          │  │
│  │    Where to?                  │  │
│  └───────────────────────────────┘  │
│                                     │
│  [       Search Vehicles        ]   │
│                                     │
│  Recent                              │
│                                     │
│  🏠 Home             →               │
│  💼 Work             →               │
│                                     │
│  Recent Trips                       │
│  ┌───────────────────────────────┐  │
│  │ Patna → Mithapur      ₹850     │  │
│  │ Completed                     │  │
│  └───────────────────────────────┘  │
│                                     │
│ Home   Trips   🔔   Profile         │
└─────────────────────────────────────┘
```

---

# 28. Booking Confirmation Design

Use a clean summary rather than showing too much information.

```text
Confirm your ride

Mithapur
   ↓
Patna

SUV
6 Seats

52 km
1h 20m

Estimated Fare

₹850

[ Confirm Booking — ₹850 ]
```

The booking confirmation screen in the PRD is intentionally centered around trip, vehicle, distance, estimated time, and fare. 

---

# 29. Rating UI

Use large interactive stars:

```text
How was your ride?

        ★ ★ ★ ★ ★

Amit Kumar

[ Good Driver ]
[ Clean Vehicle ]
[ Safe Driving ]
[ On Time ]
[ Friendly ]

┌──────────────────────────────┐
│ Tell us about your experience│
└──────────────────────────────┘

[ Submit Review ]
```

Selected tags:

```text
Background: #FFF7ED
Border: #F97316
Text: #EA580C
```

---

# 30. Admin Dashboard Design

For the admin panel, switch from the mobile rounded-card style to a more professional SaaS dashboard.

### Layout

```text
┌──────────────┬────────────────────────────────────────┐
│              │                                        │
│   LOGO       │ Dashboard                              │
│              │                                        │
│ Dashboard    │ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ │
│ Customers    │ │Users │ │Driver│ │Rides │ │Revenue│ │
│ Drivers      │ └──────┘ └──────┘ └──────┘ └──────┘ │
│ Vehicles     │                                        │
│ Bookings     │ ┌──────────────────────────────────┐ │
│ Pricing      │ │                                  │ │
│ Live Map     │ │       Revenue / Ride Chart       │ │
│ Reviews      │ │                                  │ │
│ Reports      │ └──────────────────────────────────┘ │
│ Settings     │                                        │
│              │ Recent Bookings                       │
└──────────────┴────────────────────────────────────────┘
```

Admin functionality includes users, drivers, vehicles, pricing, bookings, driver allocation, active rides, reviews, revenue, and analytics. 

---

# 31. Admin Color Usage

Admin should be more restrained.

```text
Sidebar:
#0F172A

Main background:
#F8FAFC

Cards:
#FFFFFF

Primary action:
#F97316

Text:
#0F172A

Secondary:
#64748B
```

This keeps the admin panel professional and makes the orange actions stand out.

---

# 32. Design Grid

## Mobile

Use:

```text
Frame:
390 × 844

Horizontal padding:
20px

Content width:
350px
```

Recommended:

```text
Left: 20px
Right: 20px
```

---

## Admin

```text
Frame:
1440 × 1024

Sidebar:
240px

Content padding:
32px

Grid gap:
24px
```

The existing PRD recommends 390 × 844 for the mobile prototype and 1440 × 1024 for the admin dashboard. 

---

# 33. Component Naming in Figma

Create a small design system first.

```text
Components
│
├── Buttons
│   ├── Primary
│   ├── Secondary
│   ├── Outline
│   └── Destructive
│
├── Inputs
│   ├── Text
│   ├── Phone
│   ├── OTP
│   ├── Location
│   └── Search
│
├── Cards
│   ├── Vehicle
│   ├── Driver
│   ├── Trip
│   └── Booking
│
├── Navigation
│   ├── Bottom Navigation
│   ├── Header
│   └── Sidebar
│
├── Map
│   ├── Pickup Marker
│   ├── Driver Marker
│   └── Destination Marker
│
├── Status
│   ├── Online
│   ├── Pending
│   ├── Completed
│   └── Cancelled
│
└── Feedback
    ├── Toast
    ├── Alert
    └── Modal
```

---

# 34. Figma Pages

Create the Figma project like this:

```text
📁 CAB BOOKING APP

01 — Design System
02 — Customer App
03 — Driver App
04 — Admin Dashboard
05 — Prototype Flow
06 — Components
07 — Assets
```

---

# 35. Customer Screen List

Your customer prototype should contain:

```text
01 Splash
02 Phone Login
03 OTP
04 Profile Setup
05 Home
06 Pickup Location
07 Destination
08 Vehicle Selection
09 Confirm Booking
10 Finding Driver
11 Driver Assigned
12 Driver Profile
13 Live Tracking
14 Driver Arrived
15 Ride Started
16 Ride Completed
17 Rating
18 Trip History
19 Trip Details
20 Profile
```

These screens follow the original PRD's customer flow. 

---

# 36. Driver Screen List

```text
01 Driver Login
02 Driver Profile
03 Driver Home
04 Booking Request
05 Pickup Navigation
06 Driver Arrived
07 Ride Started
08 Ride In Progress
09 Ride Completed
10 Earnings
11 Driver Profile
12 Documents
```

---

# 37. Admin Screen List

```text
01 Login
02 Dashboard
03 Customers
04 Customer Details
05 Drivers
06 Driver Details
07 Vehicles
08 Vehicle Categories
09 Pricing
10 Bookings
11 Booking Details
12 Driver Allocation
13 Live Map
14 Reviews
15 Reports
16 Settings
```

---

# 38. Core Design Principle

The most important part of this app is **not the number of screens**.

The core experience should feel like:

```text
LOCATION
   ↓
VEHICLE
   ↓
PRICE
   ↓
BOOK
   ↓
DRIVER
   ↓
TRACK
   ↓
RIDE
   ↓
REVIEW
```

The primary customer flow in the PRD follows exactly this sequence from phone login through pickup/destination, vehicle selection, driver assignment, live tracking, ride completion, payment, rating, and trip history. 

---

# 39. Final Recommended Stack for the Design

```text
DESIGN TOOL
Figma

FONT
Inter

PRIMARY
#F97316

PRIMARY DARK
#EA580C

DARK
#0F172A

BACKGROUND
#F8FAFC

CARD
#FFFFFF

BODY TEXT
#475569

MUTED
#94A3B8

BORDER
#E2E8F0

SUCCESS
#16A34A

WARNING
#F59E0B

ERROR
#DC2626

INFO
#2563EB

ICON SET
Lucide

MOBILE
390 × 844

ADMIN
1440 × 1024

GRID
8px

BUTTON RADIUS
12px

CARD RADIUS
16px

INPUT RADIUS
12px
```

This gives you a **complete visual foundation** before you start generating the actual screens. It also keeps the design system consistent across the Customer, Driver, and Admin interfaces rather than letting each screen develop a different visual style.
