# Taxiway — Complete UI/UX Design Instructions

**Version:** 1.0  
**Purpose:** Figma / UI design implementation guide  
**Applies to:** Customer Mobile App, Driver Mobile App, Admin Web Dashboard  
**Design language:** Modern, premium, simple, trustworthy, map-first, Indian mobility product

---

# 1. Design Objective

Taxiway must feel extremely easy to understand.

The product should not look like a feature-heavy Uber/Ola clone. The visual experience should communicate:

- Simple booking
- Clear pricing
- Verified drivers
- Actual vehicle visibility
- Reliable tracking
- Easy bulk booking
- Very simple driver operations

The core customer experience should visually communicate:

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

The UI should always prioritize the next important action instead of showing many competing options.

---

# 2. Brand Personality

The interface should feel:

- Premium
- Trustworthy
- Safe
- Fast
- Modern
- Friendly
- Clean
- Practical
- Easy for Indian users
- Technology-driven without feeling complicated

Avoid:

- Excessive gradients
- Neon colors
- Heavy shadows
- Too many colors
- Over-rounded components
- Crowded dashboards
- Too much content on one mobile screen
- Decorative elements that do not help the user
- Unnecessary bottom navigation in the Customer App
- Wallet/reward/offers UI in V1

---

# 3. Primary Design System

## 3.1 Colors

```text
Primary Orange       #F97316
Primary Dark         #EA580C
Primary Darker       #C2410C
Primary Light        #FFEDD5
Primary Background   #FFF7ED

Navy / Heading       #0F172A
Navy Secondary       #1E293B
Body Text            #475569
Muted Text           #94A3B8

App Background       #F8FAFC
Surface              #F1F5F9
Card                 #FFFFFF
Border               #E2E8F0
Border Strong        #CBD5E1

Success              #16A34A
Success Background   #DCFCE7

Warning              #F59E0B
Warning Background   #FEF3C7

Error                #DC2626
Error Background     #FEE2E2

Information          #2563EB
Information Light    #DBEAFE
```

## 3.2 Color Usage

Use orange for:

- Primary CTA
- Selected vehicle
- Active input/focus
- Main route line
- Important highlights
- Active tab
- Booking confirmation action
- Subscription renewal action

Use navy for:

- Headings
- Important labels
- Driver/vehicle information
- Desktop sidebar

Use green only for positive/verified/live states:

- Verified Driver
- Active subscription
- Ride completed
- Driver available
- Successful payment

Use red only for destructive/error actions:

- Cancel Ride
- Failed payment
- Invalid OTP
- Suspended status

---

# 4. Typography

## Primary Font

**Inter**

Use Inter throughout Customer App, Driver App and Admin Panel.

If Hindi localization is required:

**Noto Sans Devanagari**

Maintain the same hierarchy between English and Hindi versions.

## Typography Scale

```text
Display
48 / 56
Bold 700

H1 / Page Heading
28 / 36
Bold 700

H2 / Section Heading
20 / 28
Bold 700

H3 / Card Heading
16 / 24
SemiBold 600

Body Large
16 / 24
Regular 400

Body
14 / 20
Regular 400

Label
14 / 20
Medium 500

Caption
12 / 16
Regular 400

Button
15 / 20
SemiBold 600

Price
24 / 32
Bold 700
```

## Driver App Typography

The Driver App should use slightly larger labels than the Customer App.

Prefer:

- 18–22 px for primary section labels
- 16 px minimum for important ride information
- 24–32 px for ride quota / money / key numbers

Do not use tiny text for operational information.

---

# 5. Spacing

Use an 8-point spacing system.

```text
4px    XS
8px    SM
12px   Small
16px   Medium
20px   Large
24px   XL
32px   2XL
40px   3XL
48px   4XL
64px   5XL
```

Most commonly used:

```text
8
12
16
24
32
```

---

# 6. Border Radius

```text
Small        8px
Medium       12px
Large        16px
XL           20px
Pill         999px
```

Recommended:

```text
Buttons        12px
Inputs         12px
Cards          16px
Bottom Sheets  20px
Badges         999px
```

