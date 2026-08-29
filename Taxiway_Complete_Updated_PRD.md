# Taxiway --- Complete Product Requirements Document (PRD)

**Version:** 2.0\
**Status:** Updated Product Specification\
**Platforms:** Customer Mobile App, Driver Mobile App, Admin Web Panel\
**Primary Market:** India\
**Design Direction:** Simple, map-first, high-trust ride booking with an
orange/white visual system\
**Document Purpose:** Product, UI/UX, engineering, QA, and operations
reference

------------------------------------------------------------------------

## 1. Product Summary

Taxiway is a simple cab and multi-vehicle booking platform designed
around one core promise:

> **Choose where you want to go, choose the right vehicle, see the
> price, book, get a verified driver, track the ride, and travel.**

The product intentionally avoids the feature overload found in large
ride-hailing applications. The customer application should feel simple
enough that a first-time user can understand the booking flow
immediately. The driver application must be even simpler because many
drivers may have limited comfort with complex mobile interfaces.
Operational complexity should live primarily in the Admin Panel.

Taxiway has three primary product surfaces:

1.  **Customer App** --- individual ride booking, bulk booking,
    tracking, driver/vehicle trust information, trip history, payment
    and reviews.
2.  **Driver App** --- OTP login, assigned/upcoming rides, ride details,
    subscription status, ride quota, payment/collection summary.
3.  **Admin Panel** --- customers, drivers, KYC, vehicles, media,
    bookings, bulk requests, allocation, pricing, subscriptions,
    payments, live rides, reviews, reports and settings.

------------------------------------------------------------------------

# 2. Product Principles

## 2.1 Customer Experience

The customer experience should follow:

``` text
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
PAY / COMPLETE
   ↓
REVIEW
```

The home page should not be filled with wallets, rewards, promotional
banners, complex navigation or unrelated features.

## 2.2 Driver Experience

The driver experience should follow:

``` text
PHONE NUMBER
   ↓
OTP
   ↓
DASHBOARD
   ↓
NEXT / UPCOMING RIDES
   ↓
RIDE DETAILS
```

and:

``` text
DASHBOARD
   ↓
SUBSCRIPTION & PAYMENT
```

The driver does **not** need a complex marketplace interface. Driver KYC
is completed offline or through operations/admin before the account is
activated.

## 2.3 Admin Experience

The Admin Panel is where operational complexity belongs. Admin users
should be able to verify drivers, assign vehicles, manage media,
configure pricing and subscription plans, allocate bookings, process
bulk booking requests and monitor the complete marketplace.

------------------------------------------------------------------------

# 3. User Roles

## 3.1 Customer

A customer can:

-   Login using phone number and OTP.
-   Select pickup and destination.
-   See route, distance and estimated duration.
-   Select a vehicle by capacity.
-   View estimated fare.
-   Book a ride.
-   Receive driver allocation.
-   Call the driver.
-   View the driver's verified profile.
-   View actual vehicle photos and videos.
-   View vehicle features.
-   View customer ratings/reviews.
-   Track the driver/ride on a map.
-   Share trip details.
-   Cancel a ride where allowed.
-   View completed/cancelled/upcoming trips.
-   View trip details and payment status.
-   Rate/review the driver and vehicle.
-   Submit a bulk booking request.
-   Review and confirm a bulk booking offer.

## 3.2 Driver

A driver can:

-   Login using registered phone number and OTP.
-   See verification/account status.
-   See current subscription.
-   See rides used and rides remaining.
-   See renewal date.
-   See next assigned ride.
-   See upcoming/completed rides.
-   View essential ride details.
-   Call the customer.
-   Open navigation/map when required.
-   See collections/payment summary.
-   Renew subscription.

The driver should not be expected to perform complex KYC/document
management inside the application in V1.

## 3.3 Admin / Operations

Admin users can:

-   Manage customers.
-   Manage drivers.
-   Approve/reject/suspend drivers.
-   Manage offline KYC records.
-   Manage vehicles.
-   Assign vehicles to drivers.
-   Manage vehicle categories and capacities.
-   Upload/approve vehicle photos and videos.
-   Configure pricing.
-   Manage normal bookings.
-   Allocate drivers.
-   Manage bulk booking requests.
-   Create/send bulk offers.
-   Manage driver subscription plans.
-   Record subscription payments.
-   Monitor rides on a live map.
-   Manage reviews.
-   Handle cancellations/support issues.
-   View reports and analytics.
-   Configure platform settings.

------------------------------------------------------------------------

# 4. Customer App --- Information Architecture

The customer app should remain intentionally small.

``` text
Splash
  ↓
Phone Login
  ↓
OTP
  ↓
Home / Book Ride
  ├── Pickup Search
  ├── Destination Search
  ├── Vehicle Selection
  ├── Fare
  └── Book Ride
       ↓
Booking Processing
       ↓
Driver Assigned
       ├── Driver & Vehicle Profile
       │    ├── Vehicle Gallery
       │    └── Reviews
       ↓
Live Tracking
       ↓
Ride Completion
       ↓
Rating / Review

Home
  └── Bulk Booking
       ├── Trip Requirements
       ├── Additional Requirements
       ├── Review Request
       ├── Request Submitted
       ├── Offers Received
       └── Offer Details / Confirm

Profile/Menu
  ├── My Trips
  ├── Help & Support
  ├── Terms & Conditions
  ├── Privacy Policy
  └── Logout
```

------------------------------------------------------------------------

# 5. Customer Screen 01 --- Splash / Onboarding

## Purpose

Introduce the Taxiway brand and move the user into authentication.

## UI

-   Taxiway logo.
-   Brand illustration using the same orange/white design system as the
    main app.
-   Tagline: **Safe. Reliable. Anytime.**
-   Short supporting line such as: **Your journey starts with Taxiway.**
-   Primary CTA: **Get Started**
-   Secondary CTA: **Login**
-   App version may appear subtly at the bottom.

## Behaviour

-   Existing authenticated users may bypass authentication and open
    Home.
-   New/logged-out users continue to Phone Login.

------------------------------------------------------------------------

# 6. Customer Screen 02 --- Phone Login

## Purpose

Authenticate using a familiar low-friction phone flow.

## UI

**Heading:** Welcome!

**Supporting text:** Enter your phone number to continue.

Input:

``` text
🇮🇳 +91 | Enter mobile number
```

Primary CTA:

**Continue**

Footer:

**By continuing, you agree to our Terms & Conditions and Privacy
Policy.**

## Validation

-   India country code defaults to +91.
-   Mobile number must contain the valid required number of digits.
-   Continue remains disabled for invalid input.
-   API/network error should show a clear retry message.

------------------------------------------------------------------------

# 7. Customer Screen 03 --- OTP Verification

## Purpose

Verify ownership of the entered phone number.

## UI

**Verify your number**

Text:

**We've sent a 6-digit OTP to +91 XXXXX XXXXX**

Six OTP cells.

Primary CTA:

**Verify & Continue**

Secondary:

**Resend OTP**

Countdown:

**Resend in 00:30**

## Behaviour

-   Auto-focus next OTP cell.
-   Allow paste/autofill where supported.
-   On success, existing customer opens Home.
-   New customer may be asked only for the minimum required name
    information before Home.
-   Avoid a large profile setup process during onboarding.

------------------------------------------------------------------------

# 8. Customer Screen 04 --- Minimal First-Time Setup

## Purpose

Collect only essential information if needed.

## Fields

-   Full Name --- required.
-   Email --- optional.
-   Profile photo --- optional.

Primary CTA:

**Continue**

## Rule

This screen should be skipped if the business does not need these fields
before the first booking.

------------------------------------------------------------------------

# 9. Customer Screen 05 --- Home / Search & Book

## Purpose

This is the core customer screen. Most booking work should happen here
without unnecessary navigation.

## Header

-   Taxiway logo/name.
-   Small profile/menu icon on the top right.
-   No heavy bottom navigation is required.

## Map Section

A prominent Google Maps/Mapbox-style map should occupy the upper portion
of the booking experience.

Map states:

1.  Current location only.
2.  Pickup selected.
3.  Pickup + destination selected.
4.  Route polyline displayed.
5.  During active booking, driver marker can be displayed.

Map elements:

-   Pickup marker --- green.
-   Destination marker --- orange.
-   Route line.
-   Current location.
-   Recenter/current-location button.

## Route Card

### From

**Current Location / Search Pickup**

### To

**Enter Destination**

Optional swap icon.

After both are selected, show:

-   Distance.
-   Estimated travel time.

Example:

``` text
Distance: 12.6 km
Est. Time: 24 min
```

## Vehicle Section

Heading:

**Select Vehicle**

Vehicle cards can horizontally scroll.

Example categories:

  Vehicle                     Capacity Example Use
  ----------------------- ------------ ------------------
  Hatchback / Small Car       3 Seater Short/local ride
  SUV                         7 Seater Family/group
  Traveller                   8 Seater Group travel
  Tempo Traveller           12+ Seater Large group

Each card includes:

-   Vehicle image.
-   Seat count.
-   Vehicle/category name.
-   Estimated fare.
-   Optional approximate availability/ETA.
-   Selected state.

## Fare Section

After vehicle selection:

**Estimated Fare**

Example:

``` text
Base Fare       ₹120
Distance Fare   ₹160
Time Fare       ₹0
--------------------
Estimated Total ₹280
```

Small note:

**Tolls and parking may apply separately. Final fare may vary where
applicable.**

## Primary CTA

**Book Ride --- ₹280**

## Secondary Entry

A visually separated card:

**Bulk Booking**\
*Book multiple vehicles for a group or scheduled requirement.*

------------------------------------------------------------------------

# 10. Customer Screen 06 --- Pickup Location Search

## Purpose

Select exact pickup location.

## Options

-   Use current location.
-   Search by address/place.
-   Select from search results.
-   Move map pin.
-   Recenter map.

## UI

Search input:

**Search pickup location**

Map with pin.

Primary CTA:

**Confirm Pickup**

## Data Saved

-   Latitude.
-   Longitude.
-   Formatted address.
-   Optional landmark.

------------------------------------------------------------------------

# 11. Customer Screen 07 --- Destination Search

## Purpose

Select destination.

## UI

Search:

**Where do you want to go?**

Search results can show:

-   Place name.
-   Area/city.
-   Distance from current/pickup area where available.

## Behaviour

On destination selection:

-   Draw route.
-   Calculate distance.
-   Calculate estimated travel time.
-   Return user to booking flow.
-   Refresh vehicle/fare estimates.

------------------------------------------------------------------------

# 12. Customer Screen 08 --- Vehicle Selection Details

This may appear as part of Home or as an expanded sheet/page.

## Vehicle Card Data

-   Vehicle category.
-   Seat capacity.
-   Representative vehicle image.
-   AC/Non-AC where category-specific.
-   Estimated fare.
-   Approximate pickup availability where supported.
-   Selected indicator.

## Business Rule

The customer chooses a **category/capacity**, not necessarily the exact
vehicle before allocation. The exact driver and vehicle become visible
after allocation.

------------------------------------------------------------------------

# 13. Customer Screen 09 --- Booking Review / Confirm

## Purpose

Prevent accidental booking and clearly show the request.

## Display

-   Pickup.
-   Destination.
-   Route map preview.
-   Distance.
-   Estimated time.
-   Selected vehicle category.
-   Seat capacity.
-   Estimated fare.
-   Toll/parking note.
-   Payment method if required at booking time.

Primary CTA:

**Confirm Booking**

Secondary:

**Change Vehicle**

------------------------------------------------------------------------

# 14. Customer Screen 10 --- Booking Processing / Finding Driver

## Purpose

Show that the booking request is being processed.

## UI

-   Route summary.
-   Selected vehicle.
-   Estimated fare.
-   Animated but lightweight loading state.

Messages:

**Finding a suitable driver...**

or, for an admin-allocation model:

**Your booking is being assigned.**

## Actions

-   Cancel request, if cancellation is allowed before allocation.
-   Help/support link only if necessary.

------------------------------------------------------------------------

# 15. Customer Screen 11 --- Booking Confirmed / Driver Assigned

## Purpose

Tell the customer that a real driver and vehicle have been allocated.

## Confirmation

**Your ride is confirmed!**

**Driver has been allocated.**

## Driver Card

-   Driver photo.
-   Driver name.
-   Rating.
-   Number of trips.
-   Verified badge.
-   Call icon.
-   Optional message icon.

Example:

``` text
Amit Kumar
★ 4.8 (230 trips)
Verified Driver
```

## Vehicle

``` text
White Swift Dzire
BR01PA1234
AC
3 Seater
```

## Driver ETA

**Driver is on the way**

**2.4 km away**

**Arriving in 6 min**

## Actions

-   **Call Driver**
-   **View Driver & Vehicle**
-   **Cancel Ride** if policy permits.

## Customer Guidance

Show a small note:

**Driver may call you. Please keep your phone reachable.**

------------------------------------------------------------------------

# 16. Customer Screen 12 --- Driver & Vehicle Profile Overview

## Purpose

Build trust and allow the customer to visually inspect the allocated
vehicle.

## Driver Summary

-   Profile photo.
-   Full name.
-   Verified Driver badge.
-   Online/assigned state.
-   Rating.
-   Total trips.
-   Completion rate.
-   Years of experience.

Example:

``` text
Amit Kumar
Verified Driver
★ 4.8
230 Trips
98% Completion
2+ Years Experience
```

## Verification

-   Identity Verified.
-   Driving Licence Verified.
-   Background Checked.

Do not expose sensitive document numbers.

## Vehicle Summary

-   Vehicle image.
-   Make/model.
-   Registration number.
-   Category.
-   Seat capacity.
-   AC/Non-AC.
-   Fuel type where useful.
-   Non-smoking.
-   GPS.
-   Luggage/boot information where available.

## Vehicle Gallery Preview

Show 3--4 media thumbnails:

-   Exterior.
-   Interior.
-   Dashboard.
-   Boot/Luggage Space.

CTA:

**View All Photos & Videos**

## Reviews Preview

-   Average rating.
-   Latest/high-quality customer reviews.
-   Optional review image thumbnail.

CTA:

**View All Reviews**

## Bottom Actions

-   Message, if messaging is implemented.
-   **Call Driver**

------------------------------------------------------------------------

# 17. Customer Screen 13 --- Vehicle Gallery

## Purpose

Show the customer the actual allocated vehicle visually.

## Tabs

-   **Photos**
-   **Videos**

## Media Categories

### Exterior

-   Front.
-   Rear.
-   Left side.
-   Right side.

### Interior

-   Front seats.
-   Rear seats.
-   Full passenger cabin.
-   Seat condition.

### Dashboard

-   Dashboard.
-   AC controls.
-   Music/infotainment where relevant.

### Storage

-   Boot/luggage space.

## Video

Short vehicle walkaround or interior video.

## Media Rules

-   Media is attached to the specific vehicle record.
-   Admin can approve/remove media.
-   Media should have upload date and moderation status internally.
-   Customer should see only approved media.
-   Do not expose unrelated personal information visible in uploads.

------------------------------------------------------------------------

# 18. Customer Screen 14 --- Full Driver Profile & Reviews

## Purpose

Provide deeper trust information.

## About Driver

-   Name.
-   Photo.
-   Languages.
-   Operating city/area.
-   Member since.
-   Experience.
-   Rating.
-   Total trips.

## Verification

-   Identity Verified.
-   Driving Licence Verified.
-   Background Check status.

## Rating Distribution

Example:

``` text
5★ 78%
4★ 16%
3★  4%
2★  1%
1★  1%
```

## Reviews

Each review can show:

-   Customer first name/display name.
-   Rating.
-   Date/relative date.
-   Comment.
-   Optional approved photo.

## Privacy

Never expose: - Home address. - Licence number. - Government ID
number. - Personal documents.

------------------------------------------------------------------------

# 19. Customer Screen 15 --- Live Tracking / Driver En Route

## Purpose

Show the driver approaching pickup.

## Map

-   Pickup marker.
-   Destination marker where useful.
-   Driver car marker.
-   Route polyline.
-   Driver movement updates.

## Status Card

**En route to pickup**

Display:

-   Distance to pickup.
-   ETA.
-   Arrival time estimate.

## Driver Mini Card

-   Driver photo.
-   Name.
-   Rating.
-   Vehicle.
-   Registration.
-   Call.
-   View profile.

