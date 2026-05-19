# ZeeroStock-Assignment

ZeeroStock is a scalable iOS marketplace application built using UIKit and MVVM architecture.  
The app supports Products, Auctions, Orders, Cart Management, Role-based Access, and Admin Approval flows using Firebase backend services.

---

# Features

## Authentication
- User Signup/Login
- Firebase Authentication
- Role-based Login System

## Product Module
- Add Products
- Product Approval Flow
- Product Listing
- Product Details
- Supplier Product Management

## Auction Module
- Create Auctions
- Live Auction Updates
- Bid Placement
- Countdown Timer
- Auction Approval Flow
- Supplier Auction Management

## Cart & Orders
- Add to Cart
- Cart Management
- Place Orders
- User Order History

## Admin Features
- Product Approval/Rejection
- Auction Approval/Rejection
- User Management

## UI Features
- UIKit Based UI
- Custom Cells
- Loading Indicators
- Reusable Components
- Modern Card-based Design

---

# Architecture

The project follows:

- MVVM Architecture
- Service Layer Pattern
- Feature-based Modular Structure

---

# Folder Structure

```text
zeerostock
│
├── Auction
│   ├── Model
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── Product
│   ├── Model
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── Orders
│   ├── Model
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── Cart
│   ├── Model
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── Profile
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── Auth
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── UsersTab
│   ├── Model
│   ├── Service
│   ├── View
│   └── ViewModel
│
├── TabBars
└── Helpers
```

---

# Tech Stack

- Swift
- UIKit
- MVVM
- Firebase Firestore
- Firebase Authentication
- SDWebImage
- AutoLayout

---

# Firebase Setup

## 1. Create Firebase Project

Go to:

https://console.firebase.google.com

---

## 2. Add iOS App

Add your iOS bundle identifier.

Example:

```text
com.sameerjain.zeerostock
```

---

## 3. Download GoogleService-Info.plist

Download:

```text
GoogleService-Info.plist
```

Add it inside the Xcode project.

---

## 4. Enable Firebase Services

Enable:
- Firebase Authentication
- Firestore Database

---

# Installation

## Clone Repository

```bash
git clone https://github.com/your-username/zeerostock.git
```

---

## Open Project

```bash
open zeerostock.xcodeproj
```

or

```bash
open zeerostock.xcworkspace
```

---

## Install Packages

Swift Package Manager dependencies will install automatically.

---

## Run Project

Select simulator/device and run:

```bash
⌘ + R
```

---

# Package Installation

This project uses Swift Package Manager (SPM).

All dependencies will install automatically when the project is opened in Xcode.

If packages do not resolve automatically:

## In Xcode

Go to:

```text
File → Packages → Resolve Package Versions
```

or

```text
File → Packages → Update to Latest Package Versions
```

---

# Current Dependencies

- Firebase
- SDWebImage

---

# Requirements

- Xcode 16+
- iOS 16+
- Swift 5+

---

# User Roles

## User
- Browse Products
- Add to Cart
- Place Orders
- Participate in Auctions

## Supplier
- Add Products
- Create Auctions
- Manage Listings

## Auction Admin
- Approve/Reject Auctions

## Super Admin
- Approve/Reject Products
- Manage Users

---

# Creating Roles

By default, every newly registered account is created as:

```text
user
```

or

```text
supplier
```

depending on signup selection.

Admin roles are managed manually through Firebase Firestore. Change the role to super_admin, product_admin, auction_admin according to your requirement. 

---

# MVVM Structure

## View
Responsible for:
- UI
- User Interaction
- Binding ViewModel

## ViewModel
Responsible for:
- Business Logic
- Validation
- UI State
- Service Calls

## Service
Responsible for:
- Firebase Calls
- API/Data Layer

## Model
Responsible for:
- Data Representation

---

# Screens Included

- Login
- Signup
- Home
- Product Details
- Cart
- Orders
- Add Product
- Add Auction
- Auction Details
- Supplier Products
- Supplier Auctions
- Admin Approval
- Admin Auctions
- User Management

---

# Improvements Planned

- Image Upload using Firebase Storage
- Real-time Auction Socket Updates
- Push Notifications
- Dark Mode
- Unit Testing
- Combine / Async Await
- Pagination
- Search & Filters

---

# Security Notes

The repository does NOT include:

```text
GoogleService-Info.plist
```

You must add your own Firebase configuration.

---

# Dependencies

- Firebase
- SDWebImage

---

# Screenshots

Add screenshots here.

Example:

```md
![Home Screen](screenshots/home.png)
![Auction Screen](screenshots/auction.png)
```

---

# Author

Sameer Jain

GitHub:
https://github.com/Sameer-Jain-7

LinkedIn:
https://www.linkedin.com/in/sameer-j7

---

# License

This project is for learning and portfolio purposes.