Do not make every component extremely rounded.

---

# 7. Shadows

Keep shadows subtle.

Standard card:

```css
0 2px 8px rgba(15, 23, 42, 0.06)
```

Elevated card / bottom sheet:

```css
0 8px 24px rgba(15, 23, 42, 0.08)
```

Avoid large dark shadows.

---

# 8. Mobile Frame

Primary Figma frame:

**390 × 844**

Recommended:

```text
Horizontal Padding: 20px
Usable Content Width: 350px
```

Use safe-area spacing for status bar and bottom gesture area.

---

# 9. Desktop Admin Frame

Primary Figma frame:

**1440 × 1024**

Recommended:

```text
Sidebar: 240px
Content Padding: 32px
Grid Gap: 24px
```

---

# 10. Icon System

Use:

**Lucide Icons**

Recommended icon sizes:

```text
Primary icon      24px
Secondary icon    20px
Inline icon       16px
```

Use consistent 2px stroke.

Do not mix:

- Filled icon sets
- Cartoon icons
- 3D icons
- Multiple icon families

---

# 11. Buttons

## Primary

```text
Background: #F97316
Text: #FFFFFF
Height: 52px
Radius: 12px
Font: Inter SemiBold 600
```

Examples:

- Book Ride
- Confirm Booking
- Verify & Continue
- Submit Request
- Renew Subscription

## Secondary

```text
Background: #FFF7ED
Text: #EA580C
Border: #FED7AA
Height: 52px
Radius: 12px
```

## Outline

```text
Background: #FFFFFF
Border: #E2E8F0
Text: #0F172A
Height: 52px
Radius: 12px
```

## Destructive

```text
Background: #FFFFFF or #DC2626
Border: #FECACA
Text: #DC2626
```

Use destructive filled style only for important confirmed destructive actions.

---

# 12. Inputs

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

Input types:

- Phone
- OTP
- Location
- Search
- Date
- Time
- Number
- Text area

---

# 13. Status Badges

## Verified / Active / Completed

```text
Background: #DCFCE7
Text: #16A34A
```

## Pending

```text
Background: #FEF3C7
Text: #D97706
```

## Cancelled / Error / Expired

```text
Background: #FEE2E2
Text: #DC2626
```

Use status text together with color.

---

# 14. Customer App Navigation Philosophy

The Customer App should **not** have a large bottom navigation bar in the main booking experience.

Main screen:

- Logo/brand
- Profile/menu icon
- Map
- From
- To
- Vehicle selection
- Fare
- Book Ride
- Bulk Booking entry

Secondary content belongs inside the profile/menu icon:

- My Trips
- Help & Support
- Terms & Conditions
- Privacy Policy
- Logout

The booking screen should feel like one continuous flow.

---

# 15. Customer Splash / Onboarding

## Layout

Top/middle:

- Taxiway logo
- Orange vehicle/location illustration

Copy:

**Safe. Reliable. Anytime.**

Supporting text:

**Your journey starts with Taxiway.**

Bottom:

- Primary: **Get Started**
- Secondary: **Login**

Use the same orange/white palette as the booking UI.

Avoid making onboarding visually unrelated to the main product.

---

# 16. Phone Login Screen

Layout order:

1. Back icon
2. Illustration or minimal brand visual
3. Heading: **Welcome!**
4. Supporting copy
5. Phone input
6. Terms/privacy copy
7. Continue button

Phone input:

```text
🇮🇳 +91 | Enter mobile number
```

Keep this page very clean.

---

# 17. OTP Screen

Layout:

1. Back icon
2. Small verification illustration
3. Heading: **Verify your number**
4. Masked phone number
5. Six OTP boxes
6. Countdown
7. Verify button
8. Resend OTP

OTP cells:

- Equal width
- 12px radius
- Active cell orange border
- Large centered digit

---

# 18. Customer Home / Book Ride — Most Important Screen

This screen must be the strongest screen in the product.

## Screen Order