## Actions

-   **Share Trip**
-   **Cancel Ride**, subject to policy.

------------------------------------------------------------------------

# 20. Customer Screen 16 --- Driver Arrived

## Purpose

Clearly indicate arrival.

## Status

**Your driver has arrived**

Display:

-   Vehicle model.
-   Registration number.
-   Driver photo/name.
-   Pickup point.

Actions:

-   **Call Driver**
-   **View Vehicle**
-   Optional ride-start verification information.

------------------------------------------------------------------------

# 21. Customer Screen 17 --- Ride Started / Ride In Progress

## Purpose

Show live route during the trip.

## Map

-   Current vehicle location.
-   Destination.
-   Remaining route.

## Ride Status

**Ride in progress**

Display:

-   Distance remaining.
-   Estimated time left.
-   Estimated arrival time.
-   Destination.

## Driver Card

-   Driver name.
-   Vehicle.
-   Call/message where appropriate.

## Safety/Utility

-   **Share Trip**
-   Support/SOS may be included only if the business operationally
    supports it.

------------------------------------------------------------------------

# 22. Customer Screen 18 --- Ride Completed / Payment Summary

## Purpose

Close the ride clearly.

## UI

**Ride Completed**

Trip:

-   Pickup.
-   Destination.
-   Distance.
-   Duration.
-   Driver.
-   Vehicle.

Payment:

-   Total fare.
-   Payment method.
-   Payment status.
-   Additional toll/parking where applicable.

Example:

``` text
Total Paid: ₹850
Payment Method: Cash / UPI
Status: Paid
```

CTA:

**Rate Your Ride**

Secondary:

**View Trip Details**

------------------------------------------------------------------------

# 23. Customer Screen 19 --- Rating & Review

## Purpose

Collect structured quality feedback.

## UI

**How was your ride?**

1--5 stars.

Quick tags:

-   Clean Car.
-   Safe Driving.
-   Polite.
-   On Time.
-   Good AC.
-   Comfortable.

Optional text:

**Write a comment**

Optional:

**Add Photo**

Primary CTA:

**Submit Review**

## Moderation

Photo/text reviews may be moderated before public display.

------------------------------------------------------------------------

# 24. Customer Screen 20 --- Trip History

## Purpose

Show bookings without creating a complex wallet/account area.

## Tabs

-   All.
-   Upcoming.
-   Completed.
-   Cancelled.

## Trip Card

-   Date/time.
-   Pickup.
-   Destination.
-   Fare.
-   Status.
-   Small map/route preview optional.

Tap opens Trip Details.

------------------------------------------------------------------------

# 25. Customer Screen 21 --- Trip Details

## Display

-   Booking ID.
-   Date/time.
-   Pickup.
-   Destination.
-   Map/route preview.
-   Driver.
-   Vehicle.
-   Distance.
-   Duration.
-   Fare breakdown.
-   Payment method.
-   Payment status.
-   Booking status.
-   Rating/review if submitted.

Possible actions:

-   Download/share invoice if invoices are implemented.
-   Contact support for this trip.

------------------------------------------------------------------------

# 26. Customer Screen 22 --- Profile / Simple Menu

## Purpose

Keep account/legal/support items away from the main booking flow.

## Header

-   Customer name.
-   Phone.
-   Optional photo.

## Menu

-   **My Trips**
-   **Help & Support**
-   **Terms & Conditions**
-   **Privacy Policy**
-   **Logout**

Optional only if genuinely needed:

-   Edit Name.
-   Saved Locations.
-   Payment Methods.

Avoid turning this into a feature-heavy profile area.

------------------------------------------------------------------------

# 27. Customer Screen 23 --- Help & Support

## Help Topics

-   How to book a ride.
-   Fare and payment.
-   Cancellation.
-   Driver/vehicle issue.
-   Lost item.
-   Safety.
-   Bulk booking.
-   Other issue.

## Contact

Primary:

**Contact Support**

Support method depends on operations: - Call. - WhatsApp. - In-app
ticket. - Email.

------------------------------------------------------------------------

# 28. Bulk Booking --- Product Definition

Bulk Booking is for customers who need multiple vehicles, larger groups
or a scheduled transport requirement where the exact vehicle/driver
combination may not be known immediately.

Unlike instant booking, the user submits a **requirement**.
Operations/admin reviews availability and later sends a final offer.

Flow:

``` text
Bulk Booking Entry
   ↓
Trip + Date/Time
   ↓
Passengers + Vehicle Requirement
   ↓
Additional Requirements
   ↓
Review
   ↓
Submit Request
   ↓
Admin Processing
   ↓
Offer / Vehicles Available
   ↓
Customer Reviews Drivers/Vehicles
   ↓
Confirm Offer
   ↓
Final Booking
```

------------------------------------------------------------------------

# 29. Bulk Screen 01 --- Bulk Booking Entry

Accessible from Home as a separate card.

Label:

**Bulk Booking**

Supporting text:

**Book multiple vehicles for a group or scheduled trip.**

Tap opens Bulk Booking Step 1.

------------------------------------------------------------------------

# 30. Bulk Screen 02 --- Trip & Capacity Requirements

## Trip Type

Optional: - One Way. - Round Trip.

## Fields

### From

Pickup location.

### To

Destination.

### Journey Date

Date picker.

### Journey Time

Time picker.

### Number of Vehicles

Stepper or numeric input.

### Approximate Passengers

Stepper or numeric input.

Example:

``` text
Journey Date: 20 Sep 2026
Journey Time: 09:00 AM
Vehicles: 3
Passengers: 15
```

## Important Rule

The user does not have to choose exact vehicle models. They can submit
the capacity requirement and let operations propose the best
combination.

Primary CTA:

**Continue**

------------------------------------------------------------------------

# 31. Bulk Screen 03 --- Additional Requirements

## Options

-   AC.
-   Non-AC.
-   Luggage Space.
-   Driver with Uniform.
-   Toll Included.
-   Music System.
-   Other configurable requirements.

## Notes

Text area:

**Any special requests...**

## Contact Person

-   Name.
-   Phone number.

Primary CTA:

**Continue**

------------------------------------------------------------------------

# 32. Bulk Screen 04 --- Review Request

## Summary

-   From.
-   To.
-   Date.
-   Time.
-   Approximate passengers.
-   Number of vehicles.
-   Vehicle preference if any.
-   AC/Non-AC.
-   Luggage requirement.
-   Other requirements.
-   Contact person.

## Price

If a meaningful estimate is possible:

**Estimated Fare Range**

Example:

**₹4,500 -- ₹5,400**

Label clearly:

**Estimated only. Final offer may vary after vehicle confirmation.**

Primary CTA:

**Submit Request**

------------------------------------------------------------------------

# 33. Bulk Screen 05 --- Request Submitted

## UI

Success illustration/check.

**Your bulk booking request has been submitted!**

Message:

**We will notify you when suitable vehicles and drivers are available.**

Display:

-   Request ID.
-   Date.
-   Status: **Pending / Under Review**

Example:

``` text
Request ID: BK20260920001
Date: 20 Sep 2026
Status: Under Review
```

Primary CTA:

**View My Request**

------------------------------------------------------------------------

# 34. Bulk Screen 06 --- Bulk Request Details / Waiting

## Display

-   Request information.
-   Current status.
-   Requirements.
-   Contact person.
-   Timeline.

Statuses:

-   Draft.
-   Submitted.
-   Under Review.
-   Offer Ready.
-   Confirmed.
-   Cancelled.
-   Completed.

If no offer exists:

**We're arranging vehicles for your trip. You'll be notified when an
offer is ready.**

------------------------------------------------------------------------

# 35. Bulk Screen 07 --- Offers Received

## Purpose

Show the proposed vehicle/driver package.

## Header

**Vehicles Available**

Summary:

-   Requested route.
-   Date/time.
-   Number of vehicles.
-   Approximate passenger count.

## Offer Cards

Each allocation/vehicle can show:

-   Driver.
-   Driver rating.
-   Verified badge.
-   Vehicle category.
-   Seat count.
-   AC/Non-AC.
-   Price allocation if applicable.

Actions:

-   **View Profile**
-   **View Vehicle**
-   **Select** if offers are individually selectable.

If the business sends one combined package, show one offer card
containing all vehicles.