```text
Header
↓
Map
↓
Pickup / Destination Card
↓
Distance / Time
↓
Vehicle Selection
↓
Fare Summary
↓
Book Ride
↓
Bulk Booking Entry
```

No wallet.
No rewards.
No promotional carousel.
No unnecessary profile widgets.

---

# 19. Customer Header

Left:

**Taxiway**

Use:

- Ride in dark navy/black
- Go in orange

Right:

Profile/menu icon inside a subtle circular surface.

Optional safety icon may appear only where operationally required.

Do not overload header.

---

# 20. Home Map

The map is a major visual element.

Recommended height:

**220–300px** depending on screen content.

Map style:

- Light minimal base map
- Light gray roads
- White/light buildings
- Muted labels
- Minimal POI clutter

Markers:

```text
Pickup        Green
Destination   Orange
Driver        Dark vehicle marker
```

Route:

- Orange line
- 4–6px
- Rounded endpoints

Before destination:

Show current location.

After pickup + destination:

Show complete route.

---

# 21. Location Card

Create one combined route card.

Example:

```text
●  From
   Mithapur, Patna

│

●  To
   Patna Junction, Patna
```

Use:

- Green pickup dot
- Orange destination marker
- Subtle vertical dotted/solid connector
- Large readable location text
- Recenter icon beside pickup
- Swap route icon if needed

Below:

```text
Distance       Est. Time
12.6 km        24 min
```

---

# 22. Vehicle Selection Cards

Vehicle cards should be visual and easy to scan.

Each card:

- Vehicle image
- Seat icon + capacity
- Vehicle category
- Estimated fare
- Estimated arrival if available
- Radio/check selected indicator

Examples:

```text
3 Seater
₹280

7 Seater
₹450

8 Seater
₹650

12 Seater
₹900
```

Selected vehicle:

```text
Border: #F97316
Background: subtle #FFF7ED
```

Cards can scroll horizontally.

Do not display too much technical information here.

---

# 23. Fare Card

Use a soft orange-tinted card.

Show:

```text
Estimated Fare                  ₹280

Base Fare      Distance Fare     Time Fare
₹120           ₹160              ₹0
```

Footer note:

**Tolls & parking may apply separately.**

The final fare must visually stand out.

---

# 24. Book Ride CTA

Use a full-width primary orange CTA.

Example:

**Book Ride — ₹280**

The CTA should be immediately visible after fare information.

---

# 25. Bulk Booking Entry

Show a secondary card after the normal Book Ride button.

Example:

**Bulk Booking**

*Book multiple vehicles for a group or scheduled trip.*

Use a small group/vehicle/calendar icon.

The visual treatment should be clearly separate from instant ride booking without introducing a different brand theme.

Use orange as primary system color. A soft lavender accent may be used only as a secondary identifier if desired, but it must still feel part of Taxiway.

---

# 26. Booking Confirmation

Use a clean summary.

Order:

1. Page title
2. Small route summary
3. Vehicle
4. Distance
5. Time
6. Fare
7. Confirm CTA

Example:

```text
Confirm your ride

Mithapur
   ↓
Patna Junction

3 Seater
12.6 km
24 min

Estimated Fare
₹280

[ Confirm Booking — ₹280 ]
```

Avoid duplicating everything from Home.

---

# 27. Finding Driver / Allocation Screen

Map should remain visible.

Overlay/bottom sheet:

**Finding a suitable driver...**

Use subtle motion:

- Pulsing pickup radius
- Searching indicator
- Animated car markers only if tasteful

Do not use a large full-screen spinner.

---

# 28. Booking Confirmed Screen

Design this screen around trust.

Top:

**Your ride is confirmed!**

Green check.

Then:

Driver card.

Driver card:

- Photo
- Name
- Rating
- Verified Driver badge
- Call icon
- Optional message icon

Vehicle:

- Small actual vehicle image
- Model
- Registration

Status:

```text
Driver is on the way
2.4 km away
Arriving in 6 min
```

Map follows immediately.

Bottom:

- View Driver Profile
- Call Driver
- Cancel Ride

Use a small info card:

**Driver may call you. Please keep your phone reachable.**

---

# 29. Driver & Vehicle Profile Overview

This customer-facing profile should be one of Taxiway's most premium screens.

## Top Profile Card

Use dark navy surface:

```text
Amit Kumar
Verified Driver
Online

★ 4.8
230 Trips
98% Completion
2+ Years Experience
```

Driver photo large enough to recognize.

## Vehicle Card

Show actual allocated vehicle.

```text
White Swift Dzire
BR01PA1234

Sedan
3 Seater
AC
Petrol
Non-Smoking
GPS
```

Use clean small feature chips.

---

# 30. Vehicle Gallery

Critical trust feature.

Gallery preview categories:

- Exterior
- Interior
- Dashboard
- Boot Space

Use actual-looking photography style.

Images:

```text
Exterior: 16:9
Interior: 4:3
Driver Photo: 1:1
```

Video thumbnails:

- Play icon
- Duration

Example:

```text
Exterior [▶ 1:02]
Interior
Dashboard
Boot Space
```

CTA:

**View All**

---

# 31. Full Vehicle Gallery

Tabs:

**Photos | Videos**

Use grid layout.

Photos should cover:

- Front
- Rear
- Left side
- Right side
- Seats
- Dashboard
- AC controls
- Passenger cabin
- Boot

Video:

- Vehicle walkaround
- Interior walkthrough

Use full-screen media viewer on tap.

---

# 32. Customer Reviews UI

Show:

- Rating average
- Rating distribution
- Total reviews

Example:

```text
4.8
★★★★★

5★ █████████ 78%
4★ ██        16%
3★           4%
2★           1%
1★           1%
```

Review card:

- Small reviewer avatar
- Reviewer name
- Rating
- Review age/date
- Comment
- Optional vehicle/customer photo thumbnail

Keep review cards concise.

---

# 33. Live Tracking Screen

Recommended screen hierarchy:

```text
Header
↓
Map 55–65%
↓
Status Bottom Sheet
```

Map should show:

- Pickup
- Driver
- Destination
- Orange route
- Live movement

Bottom sheet:

```text
Driver is on the way
Arriving in 6 min

Amit Kumar
★4.8
White Swift Dzire
BR01PA1234

[ Call ] [ View Profile ]
```

Actions:

- Share Trip
- Cancel Ride

During ride:

Replace status with:

```text
Enjoy your ride
Distance left
Time left
Arrival time
```

---

# 34. Ride Completed Screen

Use a positive confirmation state.

Top:

Green success area.

**Ride Completed**

Show:

- Total Paid
- Payment method
- Payment status

Then rating.

Use large stars.

Quick tags:

- Clean Car
- Safe Driving
- Polite
- On Time
- Comfortable

Primary CTA:

**Submit Review**

---

# 35. Trip History

Simple list.

Tabs:

- All
- Completed
- Cancelled
- Upcoming

Trip card:

- Route thumbnail/map
- Pickup
- Destination
- Date/time
- Fare
- Status

Do not add excessive metadata.

---

# 36. Profile / Menu

Profile/menu should be simple.

Show:

- Name
- Phone
- Optional avatar

Menu:

- My Trips
- Help & Support
- Terms & Conditions
- Privacy Policy
- Logout

Avoid a large dashboard-style profile.

---

# 37. Bulk Booking Design System

Bulk Booking shares the same Taxiway visual system.

Do not make it look like a separate product.

Use:

- Same typography
- Same orange CTA
- Same inputs
- Same cards
- Same background
- Same radius

Optional secondary identifier:

- Very subtle lavender/purple label/background for bulk-specific informational cards

Never replace Taxiway orange as primary CTA color.

---

# 38. Bulk Booking Step 1

Page title:

**Bulk Booking**

Tabs only if needed:

**One Way | Round Trip**

Fields:

- From
- To
- Journey Date
- Journey Time
- Number of Vehicles
- Approx. Passengers

Number controls:

Use large minus / number / plus controls.

Primary:

**Continue**

---

# 39. Bulk Booking Step 2

Heading:

**Additional Requirements**

Use selectable chips/cards:

- AC
- Non-AC
- Luggage Space
- Driver with Uniform
- Toll Included
- Music System

Notes textarea:

**Any special requests...**

Contact person:

- Name
- Phone

Primary:

**Continue**

---

# 40. Bulk Booking Review

Use one clean summary card.

Sections:

- Route
- Date & Time
- Vehicles
- Passengers
- Vehicle preference
- Requirements
- Contact person

Fare:

**Estimated Fare Range**

Example:

**₹4,500 – ₹5,400**

Use a note:

**Final fare may vary after vehicle confirmation.**

CTA:

**Submit Request**

---

# 41. Bulk Request Submitted

Use celebratory but professional confirmation.

Center illustration/check.

**Your bulk booking request has been submitted!**

Then:

```text
Request ID
Date
Status: Under Review
```

Info message:

**We will notify you when suitable vehicles and drivers are available.**

CTA:

**View My Request**

---

# 42. Bulk Offers Screen

Header:

**Offers Received**

Show trip summary first.

Then vertically stacked offer cards.

Each offer:

- Driver photo
- Driver name
- Rating
- Verified badge
- Vehicle type
- Capacity
- AC
- Fare
- View Profile
- Select

If one combined offer covers multiple vehicles, show summary first and allow drill-down.

---

# 43. Bulk Offer Details

Show:

- Driver
- Vehicle
- Capacity
- Features
- Actual vehicle photo
- Included charges
- Total fare

Included list:

```text
✓ Driver Allowance
✓ Fuel Charges
✓ Toll Tax
✓ Parking Charges
```

CTA:

**Confirm Booking**

---

# 44. Driver App — Core Principle

The Driver App must be simpler than the Customer App.

Assume users may have:

- Low digital literacy
- Limited English
- Limited patience for complex flows

The app should be understandable without training.

Only two primary areas:

```text
Rides
Subscription
```

No complex drawer.
No analytics charts.
No wallet tab.
No settings tab.
No vehicle management.
No document management in V1.
No ride marketplace.

---

# 45. Driver App Theme

The Driver App must visually match the Customer App.

Use:

- Same orange
- Same white background
- Same navy headings
- Same Inter font
- Same 16px card radius
- Same 12px button radius
- Same icon family

Do **not** use a green theme as primary branding.

Green should be used only for:

- Verified
- Active
- Completed

---

# 46. Driver Login

Very simple.

```text
Driver Login

+91 | Mobile Number

[ Continue ]
```

OTP screen follows.

If unverified:

```text
Verification Pending

Please complete verification at the Taxiway office.

[ Contact Support ]
```

---

# 47. Driver Dashboard

Keep to one short screen.

## Header

```text
Driver Dashboard
Amit Kumar
✓ Verified Driver
```

Small avatar.

## Subscription Card

Soft orange surface.

```text
Current Plan

₹500 / month
20 Rides Included

████████░░░░

12 Rides Used
8 Rides Remaining

Renewal Date: 18 Sep 2026
```

The numbers **₹500**, **12**, and **8** should be visually dominant.

## Next Ride Card

```text
Next Ride

26 AUG
09:30 AM

Mithapur, Patna
      ↓
Patna Junction, Patna

Customer: Rahul
3 Seater
₹850

[ View Ride Details ]
```

Optional:

**Call Customer**

## Bottom Navigation

Only:

```text
Rides        Subscription
```

---

# 48. Driver My Rides

Tabs:

```text
Upcoming | Completed
```

Use large date cards.

Example:

```text
26
AUG

09:30 AM
Mithapur, Patna
Patna Junction, Patna

₹850
Upcoming
```

Do not add filters beyond what is necessary.

---

# 49. Driver Ride Details

Show only:

- Date
- Time
- Pickup
- Destination
- Customer
- Vehicle
- Fare
- Payment status

Primary action:

**Call Customer**

Secondary:

**Open Map**

If operationally required:

**Mark Completed**

---

# 50. Driver Subscription & Payments