------------------------------------------------------------------------

# 36. Bulk Screen 08 --- Offer Details

## Driver/Vehicle List

For each allocated vehicle:

-   Driver photo/name.
-   Verified status.
-   Rating.
-   Vehicle.
-   Registration.
-   Seat capacity.
-   Features.
-   Vehicle gallery link.

## Included Charges

Clearly state whether the offer includes:

-   Driver allowance.
-   Fuel.
-   Toll.
-   Parking.
-   Taxes.
-   Other charges.

## Fare

**Total Fare**

## CTA

**Confirm Booking**

Secondary:

**Contact Support / Request Change**

------------------------------------------------------------------------

# 37. Bulk Screen 09 --- Bulk Booking Confirmed

## Display

**Bulk Booking Confirmed**

-   Booking ID.
-   Route.
-   Date/time.
-   Vehicles confirmed.
-   Total passengers/capacity.
-   Total fare/payment status.

## Vehicle/Driver Cards

Customer can open each assigned driver's profile and vehicle gallery.

------------------------------------------------------------------------

# 38. Driver App --- Product Philosophy

The Driver App must be optimized for simplicity and readability.

Key rules:

-   Large text.
-   Large tap targets.
-   Minimal English or localized Hindi version depending deployment.
-   Very few screens.
-   Only essential information.
-   No complex charts.
-   No unnecessary settings.
-   No marketplace-style ride browsing.
-   No in-app KYC workflow in V1.
-   Operations/admin activates the driver after offline verification.

Primary navigation should contain only:

1.  **Rides**
2.  **Subscription & Payment**

------------------------------------------------------------------------

# 39. Driver Screen 01 --- Phone Login

## UI

**Driver Login**

Input:

``` text
+91 | Mobile Number
```

CTA:

**Continue**

## Rule

Only registered driver numbers should proceed.

If unknown:

**This number is not registered as a driver. Please contact the
office.**

------------------------------------------------------------------------

# 40. Driver Screen 02 --- OTP

## UI

**Verify Mobile Number**

Six-digit OTP.

CTA:

**Login**

Secondary:

**Resend OTP**

------------------------------------------------------------------------

# 41. Driver Screen 03 --- Verification Pending / Account Blocked

Shown when the driver has not completed offline verification or has been
disabled.

## Pending

**Verification Pending**

**Please complete your KYC/verification at the Taxiway office or contact
support.**

Button:

**Call Office / Support**

## Suspended

**Account Temporarily Unavailable**

Show support instruction without exposing internal risk reasons
unnecessarily.

------------------------------------------------------------------------

# 42. Driver Screen 04 --- Driver Dashboard

## Purpose

Give the driver everything important on one short screen.

## Header

**Driver Dashboard**

-   Small driver photo.
-   Driver name.
-   **Verified Driver** status.

## Subscription Card

``` text
Current Plan
₹500 / month
20 Rides Included

12 Rides Used
8 Rides Remaining

Renewal Date: 18 Sep 2026
```

Use a simple progress bar.

## Next Ride

``` text
26 AUG
09:30 AM

Mithapur, Patna
        ↓
Patna Junction, Patna

Customer: Rahul Kumar
3 Seater
Expected Fare: ₹850
```

Primary:

**View Ride Details**

Optional direct action:

**Call Customer**

## Navigation

Bottom:

-   **Rides**
-   **Subscription**

No other main tabs in V1.

------------------------------------------------------------------------

# 43. Driver Screen 05 --- My Rides

## Purpose

Show date-wise assigned rides.

## Tabs

Keep only what drivers need:

-   **Upcoming**
-   **Completed**

Cancelled rides may be shown with a status in history or as an optional
third filter.

## Ride Card

``` text
26 AUG
09:30 AM
Mithapur, Patna
   ↓
Patna Junction, Patna
₹850
Upcoming
```

Optional:

-   Customer first name.
-   Vehicle/capacity.

Tap opens Ride Details.

------------------------------------------------------------------------

# 44. Driver Screen 06 --- Ride Details

## Purpose

Show only actionable ride information.

## Display

-   Date.
-   Time.
-   Customer name.
-   Customer phone action.
-   Pickup.
-   Destination.
-   Vehicle/category.
-   Expected fare.
-   Payment method/status where needed.
-   Ride status.

## Actions

Primary:

**Call Customer**

Secondary:

**Open Map**

Operational button if driver controls ride state:

**Mark Completed**

If ride status is controlled by admin/operations, remove manual status
actions.

------------------------------------------------------------------------

# 45. Driver Screen 07 --- Subscription & Payments

## Current Plan

``` text
₹500 / month
20 Rides Included
12 / 20 Rides Used
8 Rides Remaining
Valid Until: 18 Sep 2026
Status: Active
```

## Payment / Collection Summary

Keep to four large cards or rows:

``` text
₹18,600  This Month Collected
12       Completed Rides
₹2,450   Today Collected
₹850     Pending Payment
```

## Subscription History

-   Last payment.
-   Paid on.
-   Next renewal.
-   Payment method.

Example:

``` text
Last Payment: ₹500
Paid On: 18 Aug 2026
Next Renewal: 18 Sep 2026
Payment Method: UPI
```

Primary CTA:

**Renew Subscription**

------------------------------------------------------------------------

# 46. Driver Subscription Business Rules

## Example Plan

**₹500 / month**

Includes:

**20 rides**

## Rules

-   Admin defines plan price, ride quota and validity.
-   Subscription has start date and expiry/renewal date.
-   Each qualifying completed/allocated ride decrements quota according
    to the final business rule.
-   The exact decrement event must be consistent and auditable.
-   Driver can always see rides used and remaining.
-   When quota is exhausted, admin can require renewal before further
    allocations.
-   Expiry and quota exhaustion are separate states.
-   Admin may manually extend/adjust a plan with audit history.
-   Driver receives renewal reminders.

## Subscription Statuses

-   Active.
-   Expiring Soon.
-   Expired.
-   Quota Exhausted.
-   Payment Pending.
-   Suspended.

------------------------------------------------------------------------

# 47. Admin Panel --- Information Architecture

Recommended sidebar:

``` text
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

------------------------------------------------------------------------

# 48. Admin Screen 01 --- Login

## Fields

-   Email/username.
-   Password.

Optional: - 2FA for privileged admins.

CTA:

**Login**

------------------------------------------------------------------------

# 49. Admin Screen 02 --- Dashboard

## KPI Cards

-   Total Customers.
-   Active Drivers.
-   Verified Drivers.
-   Today's Bookings.
-   Active Rides.
-   Bulk Requests Pending.
-   Subscription Renewals Due.
-   Today's Revenue/Collections.

## Operational Sections

-   Recent bookings.
-   Pending driver verification.
-   Bulk requests needing action.
-   Active ride map preview.
-   Subscription expiry alerts.
-   Payment issues.

## Charts

Keep analytics useful, not decorative:

-   Bookings by day/week/month.
-   Revenue/collections.
-   Completed vs cancelled.
-   Driver utilization.
-   Subscription revenue.

------------------------------------------------------------------------

# 50. Admin Screen 03 --- Customers

## Table

Columns:

-   Customer ID.
-   Name.
-   Phone.
-   Total bookings.
-   Last booking.
-   Status.
-   Created date.

## Filters

-   Active.
-   Blocked.
-   New.
-   Frequent.
-   Date range.

## Actions

-   View.
-   Edit basic profile.
-   Block/unblock where policy allows.
-   View bookings.
-   View support history.

------------------------------------------------------------------------

# 51. Admin Screen 04 --- Customer Details

## Sections

### Profile

-   Name.
-   Phone.
-   Email if available.
-   Account status.
-   Registration date.

### Booking Summary

-   Total bookings.
-   Completed.
-   Cancelled.
-   Bulk requests.

### Booking History

Detailed table.

### Reviews

Reviews submitted by customer.

### Support

Related support cases.

------------------------------------------------------------------------

# 52. Admin Screen 05 --- Drivers

## Table

Columns:

-   Driver ID.
-   Driver name.
-   Phone.
-   Assigned vehicle.
-   Rating.
-   Verification status.
-   Subscription status.
-   Rides remaining.
-   Account status.

## Filters

-   Verified.
-   Pending.
-   Suspended.
-   Subscription active.
-   Expired.
-   Quota exhausted.
-   Vehicle category.
-   City/operating area.

## Actions

-   View.
-   Approve.
-   Reject.
-   Suspend.
-   Activate.
-   Edit.
-   Assign vehicle.
-   Manage subscription.

------------------------------------------------------------------------

# 53. Admin Screen 06 --- Driver Details / KYC

## Profile

-   Driver photo.
-   Name.
-   Phone.
-   Address/internal KYC details as permitted.
-   Languages.
-   Operating area.
-   Member since.

## Verification

-   Identity verification status.
-   Driving licence status.
-   Background check status.
-   Offline KYC completed date.
-   Verified by admin.
-   Notes.

## Documents

Internal admin-only document records may include:

-   Driving licence.
-   Vehicle registration.
-   Insurance.
-   Required local permits.
-   Other required documents.

## Public Profile Preview

Admin can preview what customers will see.

## Subscription

-   Current plan.
-   Start date.
-   Expiry.
-   Rides used.
-   Rides remaining.
-   Payment status.

## Actions

-   Approve/Reject.
-   Suspend/Activate.
-   Assign vehicle.
-   Change subscription.
-   Add subscription payment.
-   Adjust ride quota with reason.

------------------------------------------------------------------------

# 54. Admin Screen 07 --- Vehicles

## Table

-   Vehicle ID.
-   Registration number.
-   Make/model.
-   Category.
-   Seat capacity.
-   AC status.
-   Assigned driver.
-   Verification status.
-   Media count.
-   Active/inactive.

## Actions

-   Add.
-   View.
-   Edit.
-   Assign driver.
-   Manage media.
-   Activate/deactivate.

------------------------------------------------------------------------

# 55. Admin Screen 08 --- Vehicle Details & Media

## Vehicle Information

-   Make.
-   Model.
-   Registration.
-   Category.
-   Seats.
-   AC/Non-AC.
-   Fuel.
-   Color.
-   Luggage capacity.
-   Features.
-   Assigned driver.

## Media Manager

Categories:

-   Exterior.
-   Interior.
-   Dashboard.
-   Boot/Luggage.
-   Videos.

Each media item:

-   Thumbnail.
-   Upload date.
-   Uploaded by.
-   Approval status.
-   Public/private.
-   Delete/reject action.

## Public Preview

Preview the customer-facing Driver & Vehicle Profile.

------------------------------------------------------------------------

# 56. Admin Screen 09 --- Vehicle Categories

Admin configures categories such as:

-   3 Seater.
-   4 Seater.
-   7 Seater.
-   8 Seater Traveller.
-   12 Seater Tempo.
-   Custom categories.

## Fields

-   Category name.
-   Display name.
-   Seat capacity.
-   Representative image.
-   AC options.
-   Active/inactive.
-   Sort order.

------------------------------------------------------------------------

# 57. Admin Screen 10 --- Pricing

## Pricing Rule Fields

-   Vehicle category.
-   Base fare.
-   Per-km rate.
-   Minimum fare.
-   Time charge if used.
-   Waiting charge if used.
-   Night charge if used.
-   Toll handling.
-   Parking handling.
-   Tax handling.
-   Effective date.

## Example

``` text
3 Seater
Base Fare: ₹120
Per KM: configured rate
Minimum Fare: configured amount
```

## Requirement

Every fare calculation should store the pricing snapshot used for that
booking so later pricing changes do not alter historical trips.

------------------------------------------------------------------------

# 58. Admin Screen 11 --- Normal Bookings

## Filters

-   Today.
-   Upcoming.
-   Searching/Unallocated.
-   Driver Assigned.
-   Active.
-   Completed.
-   Cancelled.
-   Payment Pending.

## Columns

-   Booking ID.
-   Customer.
-   Driver.
-   Vehicle.
-   Pickup.
-   Destination.
-   Distance.
-   Fare.
-   Status.
-   Payment.
-   Date/time.

## Actions

-   View.
-   Assign/reassign driver.
-   Cancel.
-   Update status with permissions.
-   Contact customer/driver.
-   Open live map.

------------------------------------------------------------------------

# 59. Admin Screen 12 --- Booking Details

## Sections

### Booking

-   Booking ID.
-   Created time.
-   Scheduled/start time.
-   Current status.

### Customer

-   Name.
-   Phone.

### Route

-   Pickup.
-   Destination.
-   Coordinates.
-   Distance.
-   Estimated duration.
-   Actual duration if available.

### Driver

-   Assigned driver.
-   Driver status.

### Vehicle

-   Category.
-   Exact vehicle.
-   Registration.

### Fare

-   Base.
-   Distance.
-   Extra charges.
-   Toll.
-   Parking.
-   Discount.
-   Final fare.

### Payment

-   Method.
-   Status.
-   Transaction/reference where applicable.

### Status Timeline

-   Created.
-   Allocated.
-   Driver en route.
-   Arrived.
-   Started.
-   Completed/cancelled.

### Actions

Permission controlled: - Assign/reassign. - Cancel. - Correct payment
status. - Contact parties.

------------------------------------------------------------------------

# 60. Admin Screen 13 --- Driver Allocation

## Purpose

Support both automated and manual allocation.

## Automatic Matching Inputs

-   Required vehicle category/capacity.
-   Driver/vehicle availability.
-   Distance from pickup.
-   Existing assigned rides.
-   Driver operating area.
-   Rating.
-   Subscription eligibility.
-   Remaining ride quota.
-   Account verification.

## Manual Allocation

For a booking show:

``` text
Booking #BK10293
Pickup: Mithapur
Destination: Patna Junction
Vehicle: 7 Seater
```

Candidate drivers:

``` text
Amit     2.4 km   Active Subscription   8 rides left
Raj      4.1 km   Active Subscription   5 rides left
Suresh   7.2 km   Expired
```

CTA:

**Assign Driver**

## Rule

An ineligible driver should not be allocated unless an authorized admin
override is recorded.

------------------------------------------------------------------------

# 61. Admin Screen 14 --- Live Map

## Purpose

Monitor active operational activity.

Map markers can represent:

-   Driver en route to pickup.
-   Driver arrived.
-   Ride in progress.

Click marker opens:

-   Driver.
-   Customer.
-   Booking ID.
-   Vehicle.
-   Route.
-   Current status.
-   Last GPS update.

------------------------------------------------------------------------

# 62. Admin Screen 15 --- Bulk Bookings

## Table

Columns:

-   Request ID.
-   Customer.
-   Route.
-   Journey date/time.
-   Passengers.
-   Vehicles requested.
-   Requirements.
-   Status.
-   Offer total.
-   Created date.

## Filters

-   Submitted.
-   Under Review.
-   Offer Ready.
-   Confirmed.
-   Completed.
-   Cancelled.

Actions:

-   View.
-   Build offer.
-   Contact customer.
-   Cancel/close.

------------------------------------------------------------------------

# 63. Admin Screen 16 --- Bulk Booking Details

## Request

-   Customer.
-   Contact person.
-   From.
-   To.
-   Date.
-   Time.
-   Passengers.
-   Number of vehicles.
-   AC/Non-AC.
-   Luggage.
-   Additional requirements.
-   Customer notes.

## Internal Planning

Admin can:

-   Add vehicle allocations.
-   Select drivers.
-   Check conflicts.
-   Add per-vehicle price.
-   Add included/excluded charges.
-   Add internal notes.

## Offer

Admin prepares:

-   Vehicle list.
-   Driver list.
-   Capacity.
-   Total fare.
-   Included charges.
-   Excluded charges.
-   Offer expiry.

CTA:

**Send Offer to Customer**

------------------------------------------------------------------------

# 64. Admin Screen 17 --- Bulk Offer Builder

For each vehicle:

-   Driver.
-   Vehicle.
-   Capacity.
-   AC.
-   Fare component.
-   Availability confirmation.

Global fields:

-   Total fare.
-   Driver allowance included?
-   Fuel included?
-   Toll included?
-   Parking included?
-   Tax included?
-   Offer notes.
-   Offer valid until.

Validation:

-   Total capacity should reasonably cover passenger requirement.
-   Drivers/vehicles must not conflict with other confirmed bookings.
-   All assigned drivers must be eligible.

------------------------------------------------------------------------

# 65. Admin Screen 18 --- Subscriptions

## Plan Management

Fields:

-   Plan name.
-   Price.
-   Ride quota.
-   Validity days.
-   Active/inactive.
-   Description.

Example:

``` text
Basic Driver Plan
₹500
20 rides
30 days
```

## Driver Subscription Table

-   Driver.
-   Plan.
-   Start date.
-   Expiry.
-   Used rides.
-   Remaining rides.
-   Payment status.
-   Subscription status.

## Actions

-   Activate.
-   Renew.
-   Extend.
-   Change plan.
-   Add payment.
-   Adjust quota with reason.

------------------------------------------------------------------------

# 66. Admin Screen 19 --- Payments

## Payment Types

-   Customer ride payments.
-   Driver subscription payments.
-   Bulk booking payments.
-   Refunds/adjustments where supported.

## Table

-   Payment ID.
-   Related booking/subscription.
-   User/driver.
-   Amount.
-   Method.
-   Status.
-   Date.
-   Reference.

## Statuses

-   Pending.
-   Paid.
-   Failed.
-   Refunded.
-   Partially Paid, only if the business supports it.

------------------------------------------------------------------------

# 67. Admin Screen 20 --- Reviews

## Review Queue

-   Customer.
-   Driver.
-   Vehicle.
-   Booking.
-   Rating.
-   Comment.
-   Media.
-   Date.
-   Moderation status.

## Actions

-   Approve media.
-   Hide inappropriate review/media according to policy.
-   View booking.
-   Flag for support.

------------------------------------------------------------------------

# 68. Admin Screen 21 --- Reports

Recommended reports:

-   Bookings by period.
-   Completed rides.
-   Cancellation rate.
-   Revenue/collections.
-   Vehicle-category demand.
-   Driver utilization.
-   Driver ratings.
-   Subscription revenue.
-   Active/expired subscriptions.
-   Ride quota consumption.
-   Bulk booking conversion.
-   Bulk booking revenue.

Export: - CSV/XLSX where required operationally.

------------------------------------------------------------------------

# 69. Admin Screen 22 --- Support / Issues

## Cases

-   Booking issue.
-   Driver issue.
-   Vehicle issue.
-   Payment issue.
-   Cancellation.
-   Lost item.
-   Bulk booking issue.
-   Other.

Case data:

-   Case ID.
-   Customer/driver.
-   Booking.
-   Priority.
-   Status.
-   Assigned admin.
-   Notes.
-   Resolution.

------------------------------------------------------------------------

# 70. Admin Screen 23 --- Settings

## General

-   Brand name/logo.
-   Support contact.
-   Service areas.
-   Default currency.
-   Timezone.

## Booking

-   Cancellation rules.
-   Driver allocation timeout.
-   Booking scheduling rules.
-   Ride status rules.

## Maps

-   Map provider configuration.
-   Geocoding settings.
-   Service boundaries.

## Notifications

-   SMS templates.
-   Push templates.
-   OTP settings.

## Subscription

-   Renewal reminder days.
-   Quota rules.
-   Eligibility behaviour when expired/exhausted.

------------------------------------------------------------------------

# 71. Notification Requirements

## Customer

-   OTP.
-   Booking request submitted.
-   Booking confirmed.
-   Driver assigned.
-   Driver approaching.
-   Driver arrived.
-   Ride started.
-   Ride completed.
-   Cancellation.
-   Payment update.
-   Bulk request submitted.
-   Bulk offer ready.
-   Bulk booking confirmed.

## Driver

Keep notifications minimal:

-   New/updated assigned ride.
-   Ride cancelled.
-   Upcoming ride reminder.
-   Subscription expiring.
-   Subscription expired.
-   Ride quota low/exhausted.
-   Subscription payment confirmed.

## Admin

-   New bulk request.
-   Driver verification pending.
-   Subscription/payment issue.
-   Booking allocation failure.
-   Critical cancellation/support issue.

------------------------------------------------------------------------

# 72. Booking Status Model

Recommended normal booking states:

``` text
draft
requested
allocating
driver_assigned
driver_en_route
driver_arrived
ride_started
ride_in_progress
completed
cancelled
failed
```

Store status history separately.

Each status event should include:

-   Booking ID.
-   Previous status.
-   New status.
-   Timestamp.
-   Actor type.
-   Actor ID.
-   Optional reason/note.

------------------------------------------------------------------------

# 73. Bulk Booking Status Model

``` text
draft
submitted
under_review
offer_ready
offer_sent
customer_confirmed
scheduled
in_progress
completed
cancelled
expired
```

Offer status:

``` text
draft
sent
accepted
rejected
expired
superseded
```

------------------------------------------------------------------------

# 74. Payment Status Model

``` text
pending
paid
failed
refunded
partially_paid   # only if supported
```

Payment method examples:

-   Cash.
-   UPI.
-   Card.
-   Bank transfer.
-   Admin-recorded offline payment.

------------------------------------------------------------------------

# 75. Subscription Data Model

A driver subscription should store:

``` text
subscription_id
driver_id
plan_id
plan_name_snapshot
price_snapshot
ride_quota_snapshot
validity_days_snapshot
start_at
expires_at
rides_used
rides_remaining
status
payment_id
created_at
updated_at
```

Quota changes should be auditable:

``` text
subscription_quota_ledger
- id
- subscription_id
- booking_id
- change
- reason
- actor
- created_at
```

------------------------------------------------------------------------

# 76. Core Database Entities

Recommended core entities:

``` text
users
customers
drivers
driver_verifications
driver_documents