This should be the second main screen.

## Plan Card

```text
Current Plan
₹500 / month
20 Rides Included

12 / 20 Rides Used
8 Rides Remaining

Valid Until
18 Sep 2026
```

## Payment Summary

Use four simple metric cards:

```text
₹18,600
This Month Collected

12
Completed Rides

₹2,450
Today Collected

₹850
Pending Payment
```

## Payment / Subscription History

```text
Last Payment       ₹500
Paid On            18 Aug 2026
Next Renewal       18 Sep 2026
Payment Method     UPI
```

CTA:

**Renew Subscription**

No graph.

---

# 51. Admin Dashboard Style

Admin should look like a professional SaaS product, not a stretched mobile app.

Use:

- Dark navy sidebar
- White cards
- Light gray background
- Orange primary CTA
- Restrained rounded corners
- Dense but readable tables
- Strong filters

Sidebar:

```text
Dashboard
Customers
Drivers
Vehicles
Vehicle Categories
Pricing
Bookings
Bulk Bookings
Driver Allocation
Live Map
Subscriptions
Payments
Reviews
Reports
Support
Settings
```

---

# 52. Admin Dashboard Layout

Header area:

- Page title
- Search if needed
- Admin profile

KPI cards:

- Total Customers
- Active Drivers
- Today's Bookings
- Active Rides
- Bulk Requests
- Renewals Due
- Revenue

Then:

- Booking trend
- Recent bookings
- Pending driver verification
- Bulk requests
- Subscription alerts
- Map preview

Use cards only where useful.

---

# 53. Admin Tables

Standard table:

- White surface
- 16px radius outer container
- 48–56px row height
- 14px body
- Sticky header when useful
- Light separators

Use:

- Search
- Filter button
- Status dropdown
- Date range
- Pagination

Avoid showing 15+ columns at once.

Use detail pages for deeper information.

---

# 54. Admin Driver Details

Design with tabs/cards:

```text
Overview
Verification
Vehicle
Subscription
Ride History
```

Top driver summary:

- Photo
- Name
- Phone
- Rating
- Verification
- Subscription status

Verification should use clean rows:

```text
Identity Verification   Verified
Driving Licence         Verified
Background Check        Verified
```

---

# 55. Admin Vehicle Media Manager

Use gallery-based layout.

Cards:

- Thumbnail
- Category
- Media type
- Approval status
- Uploaded date
- More menu

Filters:

- Exterior
- Interior
- Dashboard
- Boot
- Video
- Pending Approval

Allow preview in modal.

---

# 56. Admin Booking Details

Recommended layout:

Left main column:

- Route map
- Pickup/destination
- Booking timeline
- Fare breakdown

Right summary column:

- Customer
- Driver
- Vehicle
- Payment
- Actions

Keep important actions sticky if needed.

---

# 57. Admin Driver Allocation

Use split layout.

Left:

Booking request summary.

Right:

Candidate drivers.

Candidate card:

```text
Amit Kumar
2.4 km away
★ 4.8
7 Seater
Subscription Active
8 rides remaining

[ Assign ]
```

Use green only for eligible status.

Expired/ineligible candidates should be visually muted with reason.

---

# 58. Admin Live Map

Map occupies most screen.

Left or right filter panel:

- Active
- En Route
- Arrived
- In Progress

Click vehicle marker opens compact detail drawer.

Drawer:

- Driver
- Customer
- Booking ID
- Route
- Status
- Last update

---

# 59. Responsive Design

## Mobile

Prioritize:

- Single-column layout
- Bottom sheets
- Full-width CTA
- Large cards
- Vertical scroll

## Tablet

Allow:

- Larger maps
- Two-column information where helpful

## Admin Desktop

Optimize at:

1440 width.

Support smaller laptop widths without horizontal overflow on core pages.

---

# 60. Figma File Structure

Recommended:

```text
Taxiway
│
├── 00 — Cover
├── 01 — Design System
├── 02 — Customer App
├── 03 — Bulk Booking
├── 04 — Driver App
├── 05 — Admin Dashboard
├── 06 — Components
├── 07 — Prototype Flow
└── 08 — Assets
```