vehicles
vehicle_categories
vehicle_media
driver_vehicle_assignments

bookings
booking_status_history
booking_locations
booking_fare_snapshots

bulk_booking_requests
bulk_booking_requirements
bulk_booking_offers
bulk_booking_offer_vehicles

pricing_rules

subscription_plans
driver_subscriptions
subscription_quota_ledger

payments
payment_transactions

reviews
review_media

notifications
support_cases

admin_users
audit_logs
```

------------------------------------------------------------------------

# 77. Important Booking Data

Each normal booking should preserve:

``` text
Booking ID
Customer ID
Driver ID
Vehicle ID
Vehicle Category ID

Pickup Latitude
Pickup Longitude
Pickup Address

Destination Latitude
Destination Longitude
Destination Address

Distance
Estimated Duration
Actual Duration

Base Fare
Distance Fare
Time Fare
Additional Charges
Toll
Parking
Discount
Estimated Fare
Final Fare

Payment Method
Payment Status

Booking Status

Created At
Allocated At
Driver Arrived At
Started At
Completed At
Cancelled At
Cancellation Reason
```

------------------------------------------------------------------------

# 78. Vehicle Media Data

Each media item should store:

``` text
media_id
vehicle_id
type: photo | video
category: exterior | interior | dashboard | boot | other
file_url
thumbnail_url
uploaded_by
moderation_status
is_public
sort_order
created_at
```

------------------------------------------------------------------------

# 79. Fare Calculation

A fare estimate may be calculated as:

``` text
estimated_fare =
base_fare
+ distance_charge
+ time_charge
+ configured_surcharges
```

Toll and parking may be:

-   Included.
-   Estimated separately.
-   Added after ride.

The UI must clearly state the applicable rule.

Historical bookings must use a saved fare snapshot.

------------------------------------------------------------------------

# 80. Real-Time Tracking

Recommended architecture:

``` text
Driver GPS
   ↓
Driver App / Tracking Source
   ↓
Real-Time API / WebSocket
   ↓
Tracking Service
   ↓
Customer App + Admin Map
```

Real-time payload can include:

``` text
booking_id
driver_id
latitude
longitude
heading
speed
timestamp
```

## Requirements

-   Do not continuously overwrite the main booking row with every GPS
    point.
-   Keep live state in an appropriate real-time/cache/tracking layer.
-   Customer should receive smooth updates.
-   Admin should see last update time.
-   Handle stale GPS state gracefully.
-   Tracking stops after ride completion/cancellation.

------------------------------------------------------------------------

# 81. Maps

Preferred implementation can use:

-   Google Maps, or
-   Mapbox.

Required capabilities:

-   Current location.
-   Place search/autocomplete.
-   Geocoding.
-   Pickup/destination pins.
-   Route polyline.
-   Distance/duration.
-   Driver marker.
-   Recenter.
-   External navigation launch for driver if required.

------------------------------------------------------------------------

# 82. Suggested Technical Architecture

A suitable implementation may use:

## Mobile Apps

**React Native**

## Admin

**React / Next.js**

## Backend

**Laravel**

## Database

**PostgreSQL or MySQL**

## Cache / Queue

**Redis**

## Real Time

**WebSockets / Laravel Reverb or equivalent**

## Maps

**Google Maps / Mapbox**

## Media

Object storage + CDN.

## Notifications

-   Push notifications.
-   SMS for OTP and critical updates.
-   Optional WhatsApp integration if operationally approved.

The exact stack can change without changing this PRD's functional
requirements.

------------------------------------------------------------------------

# 83. Authentication & Security

## Customer/Driver

-   Phone + OTP.
-   Rate-limit OTP requests.
-   OTP expiry.
-   Device/session management.
-   Logout invalidates appropriate tokens.

## Admin

-   Password authentication.
-   Role-based access control.
-   Strong password policy.
-   2FA recommended for privileged accounts.

## Sensitive Data

-   Do not expose driver KYC documents to customers.
-   Encrypt sensitive data where appropriate.
-   Use signed/private media URLs for admin-only documents.
-   Maintain audit logs for important admin actions.
-   Limit access based on role.

------------------------------------------------------------------------

# 84. Roles & Permissions --- Admin

Possible roles:

### Super Admin

Full access.

### Operations

Bookings, drivers, vehicles, allocation, bulk booking.

### KYC Admin

Driver verification/documents.

### Finance

Payments, subscriptions, reports.

### Support

Customers, bookings, support cases, limited driver information.

All consequential actions should be auditable.

------------------------------------------------------------------------

# 85. Cancellation

Cancellation rules must be configurable.

Store:

-   Who cancelled.
-   Cancellation time.
-   Reason.
-   Fee if any.
-   Refund status if applicable.

Customer UI should clearly show whether cancellation is still allowed.

Driver app should immediately reflect cancelled assigned rides.

------------------------------------------------------------------------

# 86. Reviews & Trust

Customer-facing trust is a key differentiator.

A driver/vehicle profile should make it easy to answer:

-   Is this driver verified?
-   What is the driver's rating?
-   How many trips have they completed?
-   What exact vehicle is coming?
-   Is it AC?
-   How many seats?
-   What does the interior look like?
-   Is there luggage space?
-   What have previous customers said?

This trust layer should be more prominent than promotional features.

------------------------------------------------------------------------

# 87. Design System

The customer and driver apps must look like the same product family.

## Core Colors

``` text
Primary Orange: #F97316
Primary Dark:   #EA580C
Dark Text:      #0F172A
Background:     #F8FAFC
Card:           #FFFFFF
Body Text:      #475569
Muted:          #94A3B8
Border:         #E2E8F0
Success:        #16A34A
Warning:        #F59E0B
Error:          #DC2626
Info:           #2563EB
```

## Typography

Recommended:

**Inter**

Use large, highly readable text in the Driver App.

## Radius

``` text
Button: 12px
Input: 12px
Card: 16px
```

## Grid

8px spacing system.

## Mobile Reference Frame

**390 × 844**

## Admin Reference Frame

**1440 × 1024**

------------------------------------------------------------------------

# 88. Customer UI Rules

-   White/light background.
-   Orange primary actions.
-   Maps should feel integrated, not decorative.
-   Rounded cards.
-   Minimal navigation.
-   Keep Home focused on booking.
-   Avoid wallet/rewards/offers unless later proven necessary.
-   Profile icon should contain secondary/legal/support actions.
-   Vehicle cards should be visual and capacity-first.
-   Fare must be easy to find.
-   Driver/vehicle trust information must be prominent after allocation.

------------------------------------------------------------------------

# 89. Driver UI Rules

-   Extremely simple.
-   Prefer one primary task per card.
-   Large labels.
-   Large buttons.
-   Minimal scrolling.
-   Two navigation items maximum in V1.
-   Avoid charts.
-   Avoid dense tables.
-   Use clear status colors plus text.
-   Never depend on color alone.
-   Localize to Hindi if required by deployment.
-   Keep English presentation version available for demos/stakeholders.

------------------------------------------------------------------------

# 90. Admin UI Rules

-   Desktop-first.
-   Dark/navy sidebar.
-   Light content background.
-   Orange for primary actions.
-   Tables with strong filtering.
-   Operational status visible at a glance.
-   Details pages organized into cards/tabs.
-   Confirmation required for destructive actions.
-   Bulk allocation and subscription operations must have audit trails.

------------------------------------------------------------------------

# 91. Reusable UI Components

## Buttons

-   Primary.
-   Secondary.
-   Outline.
-   Destructive.

## Inputs

-   Text.
-   Phone.
-   OTP.
-   Location Search.
-   Date.
-   Time.
-   Number Stepper.
-   Search.

## Cards

-   Vehicle Card.
-   Driver Card.
-   Trip Card.
-   Fare Card.
-   Subscription Card.
-   Payment Summary Card.
-   Bulk Request Card.
-   Offer Card.

## Map

-   Pickup Marker.
-   Destination Marker.
-   Driver Marker.
-   Route Polyline.
-   Current Location Control.

## Status

-   Pending.
-   Active.
-   Upcoming.
-   Completed.
-   Cancelled.
-   Verified.
-   Expired.

## Feedback

-   Toast.
-   Alert.
-   Confirmation Modal.
-   Empty State.
-   Loading State.
-   Error State.

------------------------------------------------------------------------

# 92. Empty, Loading & Error States

Every major page should define these states.

## Empty

Examples:

**No upcoming rides**

**You haven't booked any trips yet**

**No bulk offers yet**

## Loading

-   Skeleton cards.
-   Map loading placeholder.
-   Driver allocation progress.

## Error

Use plain language:

**We couldn't load this information. Try again.**

Avoid technical error codes in customer/driver UI.

------------------------------------------------------------------------

# 93. Accessibility & Usability

-   Minimum comfortable touch targets.
-   High contrast.
-   Do not rely on color only for status.
-   Support dynamic text where practical.
-   Clear Hindi/localized labels for driver deployment.
-   Avoid long paragraphs in operational screens.
-   Icons must have labels when meaning may be unclear.
-   OTP and phone fields should use correct keyboard types.
-   Loading must not appear frozen.

------------------------------------------------------------------------

# 94. Analytics Events

Important product events:

## Customer

``` text
app_open
otp_requested
otp_verified
pickup_selected
destination_selected
vehicle_selected
booking_submitted
booking_confirmed
driver_profile_viewed
vehicle_gallery_viewed
driver_called
ride_tracking_opened
ride_completed
review_submitted
bulk_booking_started
bulk_request_submitted
bulk_offer_viewed
bulk_offer_confirmed
```

## Driver

``` text
driver_login
ride_details_viewed
customer_called
map_opened
subscription_viewed
subscription_renew_clicked
```

## Admin

Track critical actions through audit logs rather than only analytics.

------------------------------------------------------------------------

# 95. Key Product Metrics

## Customer

-   Booking conversion.
-   Booking completion rate.
-   Cancellation rate.
-   Driver allocation time.
-   Vehicle profile/gallery view rate.
-   Average rating.
-   Repeat booking rate.

## Bulk

-   Requests submitted.
-   Time to first offer.
-   Offer acceptance rate.
-   Bulk booking completion rate.
-   Average bulk booking value.

## Driver

-   Active subscriptions.
-   Renewal rate.
-   Average rides used per subscription.
-   Quota exhaustion rate.
-   Completed assigned rides.

## Operations

-   Allocation success rate.
-   Average allocation time.
-   Active vehicle utilization.
-   Driver verification turnaround.
-   Support cases per 100 rides.

------------------------------------------------------------------------

# 96. MVP Scope

## Customer V1

-   Splash.
-   Phone login.
-   OTP.
-   Minimal profile if required.
-   Map.
-   Pickup.
-   Destination.
-   Distance/time.
-   Vehicle selection.
-   Fare estimate.
-   Booking.
-   Driver allocation.
-   Driver/vehicle profile.
-   Vehicle photos.
-   Live tracking.
-   Call driver.
-   Ride completion.
-   Payment status.
-   Rating/review.
-   Trip history.
-   Simple profile/menu.
-   Bulk booking request.
-   Bulk offer and confirmation.

## Driver V1

-   Phone login.
-   OTP.
-   Verification status.
-   Dashboard.
-   Subscription card.
-   Next ride.
-   My Rides.
-   Ride details.
-   Call customer.
-   Open map.
-   Subscription/payment page.
-   Renew subscription.

## Admin V1

-   Login.
-   Dashboard.
-   Customers.
-   Drivers/KYC.
-   Vehicles.
-   Vehicle media.
-   Vehicle categories.
-   Pricing.
-   Bookings.
-   Driver allocation.
-   Live map.
-   Bulk bookings.
-   Bulk offer builder.
-   Subscriptions.
-   Payments.
-   Reviews.
-   Basic reports.
-   Settings.

------------------------------------------------------------------------

# 97. Future / Phase 2 Possibilities

Only add these after the core product proves useful:

-   Scheduled single rides.
-   Corporate accounts.
-   Saved locations.
-   In-app chat.
-   Advanced driver navigation.
-   Automated subscription payments.
-   Promo codes.
-   Referral system.
-   Multi-city pricing.
-   Advanced fleet owner accounts.
-   Driver document self-service.
-   Dynamic pricing.
-   Customer loyalty.
-   Advanced safety features.
-   Automated bulk optimization.

These should not complicate V1.

------------------------------------------------------------------------

# 98. Complete Customer Page List

``` text
01 Splash / Onboarding
02 Phone Login
03 OTP Verification
04 Minimal First-Time Setup
05 Home / Search & Book
06 Pickup Location
07 Destination
08 Vehicle Selection
09 Booking Review / Confirm
10 Booking Processing / Finding Driver
11 Booking Confirmed / Driver Assigned
12 Driver & Vehicle Profile Overview
13 Vehicle Gallery
14 Full Driver Profile & Reviews
15 Live Tracking / Driver En Route
16 Driver Arrived
17 Ride Started / In Progress
18 Ride Completed / Payment Summary
19 Rating & Review
20 Trip History
21 Trip Details
22 Profile / Simple Menu
23 Help & Support