---

# 61. Figma Component Structure

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
│   ├── Search
│   ├── Location
│   ├── Date
│   └── Time
│
├── Cards
│   ├── Vehicle
│   ├── Driver
│   ├── Ride
│   ├── Fare
│   ├── Subscription
│   ├── Payment
│   ├── Bulk Request
│   └── Offer
│
├── Map
│   ├── Pickup Marker
│   ├── Destination Marker
│   ├── Driver Marker
│   └── Route
│
├── Status
│   ├── Verified
│   ├── Active
│   ├── Pending
│   ├── Upcoming
│   ├── Completed
│   ├── Cancelled
│   └── Expired
│
├── Navigation
│   ├── Customer Header
│   ├── Driver Bottom Nav
│   └── Admin Sidebar
│
└── Feedback
    ├── Toast
    ├── Alert
    ├── Modal
    ├── Empty State
    └── Loading State
```

---

# 62. Figma Naming Convention

Use names like:

```text
Button/Primary/Default
Button/Primary/Pressed
Button/Primary/Disabled

Card/Vehicle/Default
Card/Vehicle/Selected

Card/Driver/Compact
Card/Driver/Full

Status/Verified
Status/Upcoming
Status/Completed

Input/Location/Default
Input/Location/Focused

Map/Marker/Pickup
Map/Marker/Destination
Map/Marker/Driver
```

---

# 63. Auto Layout

Use Auto Layout for almost everything.

Recommended:

- Page sections: vertical Auto Layout
- Cards: vertical Auto Layout
- Rows: horizontal Auto Layout
- Button groups: horizontal/vertical Auto Layout
- Vehicle carousel: horizontal Auto Layout
- Chips: horizontal wrap

Avoid absolute-positioning except:

- Map markers
- Special overlays
- Media overlays
- Decorative illustration layers

---

# 64. Prototype Interaction Rules

Use:

- Smart Animate sparingly
- 200–300ms transitions
- Bottom sheets for contextual details
- Slide-in right drawer for Admin detail previews
- Fade for success state
- Map transitions should not be excessively animated

Examples:

```text
Home → Destination Search
Destination → Home with route
Book Ride → Finding Driver
Finding Driver → Driver Assigned
Driver Assigned → Driver Profile
Driver Assigned → Live Tracking
Live Tracking → Ride Completed
```

---

# 65. Loading States

Use skeleton loaders.

Examples:

- Vehicle cards loading
- Driver card loading
- Map loading
- Bulk offers loading

For driver allocation:

Use descriptive state instead of generic spinner:

**Finding a suitable driver...**

---

# 66. Empty States

Examples:

```text
No upcoming rides
Your next assigned ride will appear here.
```

```text
No trip history yet
Your completed rides will appear here.
```

```text
No offers yet
We're arranging vehicles for your request.
```

Keep illustration small.

---

# 67. Error States

Use simple messages.

Example:

**We couldn't load your ride details.**

CTA:

**Try Again**

Avoid:

- API codes
- Technical descriptions
- Stack traces

---

# 68. Accessibility

- Touch target: minimum ~44px
- Strong contrast
- Do not use only color to communicate status
- Buttons must use text labels
- Driver UI must use very clear typography
- Avoid tiny captions for critical information
- Maintain readable map controls
- Provide semantic labels for icons
- Use number keypad for phone/OTP
- Use native date/time picker where practical

---

# 69. Image Direction

Vehicle photography:

- Clean realistic images
- White/light backgrounds for vehicle selection
- Real customer vehicle photos in profile/gallery
- Avoid stock-watermarked imagery

Driver photo:

- Square 1:1
- Neutral background preferred
- Friendly/professional
- Clear face

Vehicle gallery:

- Real exterior and interior
- Consistent aspect ratio
- Rounded 12–16px

---

# 70. Map Direction

Maps should feel professional and integrated.

Do not use overly bright default map styling.

Recommended:

- Light roads
- Muted labels
- Few POIs
- Orange route
- Green pickup
- Orange destination
- Dark vehicle marker

During tracking:

The route should remain the visual focus.

---

# 71. Mobile Screen Presentation

For stakeholder presentation, create polished mockup boards.

Recommended:

- 3 mobile screens per board for core journeys
- 2 screens per board for simple Driver App
- 4–6 screens per board for flow overview
- Consistent device frame
- Light neutral presentation background
- Screen title below each frame
- Avoid excessive annotations inside presentation boards

Example board:

```text
01 Home / Book Ride
02 Booking Confirmed
03 Live Tracking
```

Second board:

```text
04 Driver & Vehicle Profile
05 Vehicle Gallery
06 Ride Completed
```

---

# 72. Driver Presentation Board

Show only 2 core screens:

```text
01 Driver Dashboard
02 Subscription & Payments
```

Optional third board:

```text
03 My Rides
04 Ride Details
```

The driver design should visibly look simpler than the Customer App while still using the same Taxiway theme.

---

# 73. Customer Screen Checklist

Design these screens:

```text
01 Splash / Onboarding
02 Phone Login
03 OTP Verification
04 Minimal Profile Setup
05 Home / Book Ride
06 Pickup Location
07 Destination Search
08 Vehicle Selection
09 Booking Confirmation
10 Finding Driver
11 Booking Confirmed
12 Driver & Vehicle Profile
13 Vehicle Gallery
14 Full Driver Profile & Reviews
15 Live Tracking
16 Driver Arrived
17 Ride In Progress
18 Ride Completed / Payment
19 Rating & Review
20 Trip History
21 Trip Details
22 Simple Profile / Menu
23 Help & Support
```

---

# 74. Bulk Booking Screen Checklist

```text
01 Bulk Booking Entry
02 Trip + Capacity
03 Additional Requirements
04 Review Request
05 Request Submitted
06 Request Details / Waiting
07 Offers Received
08 Offer Details
09 Booking Confirmed
```

---

# 75. Driver Screen Checklist

```text
01 Driver Login
02 OTP
03 Verification Pending
04 Driver Dashboard
05 My Rides
06 Ride Details
07 Subscription & Payments
```

---

# 76. Admin Screen Checklist

```text
01 Login
02 Dashboard
03 Customers
04 Customer Details
05 Drivers
06 Driver Details / KYC
07 Vehicles
08 Vehicle Details & Media
09 Vehicle Categories
10 Pricing
11 Bookings
12 Booking Details
13 Driver Allocation
14 Live Map
15 Bulk Bookings
16 Bulk Booking Details
17 Bulk Offer Builder
18 Subscriptions
19 Payments
20 Reviews
21 Reports
22 Support
23 Settings
```

---

# 77. Final Design Rules

Always remember:

1. **Customer Home is map-first and booking-first.**
2. **Do not add unnecessary navigation to Customer Home.**
3. **Vehicle capacity must be immediately understandable.**
4. **Price must always be visually clear.**
5. **Driver trust is a core feature, not a secondary feature.**
6. **Actual vehicle photos and videos are important.**
7. **Tracking must feel visually professional.**
8. **Bulk Booking must feel connected to the same product.**
9. **Driver App must be extremely simple.**
10. **Driver App primary theme remains Taxiway orange, not green.**
11. **Green is only for verified/active/success states.**
12. **Admin handles complexity.**
13. **Use one consistent design system across all surfaces.**
14. **Avoid feature clutter.**
15. **Every screen should make the next action obvious.**

---

# 78. Final Visual Direction

The final Taxiway UI should look like a modern Indian mobility startup product with:

- White and soft gray backgrounds
- Strong orange CTAs
- Dark navy typography
- Clean Inter typography
- Minimal light maps
- Real vehicle imagery
- Professional driver cards
- Moderate rounded corners
- Subtle shadows
- Clear fare cards
- Clear status badges
- Easy-to-scan ride information
- Very little visual clutter

The final design should communicate:

> **Simple to book. Easy to trust. Easy to track. Easy to operate.**