24 Bulk Booking Entry
25 Bulk Trip & Capacity Requirements
26 Bulk Additional Requirements
27 Bulk Review Request
28 Bulk Request Submitted
29 Bulk Request Details / Waiting
30 Bulk Offers Received
31 Bulk Offer Details
32 Bulk Booking Confirmed
```

------------------------------------------------------------------------

# 99. Complete Driver Page List

The updated Driver App intentionally uses fewer pages than the earlier
marketplace-style concept.

``` text
01 Driver Phone Login
02 Driver OTP
03 Verification Pending / Blocked State
04 Driver Dashboard
05 My Rides
06 Ride Details
07 Subscription & Payments
```

The Dashboard and My Rides screens should cover most day-to-day usage.

------------------------------------------------------------------------

# 100. Complete Admin Page List

``` text
01 Admin Login
02 Dashboard
03 Customers
04 Customer Details
05 Drivers
06 Driver Details / KYC
07 Vehicles
08 Vehicle Details & Media
09 Vehicle Categories
10 Pricing
11 Normal Bookings
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
22 Support / Issues
23 Settings
```

------------------------------------------------------------------------

# 101. Primary Prototype Flow

The primary customer prototype should demonstrate:

``` text
OPEN APP
   ↓
PHONE NUMBER
   ↓
OTP
   ↓
HOME
   ↓
PICKUP
   ↓
DESTINATION
   ↓
ROUTE / DISTANCE / TIME
   ↓
SELECT VEHICLE
   ↓
SEE FARE
   ↓
BOOK RIDE
   ↓
DRIVER ALLOCATED
   ↓
VIEW DRIVER + ACTUAL VEHICLE
   ↓
VIEW VEHICLE PHOTOS / VIDEO
   ↓
LIVE TRACKING
   ↓
DRIVER ARRIVES
   ↓
RIDE
   ↓
COMPLETED
   ↓
PAYMENT STATUS
   ↓
RATE / REVIEW
```

Bulk prototype:

``` text
HOME
   ↓
BULK BOOKING
   ↓
FROM / TO
   ↓
DATE / TIME
   ↓
PASSENGERS / VEHICLES
   ↓
REQUIREMENTS
   ↓
SUBMIT REQUEST
   ↓
WAIT FOR OFFER
   ↓
VIEW VEHICLES + DRIVERS
   ↓
VIEW PROFILES / MEDIA
   ↓
CONFIRM BOOKING
```

Driver prototype:

``` text
PHONE
   ↓
OTP
   ↓
DASHBOARD
   ├── NEXT RIDE → RIDE DETAILS
   └── SUBSCRIPTION → PAYMENT / RENEWAL
```

------------------------------------------------------------------------

# 102. Acceptance Criteria --- Customer Booking

A customer booking flow is acceptable when:

1.  Customer can authenticate with phone + OTP.
2.  Customer can select pickup and destination.
3.  Map displays selected route.
4.  Distance and estimated duration are returned.
5.  Available vehicle categories show capacity and estimated fare.
6.  Customer can select a vehicle category.
7.  Fare is visible before confirmation.
8.  Booking is created successfully.
9.  Driver/vehicle can be allocated.
10. Customer sees driver identity, verification summary and vehicle.
11. Customer can view approved vehicle photos/videos.
12. Customer can call driver.
13. Customer can see tracking/status updates.
14. Ride can reach completed state.
15. Payment status is visible.
16. Customer can submit rating/review.
17. Trip appears in history.

------------------------------------------------------------------------

# 103. Acceptance Criteria --- Bulk Booking

A bulk booking flow is acceptable when:

1.  Customer can enter From and To.
2.  Customer can select date/time.
3.  Customer can enter passenger and vehicle requirements.
4.  Customer can add additional requirements.
5.  Customer can submit without knowing exact drivers/vehicles.
6.  Admin can review the request.
7.  Admin can build an offer with multiple vehicles/drivers.
8.  Customer receives an offer-ready notification.
9.  Customer can inspect each proposed driver/vehicle.
10. Customer can see total price and inclusions.
11. Customer can confirm the offer.
12. Confirmed bulk booking is stored and visible to admin/customer.

------------------------------------------------------------------------

# 104. Acceptance Criteria --- Driver App

The Driver App is acceptable when:

1.  Registered driver can login with OTP.
2.  Unverified driver sees a simple verification-pending state.
3.  Verified driver opens Dashboard.
4.  Dashboard shows current subscription.
5.  Dashboard shows rides used/remaining and renewal date.
6.  Dashboard shows next ride.
7.  Driver can open My Rides.
8.  Driver can open essential Ride Details.
9.  Driver can call customer.
10. Driver can open map/navigation when required.
11. Driver can see collection/payment summary.
12. Driver can see subscription payment history.
13. Driver can start renewal.
14. The primary app can be operated through two main navigation items.

------------------------------------------------------------------------

# 105. Acceptance Criteria --- Admin

Admin is acceptable when authorized staff can:

1.  Manage customers.
2.  Verify/manage drivers.
3.  Manage vehicles and vehicle media.
4.  Configure categories and pricing.
5.  View/manage normal bookings.
6.  Allocate/reallocate drivers.
7.  Monitor active rides.
8.  Process bulk requests.
9.  Build/send bulk offers.
10. Configure driver subscription plans.
11. Record/manage subscription payments.
12. View driver quota/renewal state.
13. Manage reviews.
14. View operational reports.
15. Configure core settings.
16. Audit consequential changes.

------------------------------------------------------------------------

# 106. Final Product Positioning

Taxiway should not try to win by having the largest number of features.

The product should win through:

-   **Simple booking.**
-   **Clear vehicle capacity.**
-   **Transparent fare.**
-   **Verified drivers.**
-   **Actual vehicle photos/videos.**
-   **Easy live tracking.**
-   **Strong bulk-booking operations.**
-   **A driver app simple enough to use without training.**
-   **A subscription model that is visible and understandable to
    drivers.**
-   **An admin panel that absorbs operational complexity instead of
    pushing it onto customers or drivers.**

The core product rule is:

> **Customers book. Drivers drive. Admins handle the complexity.**
