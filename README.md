# Worabe Transport

**A Bajaj Ride-Request and Transport Management System for Worabe, Ethiopia**

![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Flutter-02569B)
![Backend](https://img.shields.io/badge/Backend-Node.js%20%7C%20Express-339933)
![Database](https://img.shields.io/badge/Database-MongoDB-47A248)
![Language](https://img.shields.io/badge/Language-Dart%20%7C%20JavaScript-blue)
![Status](https://img.shields.io/badge/Status-In%20Development-orange)

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement](#2-problem-statement)
3. [Project Objectives](#3-project-objectives)
4. [Project Scope](#4-project-scope)
5. [System Users and Roles](#5-system-users-and-roles)
6. [Key Features](#6-key-features)
7. [Technology Stack](#7-technology-stack)
8. [System Architecture](#8-system-architecture)
9. [Flutter Mobile Application](#9-flutter-mobile-application)
10. [Backend API](#10-backend-api)
11. [Database Design](#11-database-design)
12. [System Workflows](#12-system-workflows)
13. [API Reference](#13-api-reference)
14. [Project Structure](#14-project-structure)
15. [Installation and Configuration](#15-installation-and-configuration)
16. [Running the Backend](#16-running-the-backend)
17. [Flutter Setup and Integration](#17-flutter-setup-and-integration)
18. [Authentication and Authorization](#18-authentication-and-authorization)
19. [Ride Lifecycle and Business Rules](#19-ride-lifecycle-and-business-rules)
20. [Offline-First and Synchronization Strategy](#20-offline-first-and-synchronization-strategy)
21. [Localization](#21-localization)
22. [Security and Privacy](#22-security-and-privacy)
23. [Error Handling](#23-error-handling)
24. [Testing Strategy](#24-testing-strategy)
25. [Troubleshooting](#25-troubleshooting)
26. [Development Roadmap](#26-development-roadmap)
27. [Deployment Considerations](#27-deployment-considerations)
28. [Limitations and Future Improvements](#28-limitations-and-future-improvements)
29. [Contribution Guidelines](#29-contribution-guidelines)
30. [License](#30-license)

---

## 1. Project Overview

**Worabe Transport** is a digital transportation management system designed to connect passengers with Bajaj drivers in Worabe, Ethiopia.

The system is intended to replace informal, difficult-to-track parts of the ride-request process with a structured mobile experience. Passengers can find verified drivers, choose a specific driver, provide pickup and destination descriptions, and submit ride requests. Drivers can manage their availability, respond to requests, and complete accepted rides.

The backend provides the central API, authentication, business rules, and database operations. The Flutter mobile application provides the user-facing experience for passengers and drivers.

The system also includes administrative functions for driver verification and complaint management. These functions help establish a more accountable transport service.

The project follows a client-server architecture and is designed to evolve incrementally, starting with essential ride-request functionality before introducing more advanced features.

### 1.1 Project Vision

The vision of Worabe Transport is to provide a practical, accessible, and reliable digital platform for local Bajaj transportation.

The system aims to make it easier for passengers to identify eligible drivers, communicate their intended journey, and understand the status of their requests. At the same time, it gives drivers a structured way to manage availability and ride requests.

### 1.2 Project Mission

The mission is to develop a maintainable transportation application that:

- Supports the everyday transportation needs of the Worabe community.
- Connects passengers directly with drivers they select.
- Restricts service access to approved drivers.
- Maintains reliable ride records.
- Supports transparent request-status management.
- Provides an administrative process for handling driver verification and complaints.
- Accommodates unreliable mobile connectivity through an offline-aware application design.
- Supports future localization and expansion.

### 1.3 Target Platform

The initial mobile target is Android, using Flutter and Dart.

The backend is a Node.js REST API that can be accessed by the mobile application and potentially by a future administrative web dashboard.

### 1.4 Development Status

The backend has been structured around authentication, driver management, administration, ride requests, and complaints. Its readiness depends on successful API, transaction, security, and integration testing.

The Flutter application architecture and feature descriptions in this document represent the intended mobile implementation. Features should be marked complete only after their code has been implemented and tested.

---

## 2. Problem Statement

Local transportation can involve challenges such as finding an available driver, explaining a pickup location, confirming whether a driver will accept a journey, and keeping track of a request's outcome.

When these interactions happen informally, passengers and drivers may lack a shared record of the request. It can be difficult to identify verified service providers, distinguish available drivers from unavailable ones, or review what happened after a ride-related problem.

A digital system can organize these interactions into a clear workflow.

Worabe Transport addresses these challenges by introducing:

- A directory of approved Bajaj drivers.
- Driver availability management.
- Direct ride requests to a selected driver.
- Explicit acceptance and rejection.
- Recorded ride status and history.
- Cancellation and completion workflows.
- Complaint reporting and administrative review.
- A structured backend that enforces permissions and business rules.

The application is designed for local use rather than relying on an automatic dispatch model or requiring live map-based tracking for the initial release.

---

## 3. Project Objectives

### 3.1 General Objective

To develop a secure and maintainable transport management system that connects passengers with verified Bajaj drivers in Worabe through a mobile application and centralized backend API.

### 3.2 Specific Objectives

1. Provide registration and authentication for passengers and drivers.
2. Allow drivers to submit their vehicle information for verification.
3. Enable administrators to approve or reject driver applications.
4. Allow eligible drivers to manage their online and offline availability.
5. Allow passengers to browse eligible drivers.
6. Allow passengers to request a specific driver.
7. Allow assigned drivers to accept or reject pending requests.
8. Maintain accurate ride-request records and status transitions.
9. Prevent conflicting active rides for the same passenger or driver.
10. Allow eligible passengers to cancel requests and assigned drivers to complete accepted rides.
11. Provide ride-history access based on user identity and role.
12. Allow passengers and drivers to submit complaints.
13. Provide administrative complaint-management functionality.
14. Develop a Flutter application with a clear passenger and driver interface.
15. Design the mobile client to cache suitable data and preserve offline drafts.
16. Support English and Amharic initially, with possible Silte support in a later phase.
17. Establish a foundation for additional transport features and future deployment.

---

## 4. Project Scope

### 4.1 Included in the Initial Scope

The initial system focuses on the essential transportation workflow.

- Passenger accounts.
- Driver accounts.
- Administrator accounts created through a controlled process.
- JWT-based authentication.
- Role-based authorization.
- Driver profiles and vehicle information.
- Driver verification.
- Driver availability.
- Driver directory.
- Passenger-selected driver requests.
- Pickup and destination descriptions.
- Ride acceptance and rejection.
- Ride cancellation and completion.
- Ride history.
- Complaint submission and administration.
- Active-ride reservation tracking.
- Request idempotency support.
- Flutter application integration.
- Offline-aware client design.

### 4.2 Outside the Initial Scope

The following features are not part of the initial scope or are not yet confirmed as implemented:

- Live GPS tracking.
- Real-time map navigation.
- Automatic nearest-driver assignment.
- Online payment processing.
- Push notifications.
- Passenger and driver ratings.
- Automated fare calculation.
- A complete fare negotiation workflow.
- A production-ready administrative web dashboard.
- Full offline synchronization and conflict resolution.
- Silte localization.
- Production deployment and operational monitoring.

These features can be considered after the core workflow is reliable.

---

## 5. System Users and Roles

The system defines three main roles: passenger, driver, and administrator.

### 5.1 Passenger

Passengers use the system to find drivers and request transportation.

Responsibilities and capabilities include:

- Registering and logging in.
- Viewing approved and verified drivers.
- Checking driver availability.
- Selecting a specific driver.
- Entering pickup and destination descriptions.
- Submitting a ride request.
- Viewing ride status.
- Cancelling eligible requests.
- Reviewing ride history.
- Submitting complaints.

A passenger must not be able to modify another passenger's records or perform driver-management and administrative operations.

### 5.2 Driver

Drivers use the system to manage their service availability and ride requests.

Capabilities include:

- Registering with vehicle information.
- Waiting for administrator verification.
- Viewing their driver profile.
- Switching between online and offline when eligible.
- Viewing ride requests assigned to them.
- Accepting or rejecting pending requests.
- Completing accepted rides.
- Reviewing their ride history.
- Submitting complaints.

A driver cannot accept a request assigned to a different driver. A driver must be approved and verified before becoming eligible to receive and accept requests.

### 5.3 Administrator

Administrators manage selected operational tasks.

Capabilities include:

- Viewing drivers awaiting verification.
- Approving or rejecting driver applications.
- Viewing complaints.
- Filtering complaints by status where supported.
- Updating complaint status.
- Adding administrative notes.

Administrator privileges must be established through a trusted setup or controlled administrative process. Public registration must never grant administrator access.

---

## 6. Key Features

### 6.1 Account Management

The system supports passenger and driver registration, login, and authenticated access to protected resources.

Phone numbers are used as unique account identifiers in the current model. Passwords must be hashed before being stored.

### 6.2 Driver Verification

Driver registration creates a driver profile with pending verification status. Administrators review the profile and decide whether to approve or reject the driver.

The system separates registration from permission to provide service.

### 6.3 Driver Availability

Approved drivers can switch between online and offline.

Online availability means the driver is eligible to receive requests, subject to other business rules. It does not guarantee that the driver can accept a second active ride.

### 6.4 Driver Directory

Passengers can retrieve the list of eligible drivers. The API can filter by availability.

The directory may display relevant driver and vehicle details. Only information intended for public display should be returned.

### 6.5 Direct Ride Requests

Passengers choose a specific driver instead of relying on automatic dispatch.

The passenger provides a pickup description and destination description. The request is saved as pending until the selected driver responds.

### 6.6 Ride Status Management

The backend maintains a controlled set of ride statuses:

- `pending`
- `accepted`
- `rejected`
- `cancelled`
- `completed`

Only authorized operations should change these statuses.

### 6.7 Active-Ride Protection

The system uses active-ride tracking fields on the user model to help reserve one active ride slot for a passenger or driver.

This mechanism is intended to prevent a passenger from creating overlapping active rides and a driver from accepting multiple active rides.

Its reliability depends on correct transaction handling, concurrency testing, and reconciliation of existing records.

### 6.8 Ride History

Passengers and drivers can retrieve their own ride records. The backend must enforce ownership and role restrictions on every history request.

### 6.9 Complaint Management

Passengers and drivers can submit complaints. Administrators can review and update complaint records.

When a complaint references a ride, the backend checks whether the reporting user is associated with that ride.

### 6.10 Offline-Aware Mobile Experience

The planned Flutter client will support cached information and offline drafts where appropriate.

Offline drafts are not confirmed rides. A draft must be reviewed and explicitly submitted when connectivity is restored.

---

## 7. Technology Stack

### 7.1 Backend

| Technology | Responsibility |
|---|---|
| Node.js | JavaScript runtime |
| Express.js | HTTP server and API routing |
| MongoDB Atlas | Cloud database |
| Mongoose | Schema definition and database access |
| JSON Web Tokens | Authentication |
| bcrypt | Password hashing |
| Helmet | HTTP security headers |
| CORS | Cross-origin access configuration |
| Morgan | HTTP request logging |
| express-rate-limit | Rate limiting for configured endpoints |
| Nodemon | Development server reloads |

### 7.2 Flutter Mobile Application

| Technology | Responsibility |
|---|---|
| Flutter | Cross-platform mobile UI framework |
| Dart | Mobile application programming language |
| Riverpod | State management |
| GoRouter | Navigation and routing |
| Dio | HTTP API communication |
| SQLite / sqflite | Local persistence and caching |
| flutter_secure_storage | Secure credential storage |
| connectivity_plus | Network connectivity awareness |

The Flutter dependencies and exact versions should be confirmed in `pubspec.yaml`.

### 7.3 Development Tools

Recommended tools include:

- Visual Studio Code.
- Android Studio and Android SDK.
- Git and GitHub.
- Postman or another HTTP API client.
- MongoDB Atlas.
- A physical Android device or Android Emulator.

---

## 8. System Architecture

Worabe Transport follows a client-server architecture.

The Flutter application presents the user interface. It communicates with the backend over HTTP using JSON requests and responses. Protected requests include a JWT in the authorization header.

The backend validates input, authenticates users, enforces role permissions, applies business rules, and communicates with MongoDB.

### 8.1 Architecture Diagram

```text
                      WORABE TRANSPORT
                              |
                 +------------+------------+
                 |                         |
                 v                         v
           Passenger App              Driver App
                 |                         |
                 +------------+------------+
                              |
                              v
                    Flutter Mobile Client
                              |
              +---------------+---------------+
              |               |               |
              v               v               v
          Riverpod         GoRouter           Dio
       State Management   Navigation       HTTP Client
                              |
                              v
                     Express REST API
                              |
             +----------------+----------------+
             |                |                |
             v                v                v
       Authentication    Driver Service    Ride Service
             |                |                |
             +----------------+----------------+
                              |
                 +------------+------------+
                 |                         |
                 v                         v
         Complaint Service          Admin Service
                 |                         |
                 +------------+------------+
                              |
                              v
                         Mongoose
                              |
                              v
                         MongoDB Atlas
                              |
                 +------------+------------+
                 |            |            |
                 v            v            v
               Users     Driver Profiles   Rides
                                           |
                                           v
                                       Complaints
```

### 8.2 Responsibility Separation

**Flutter client**

- Displays screens and forms.
- Collects user input.
- Sends API requests.
- Displays results and errors.
- Manages client-side state.
- Caches selected data.
- Stores offline drafts.
- Manages navigation and localization.

**Backend**

- Authenticates requests.
- Enforces authorization.
- Validates submitted data.
- Checks driver verification and availability.
- Enforces ride-state transitions.
- Coordinates active-ride reservations.
- Stores authoritative records.
- Returns structured responses.

**MongoDB**

- Stores accounts.
- Stores driver profiles.
- Stores ride requests.
- Stores complaints.
- Enforces configured indexes and uniqueness constraints.

The client is never the final authority for a user's role, a driver's eligibility, or a ride's confirmed status.

---

## 9. Flutter Mobile Application

### 9.1 Overview

The mobile application is planned in Flutter and Dart for Android-first development.

It provides separate passenger and driver experiences while sharing common infrastructure such as authentication, navigation, API communication, storage, localization, and error handling.

The application will communicate with the backend rather than directly accessing MongoDB.

### 9.2 Passenger Interface

The passenger experience is intended to include:

1. Welcome and authentication screens.
2. Passenger registration and login.
3. Passenger home screen.
4. Approved driver directory.
5. Driver details.
6. Pickup and destination entry.
7. Ride-request confirmation.
8. Current ride status.
9. Ride history.
10. Complaint submission.
11. Profile and language settings.

The passenger chooses a driver and submits a request. The interface then displays the server-confirmed status.

### 9.3 Driver Interface

The driver experience is intended to include:

1. Driver registration.
2. Verification status.
3. Driver home screen.
4. Online/offline availability controls.
5. Incoming assigned requests.
6. Ride request details.
7. Accept and reject actions.
8. Accepted ride details.
9. Complete ride action.
10. Ride history.
11. Complaint submission.
12. Profile settings.

The interface should explain when a driver is awaiting verification and prevent confusing unavailable states. Server-side checks remain mandatory even when the interface disables an action.

### 9.4 Recommended Flutter Folder Structure

```text
worabe_transport/
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── icons/
│   └── translations/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── network/
│   │   ├── router/
│   │   ├── storage/
│   │   ├── theme/
│   │   └── localization/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── passenger/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── driver/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── rides/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── complaints/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── shared/
│       ├── widgets/
│       └── models/
├── test/
└── pubspec.yaml
```

This is the recommended organization, not a statement that every directory has already been created.

### 9.5 Core Layer

The `core/` directory contains reusable infrastructure.

- `constants/`: application constants and configuration.
- `errors/`: application-specific exceptions and error mapping.
- `network/`: Dio setup, interceptors, and API configuration.
- `router/`: GoRouter configuration and navigation guards.
- `storage/`: secure token storage and local database setup.
- `theme/`: shared colors, typography, and component themes.
- `localization/`: language configuration and translation resources.

The core layer should not contain duplicated feature-specific business logic.

### 9.6 Feature Layer

Each feature can be separated into three logical areas.

**Data**

Responsible for API calls, local data sources, repository implementations, and model serialization.

**Domain**

Responsible for business entities, repository contracts, and reusable business rules where this separation is useful.

**Presentation**

Responsible for screens, reusable feature widgets, controllers, providers, and UI state.

This separation helps prevent API logic from becoming mixed into large widget files.

### 9.7 State Management with Riverpod

Riverpod is planned to manage:

- Authentication state.
- Current user information.
- Driver directory data.
- Driver availability.
- Ride request state.
- Ride history.
- Complaint submission.
- Loading, error, and success states.
- Cached and locally drafted data.

The interface should distinguish between loading, loaded, empty, and failed states. Critical data should be refreshed from the server when appropriate.

### 9.8 Navigation with GoRouter

GoRouter is planned to handle screen navigation.

Navigation may depend on authentication status and user role. For example, passengers should be directed to passenger screens and drivers to driver screens.

Navigation guards improve the user experience but are not a security boundary. The backend must independently enforce permissions.

### 9.9 API Communication with Dio

Dio will handle communication with the REST API.

The API client should centralize:

- Base URL configuration.
- JSON request and response handling.
- JWT authorization headers.
- Connection and response timeouts.
- Error normalization.
- Retry policies for appropriate transient failures.

Requests that create or modify rides must not be retried blindly without considering idempotency and request state.

### 9.10 Local Persistence

SQLite can be used to store selected data for offline access.

Potential local data includes:

- Cached driver directory information.
- Cached destination or service-area information.
- Ride-request drafts.
- Minimal information needed to restore the interface.

Sensitive authentication credentials should use secure platform storage rather than ordinary SQLite tables.

Local records must distinguish drafts from server-confirmed records.

### 9.11 Flutter Localization

The initial language plan is:

- English (`en`).
- Amharic (`am`).

Silte language support can be added later.

Translation resources should cover screen labels, validation messages, statuses, errors, buttons, and accessibility text. The user's preferred language should be applied consistently throughout the interface.

### 9.12 Mobile Application Security

The Flutter client should:

- Use HTTPS for deployed API communication.
- Store tokens in secure storage.
- Avoid embedding server secrets in the application.
- Handle expired tokens and logout safely.
- Avoid storing unnecessary personal information.
- Display only information intended for the current user.
- Avoid treating locally cached ride statuses as authoritative.
- Handle network errors without exposing internal details.

### 9.13 Flutter Implementation Status

The folder structure, state-management strategy, and screens above describe the planned mobile architecture. They should not be interpreted as proof that the Flutter application is already complete.

The mobile app should be integrated feature by feature and tested against the actual backend API contract.

---

## 10. Backend API

### 10.1 Overview

The backend is implemented using Node.js, Express, Mongoose, and MongoDB Atlas.

It exposes REST endpoints for authentication, driver management, administrative operations, ride requests, and complaints.

### 10.2 Express Application

The Express application configures middleware, mounts route modules, handles unmatched routes, and provides centralized error handling.

The current application structure uses middleware such as:

- `helmet`
- `cors`
- `morgan`
- `express-rate-limit`
- JSON request parsing
- Authentication and authorization middleware
- Error-handling middleware

Middleware order matters. Routes must be mounted before the final not-found handler, and errors should be passed to the configured error handler.

### 10.3 Database Connection

Mongoose manages connections and model operations against MongoDB Atlas.

The database connection should be configured through environment variables. Database credentials must not be hard-coded into source files.

The configured deployment must support transactions for the ride controller's transaction-based operations.

### 10.4 Controller Responsibilities

**Authentication controller**

- Registers passengers and drivers.
- Hashes passwords.
- Verifies login credentials.
- Issues authentication tokens.
- Returns the authenticated user's information.

**Driver controller**

- Lists eligible drivers.
- Retrieves the current driver's profile.
- Updates driver availability.

**Admin controller**

- Lists pending driver profiles.
- Approves or rejects drivers.
- Supports administrative driver management.

**Ride controller**

- Creates ride requests.
- Lists the authenticated user's rides.
- Accepts or rejects pending requests.
- Cancels eligible requests.
- Completes accepted rides.
- Manages active-ride reservations.

**Complaint controller**

- Creates complaints.
- Lists a user's complaints.
- Lists complaints for administrators.
- Updates complaint status and administrative notes.

### 10.5 Authentication Middleware

The authentication middleware verifies the bearer token, identifies the corresponding user, and attaches trusted user information to the request.

The authorization middleware restricts endpoints to permitted roles.

Controllers should use the authenticated identity from middleware rather than trusting a user ID supplied by the client to determine who is performing an operation.

### 10.6 Centralized Error Handling

The backend should return consistent error responses for validation errors, authentication failures, authorization failures, missing records, conflicts, and unexpected server errors.

Internal stack traces and secret values should not be exposed in production responses.

---

## 11. Database Design

The current database design uses four primary Mongoose models: `User`, `DriverProfile`, `RideRequest`, and `Complaint`.

### 11.1 User Model

The `User` model stores account information.

| Field | Purpose |
|---|---|
| `fullName` | User's display name |
| `phone` | Unique phone number |
| `passwordHash` | Hashed password |
| `role` | `passenger`, `driver`, or `admin` |
| `preferredLanguage` | Preferred interface language |
| `isActive` | Whether the account is active |
| `activeRideRequestId` | Reference to the current active ride |
| `activeRideRole` | Whether the active slot is for a passenger or driver |
| `createdAt` | Creation timestamp |
| `updatedAt` | Last update timestamp |

The `passwordHash` field is configured to be excluded from ordinary query results.

The active-ride fields help the backend track whether the user already holds an active ride reservation.

### 11.2 DriverProfile Model

The `DriverProfile` model stores transport-related information.

| Field | Purpose |
|---|---|
| `userId` | Reference to the associated user |
| `vehicleType` | Currently restricted to `bajaj` |
| `vehiclePlate` | Vehicle registration identifier |
| `serviceAreas` | Areas served by the driver |
| `destinations` | Destinations associated with the driver |
| `verificationStatus` | `pending`, `approved`, or `rejected` |
| `isVerified` | Verification flag |
| `availability` | `online` or `offline` |
| `createdAt` | Creation timestamp |
| `updatedAt` | Last update timestamp |

The current model explicitly uses the MongoDB collection named `bajaj`.

### 11.3 RideRequest Model

The `RideRequest` model stores each request and its status.

| Field | Purpose |
|---|---|
| `passengerId` | Passenger who created the request |
| `driverId` | Selected driver |
| `pickup.label` | Pickup description |
| `destination.label` | Destination description |
| `status` | Current request status |
| `agreedFare` | Optional agreed fare field |
| `requestKey` | Optional idempotency key |
| `createdAt` | Creation timestamp |
| `updatedAt` | Last update timestamp |

The pickup and destination are structured descriptions rather than GPS coordinates.

The `requestKey` index is intended to prevent duplicate requests for the same passenger and key when retries occur. The controller and index behavior must be tested together.

### 11.4 Complaint Model

The `Complaint` model records reported issues.

| Field | Purpose |
|---|---|
| `reporterId` | User submitting the complaint |
| `rideId` | Optional associated ride |
| `category` | Type of complaint |
| `description` | Complaint details |
| `status` | Administrative review status |
| `adminNote` | Optional administrative note |
| `createdAt` | Creation timestamp |
| `updatedAt` | Last update timestamp |

Supported complaint categories include:

- `driver_behavior`
- `passenger_behavior`
- `fare_dispute`
- `driver_not_arriving`
- `safety_concern`
- `other`

Supported complaint statuses include:

- `open`
- `under_review`
- `resolved`
- `dismissed`

### 11.5 Relationships

The main relationships are:

- One user can have one driver profile when their role is `driver`.
- A passenger can have multiple ride records over time.
- A driver can have multiple ride records over time.
- A ride connects one passenger and one selected driver.
- A complaint belongs to a reporting user and may reference a ride.

These relationships are implemented through MongoDB references and application-level validation.

### 11.6 Indexes and Data Integrity

The current models use indexes for relevant identity and lookup fields. Additional database constraints may be needed as the system evolves.

Indexes improve lookup performance and can enforce uniqueness, but they do not replace business-rule validation.

Before production, the system should be tested for duplicate submissions, simultaneous ride requests, stale active-ride references, and recovery after failed transactions.

---

## 12. System Workflows

### 12.1 Registration and Login

1. The user opens the mobile application.
2. The user registers or enters login credentials.
3. Flutter sends the information to the authentication API.
4. The backend validates the input.
5. For registration, the password is hashed before storage.
6. For login, the backend compares the submitted password with the stored hash.
7. The backend issues a JWT after successful authentication.
8. Flutter stores the token securely and retrieves the user's account information.

### 12.2 Driver Verification

1. A driver registers.
2. The backend creates the associated driver profile.
3. The profile starts with pending verification and offline availability.
4. An administrator reviews the driver.
5. The administrator approves or rejects the profile.
6. An approved driver can switch to online when eligible.
7. The passenger directory includes only eligible drivers.

### 12.3 Ride Request Creation

1. The passenger opens the driver directory.
2. The passenger selects a specific driver.
3. The passenger enters pickup and destination descriptions.
4. Flutter validates the required fields.
5. The client sends a ride request with its authentication token.
6. The backend checks passenger identity, driver eligibility, and active-ride restrictions.
7. The backend creates a pending request.
8. Flutter displays the result returned by the server.

### 12.4 Driver Acceptance

1. The selected driver retrieves their pending requests.
2. The driver opens a request.
3. The driver chooses accept or reject.
4. The backend checks that the driver is assigned to that request.
5. For acceptance, the backend verifies eligibility and reserves the driver's active-ride slot.
6. The backend updates the request status.
7. The application displays the updated status.

### 12.5 Cancellation

1. The passenger selects an eligible ride.
2. The passenger requests cancellation.
3. The backend checks ownership and the current ride status.
4. The backend changes the status to cancelled.
5. If the ride had been accepted, the relevant active-ride reservations are released.
6. The client refreshes its ride state.

### 12.6 Completion

1. The assigned driver opens an accepted ride.
2. The driver submits the completion action.
3. The backend verifies the assigned driver and ride status.
4. The backend marks the ride completed.
5. The backend releases the passenger and driver active-ride reservations.
6. The ride appears in the relevant histories.

### 12.7 Complaint Management

1. A passenger or driver submits a complaint.
2. The backend validates the complaint category and description.
3. If a ride is referenced, the backend checks the reporting user's relationship to that ride.
4. The complaint is saved with an initial status.
5. An administrator retrieves the complaint.
6. The administrator updates its status or adds an administrative note.

---

## 13. API Reference

### 13.1 Base URL

Local development:

`http://localhost:5000`

The production base URL should be documented once the backend is deployed.

### 13.2 Authentication Header

Protected endpoints generally use:

```http
Authorization: Bearer YOUR_JWT_TOKEN
```

The token must belong to an active account with the role required by the endpoint.

### 13.3 Health Endpoint

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/health` | Check API availability |

### 13.4 Authentication Endpoints

| Method | Endpoint | Access |
|---|---|---|
| POST | `/api/auth/register` | Public |
| POST | `/api/auth/login` | Public |
| GET | `/api/auth/me` | Authenticated user |

#### Register

`POST /api/auth/register`

Example passenger request:

```json
{
  "fullName": "Example Passenger",
  "phone": "0911111111",
  "password": "UseAUniqueStrongPassword123!",
  "role": "passenger",
  "preferredLanguage": "en"
}
```

Example driver request:

```json
{
  "fullName": "Example Driver",
  "phone": "0922222222",
  "password": "UseAnotherStrongPassword123!",
  "role": "driver",
  "vehiclePlate": "EXAMPLE-001",
  "preferredLanguage": "en"
}
```

Use test credentials only in documentation and API tests. Never use real passwords in a public README.

Public registration must not allow an administrator role.

#### Login

`POST /api/auth/login`

Example:

```json
{
  "phone": "0911111111",
  "password": "UseAUniqueStrongPassword123!"
}
```

The backend verifies the credentials and returns an authentication result according to the current controller response format.

#### Current User

`GET /api/auth/me`

Returns the authenticated user's profile information, excluding sensitive credentials.

### 13.5 Driver Endpoints

| Method | Endpoint | Access |
|---|---|---|
| GET | `/api/drivers` | Authenticated user, subject to route configuration |
| GET | `/api/drivers/me` | Driver |
| PATCH | `/api/drivers/me/availability` | Driver |

#### List Drivers

`GET /api/drivers`

Optional availability filter:

`GET /api/drivers?availability=online`

The response should include only approved and verified drivers according to the current controller.

#### Retrieve Own Driver Profile

`GET /api/drivers/me`

Requires a driver account.

#### Update Availability

`PATCH /api/drivers/me/availability`

Example:

```json
{
  "availability": "online"
}
```

To go offline:

```json
{
  "availability": "offline"
}
```

Only approved and verified drivers should be allowed to go online.

### 13.6 Administrator Endpoints

| Method | Endpoint | Access |
|---|---|---|
| GET | `/api/admin/drivers/pending` | Admin |
| PATCH | `/api/admin/drivers/:driverId/verification` | Admin |

#### List Pending Drivers

`GET /api/admin/drivers/pending`

Returns driver profiles awaiting verification.

#### Update Driver Verification

`PATCH /api/admin/drivers/:driverId/verification`

Example approval request:

```json
{
  "status": "approved"
}
```

Example rejection request:

```json
{
  "status": "rejected"
}
```

Use the identifier expected by the current controller. If it queries driver profiles by their `_id`, pass the profile ID; if it queries users, pass the user ID. Verify this against the implementation before integration.

### 13.7 Ride Endpoints

| Method | Endpoint | Access |
|---|---|---|
| POST | `/api/rides` | Passenger |
| GET | `/api/rides` | Authenticated passenger or driver |
| PATCH | `/api/rides/:rideId/response` | Assigned driver |
| PATCH | `/api/rides/:rideId/cancel` | Requesting passenger |
| PATCH | `/api/rides/:rideId/complete` | Assigned driver |

#### Create a Ride Request

`POST /api/rides`

Example:

```json
{
  "driverId": "DRIVER_USER_ID",
  "pickup": {
    "label": "Near Worabe bus station"
  },
  "destination": {
    "label": "Worabe market"
  }
}
```

The current ride controller expects an idempotency key in the `Idempotency-Key` HTTP header.

Example:

```http
Idempotency-Key: unique-request-key
```

The client should reuse the same key when retrying the same logical request, not when creating a new request.

#### Retrieve Ride History

`GET /api/rides`

Returns ride records associated with the authenticated user.

#### Accept or Reject a Ride

`PATCH /api/rides/:rideId/response`

Accept:

```json
{
  "action": "accept"
}
```

Reject:

```json
{
  "action": "reject"
}
```

The assigned driver can respond only to a pending request.

#### Cancel a Ride

`PATCH /api/rides/:rideId/cancel`

The controller should verify that the authenticated passenger owns the ride and that the current status permits cancellation.

#### Complete a Ride

`PATCH /api/rides/:rideId/complete`

The controller should verify that the authenticated driver is assigned to the ride and that the ride has been accepted.

### 13.8 Complaint Endpoints

| Method | Endpoint | Access |
|---|---|---|
| POST | `/api/complaints` | Authenticated passenger or driver |
| GET | `/api/complaints` | Authenticated user |
| GET | `/api/complaints/admin/all` | Admin |
| PATCH | `/api/complaints/admin/:complaintId` | Admin |

#### Submit a Complaint

`POST /api/complaints`

Example:

```json
{
  "rideId": "OPTIONAL_RIDE_ID",
  "category": "driver_behavior",
  "description": "Describe the issue clearly."
}
```

The ride ID is optional when supported by the current controller. When supplied, the backend should verify that the reporting user is associated with the referenced ride.

#### List Own Complaints

`GET /api/complaints`

Returns the authenticated user's complaints.

#### List Complaints for Administrators

`GET /api/complaints/admin/all`

Requires administrator authorization.

#### Update a Complaint

`PATCH /api/complaints/admin/:complaintId`

Example:

```json
{
  "status": "under_review",
  "adminNote": "The report is being reviewed."
}
```

Use the accepted values defined by the complaint schema.

### 13.9 API Contract Notes

The endpoint list above describes the intended current API surface. The following should be verified before publishing a formal API contract:

- Exact HTTP status codes.
- Exact response object structure.
- Validation and error response formats.
- Whether the admin verification parameter identifies a user or profile.
- Exact authentication response field names.
- Whether every endpoint requires authentication.
- Whether query filters and pagination are supported.
- Whether idempotent retries return the original response or a different success status.

The Flutter API client should follow the actual tested responses rather than assumptions in documentation.

---

## 14. Project Structure

### 14.1 Backend Structure

The intended backend structure is:

```text
worabe-transport-api/
├── src/
│   ├── config/
│   │   └── db.js
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── driverController.js
│   │   ├── adminController.js
│   │   ├── rideController.js
│   │   └── complaintController.js
│   ├── middleware/
│   │   ├── auth.js
│   │   └── errorHandler.js
│   ├── models/
│   │   ├── User.js
│   │   ├── DriverProfile.js
│   │   ├── RideRequest.js
│   │   └── Complaint.js
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── driverRoutes.js
│   │   ├── adminRoutes.js
│   │   ├── rideRoutes.js
│   │   └── complaintRoutes.js
│   ├── app.js
│   └── server.js
├── scripts/
│   └── createAdmin.js
├── .env
├── .gitignore
├── package.json
└── README.md
```

### 14.2 Backend Directory Responsibilities

- `config/`: database and other infrastructure configuration.
- `controllers/`: business logic for each API feature.
- `middleware/`: authentication, authorization, validation, and error handling.
- `models/`: Mongoose schemas and database models.
- `routes/`: API route definitions.
- `scripts/`: controlled setup and maintenance scripts.
- `app.js`: Express middleware and route registration.
- `server.js`: application startup and database connection.
- `package.json`: dependencies and scripts.
- `.env`: private runtime configuration.

The actual file names may vary slightly.

### 14.3 Flutter Structure

The mobile application should be maintained as a separate project directory with its own `pubspec.yaml`, source code, assets, and tests.

If both projects are kept in a single repository, a possible organization is:

```text
Worabe_Transport/
├── worabe-transport-api/
│   ├── src/
│   ├── scripts/
│   ├── package.json
│   └── README.md
├── worabe_transport/
│   ├── android/
│   ├── assets/
│   ├── lib/
│   ├── test/
│   └── pubspec.yaml
└── README.md
```

The root README can provide the overall system description, while the backend and Flutter folders can contain component-specific documentation.

---

## 15. Installation and Configuration

### 15.1 Prerequisites

Install:

- Node.js and npm.
- MongoDB Atlas account or compatible MongoDB deployment.
- Git.
- Postman or equivalent API client.
- Flutter SDK.
- Dart SDK, normally included with Flutter.
- Android Studio and Android SDK.
- Visual Studio Code or another suitable IDE.

The backend can be developed and tested independently before the Flutter application is integrated.

### 15.2 Clone the Repository

Use the repository URL for the actual project:

```bash
git clone YOUR_REPOSITORY_URL
cd Worabe_Transport/worabe-transport-api
```

If the project is already on your computer, navigate to the existing backend folder instead.

### 15.3 Install Backend Dependencies

```bash
npm install
```

This installs the dependencies listed in `package.json`.

### 15.4 Configure Environment Variables

Create a `.env` file in the backend root.

Example configuration:

```dotenv
PORT=5000
MONGODB_URI=YOUR_MONGODB_CONNECTION_STRING
JWT_SECRET=YOUR_LONG_RANDOM_SECRET
CLIENT_ORIGIN=http://localhost:3000

ADMIN_FULL_NAME=System Administrator
ADMIN_PHONE=YOUR_ADMIN_PHONE
ADMIN_PASSWORD=YOUR_STRONG_ADMIN_PASSWORD
```

These names are illustrative. Confirm the actual names used by the source code before running the application.

#### Configuration Notes

**PORT**

Defines the HTTP port used by the server.

**MONGODB_URI**

Contains the MongoDB connection string. It may include sensitive credentials and must not be committed to version control.

**JWT_SECRET**

Used to sign or verify authentication tokens, depending on the JWT implementation.

**CLIENT_ORIGIN**

Defines the permitted browser origin or origins for CORS. It is especially relevant to browser-based applications and administrative dashboards.

**ADMIN_FULL_NAME, ADMIN_PHONE, ADMIN_PASSWORD**

Used by the initial administrator setup script if it reads these variables.

### 15.5 Protect Secrets

Add `.env` to `.gitignore`.

Example:

```gitignore
node_modules/
.env
.env.*
!.env.example
coverage/
dist/
build/
```

A safe `.env.example` may contain variable names and placeholders but must not contain real secrets.

If a secret is accidentally committed, removing it from the latest file is not sufficient. Rotate the secret and follow the repository's cleanup procedure.

### 15.6 Configure MongoDB Atlas

1. Create or select a MongoDB Atlas project.
2. Create a database user.
3. Configure network access appropriately for development.
4. Obtain the connection string.
5. Set the database URI in `.env`.
6. Start the backend and verify the connection.
7. Confirm that the deployment supports transactions.

The current application uses the database name `worabe_transport` in its configured database connection, with driver profiles stored in the `bajaj` collection through the Mongoose model configuration.

Do not use broad network access or excessive database privileges as a permanent production configuration.

---

## 16. Running the Backend

### 16.1 Start the Development Server

Navigate to the backend folder:

```bash
cd ~/Documents/werabe/Worabe_Transport/worabe-transport-api
```

Install dependencies if necessary:

```bash
npm install
```

Start the server:

```bash
npm run dev
```

If `package.json` defines the expected Nodemon script, the server will restart when relevant files change.

### 16.2 Verify the Health Endpoint

Send a GET request to:

```text
http://localhost:5000/api/health
```

A successful response confirms that the health endpoint is reachable. It does not prove that every database operation, transaction, or business rule works correctly.

### 16.3 Create the First Administrator

If the setup script exists and uses the environment variables described above:

```bash
node scripts/createAdmin.js
```

Check the script output. If an administrator already exists, follow the script's intended behavior rather than creating duplicate administrator records.

Never create the initial administrator through unrestricted public registration.

### 16.4 Test Authentication

Use Postman to test:

1. Passenger registration.
2. Driver registration.
3. Login with valid credentials.
4. Login with invalid credentials.
5. Access to `/api/auth/me` with a valid token.
6. Access to protected endpoints without a token.
7. Access to role-restricted endpoints with the wrong role.

### 16.5 Test Driver Verification

1. Register a driver.
2. Confirm that the profile is pending and offline.
3. Log in as an administrator.
4. Retrieve pending drivers.
5. Approve the test driver.
6. Log in as the driver.
7. Switch availability to online.
8. Confirm that the driver appears in the eligible directory.

### 16.6 Test the Ride Lifecycle

1. Register or log in as a passenger.
2. Ensure an approved test driver is online.
3. Create a ride request.
4. Verify that the request is pending.
5. Log in as the assigned driver.
6. Accept the request.
7. Verify that the request is accepted.
8. Test cancellation on a separate accepted ride.
9. Test completion on another accepted ride.
10. Verify that active-ride reservations are released.

Also test rejection and duplicate request retries.

---

## 17. Flutter Setup and Integration

### 17.1 Create or Open the Flutter Project

If the mobile project has not been created yet:

```bash
flutter create worabe_transport
cd worabe_transport
```

If the project already exists, open its directory instead of creating a second project.

### 17.2 Check Flutter Configuration

Run:

```bash
flutter doctor
```

Resolve required Android SDK, emulator, and toolchain issues.

Check the project:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Tests may be minimal before features are implemented, but these commands should be part of the development workflow.

### 17.3 Configure Dependencies

Add the required packages through the Flutter package manager and verify their compatibility.

The planned dependencies include Riverpod, GoRouter, Dio, sqflite, flutter_secure_storage, and connectivity_plus.

Do not manually guess dependency versions. Use compatible versions and commit the resulting dependency lockfile for the application.

### 17.4 Configure the API Base URL

The Flutter application must point to the correct backend address.

Common development examples:

- Android Emulator: `http://10.0.2.2:5000`
- Physical Android device: the development computer's reachable local IP and port.
- Production: the deployed HTTPS API domain.

The Android Emulator normally uses `10.0.2.2` to reach the host computer's loopback interface.

A physical device cannot normally reach the development computer through `localhost`. Both devices must be able to communicate over the network, and the server must listen on a reachable interface.

Plain HTTP may be blocked by Android network security configuration. For production, use HTTPS.

### 17.5 Implement the API Client

The shared Dio client should configure the base URL and request timeouts.

Authentication tokens can be added through an interceptor or a shared API layer. The implementation should avoid adding tokens to public requests unnecessarily.

The API client should convert network exceptions into application-level errors that screens can display meaningfully.

### 17.6 Implement Features in Order

Recommended order:

1. App entry point, theme, and navigation.
2. Localization.
3. API configuration and Dio.
4. Secure token storage.
5. Registration and login.
6. Current user state.
7. Driver directory.
8. Driver availability.
9. Ride request creation.
10. Driver response actions.
11. Ride cancellation and completion.
12. Ride history.
13. Complaint submission and administration-facing views.
14. Offline caching and drafts.
15. Integration testing.

This order reduces the risk of building screens on top of an unstable API contract.

### 17.7 Verify End-to-End Integration

For each feature, verify the entire path:

1. User action in Flutter.
2. Input validation.
3. API request.
4. JWT authentication.
5. Backend authorization.
6. Business-rule validation.
7. Database operation.
8. API response.
9. State update.
10. Updated user interface.

A successful API request in Postman does not prove the Flutter integration is correct. Both should be tested.

---

## 18. Authentication and Authorization

### 18.1 Registration

Public registration is intended for passengers and drivers.

The backend should validate all required fields and reject invalid role values. A public request must not be able to create an administrator account.

### 18.2 Password Handling

Passwords should be hashed using bcrypt before storage. The password hash should not be returned in API responses.

### 18.3 JWT Authentication

After successful login, the backend issues a JWT. Protected requests use:

```http
Authorization: Bearer YOUR_JWT_TOKEN
```

The authentication middleware verifies the token and identifies the user.

The actual token expiration and payload configuration should be documented from the implementation.

### 18.4 Role-Based Authorization

Typical permissions include:

| Operation | Passenger | Driver | Admin |
|---|---|---|---|
| Register a public account | Yes | Yes | No public admin registration |
| Request a ride | Yes | No | No, unless explicitly implemented |
| Manage driver availability | No | Own profile | Administrative actions as implemented |
| Accept a ride | No | Assigned driver | No, unless explicitly implemented |
| Cancel own ride | Eligible ride | No | No, unless explicitly implemented |
| Complete an assigned ride | No | Assigned driver | No, unless explicitly implemented |
| Verify drivers | No | No | Yes |
| Manage complaints | Submit and view own | Submit and view own | Administrative management |

These permissions must be enforced on the server, not only in the Flutter interface.

---

## 19. Ride Lifecycle and Business Rules

### 19.1 Statuses

A ride can have one of the following statuses:

- `pending`: the selected driver has not responded.
- `accepted`: the selected driver accepted the request.
- `rejected`: the selected driver rejected the request.
- `cancelled`: an eligible request was cancelled.
- `completed`: the assigned driver completed the ride.

### 19.2 Expected Transitions

```text
               +------------------+
               |      Pending     |
               +------------------+
                  |      |      |
            Accept   Reject  Cancel
                  |      |      |
                  v      v      v
              Accepted Rejected Cancelled
                  |
               Complete
                  |
                  v
              Completed
```

The diagram describes the intended workflow. Exact transition rules must match the controller implementation.

### 19.3 Driver Eligibility

A driver must be approved and verified to become online and receive eligible requests.

The backend must check driver eligibility when processing a request rather than trusting a status supplied by the client.

### 19.4 One Active Ride per Passenger

The passenger's active-ride reservation is intended to prevent a second active request while the first remains pending or accepted.

The controller must acquire and release reservations consistently.

### 19.5 One Active Ride per Driver

The driver's active-ride reservation is intended to prevent the same driver from accepting multiple active rides.

Simultaneous acceptance attempts must be tested because ordinary application-level checks alone are insufficient to prevent every race condition.

### 19.6 Transactions

The current ride controller uses MongoDB transactions to coordinate related changes to ride and user records.

Transactions require a compatible MongoDB deployment. If the database deployment does not support transactions, the ride operations must be redesigned or the database configuration corrected.

### 19.7 Idempotency

A client may retry a request when a network timeout occurs even if the server already created the ride.

The idempotency key helps identify the same logical operation across retries. The key should be unique for the passenger's logical request and reused only for retries of that request.

The implementation must be tested to confirm that duplicate keys do not create additional ride records and that the original result is returned consistently.

### 19.8 Existing Active Rides

When active-ride fields are introduced to an existing database, older ride records may not automatically populate those fields.

Before enabling the system for real users, existing pending and accepted rides must be reconciled. Otherwise, a user with an existing active ride might appear to have an empty reservation slot.

A migration or reconciliation procedure should be developed and tested before production use.

---

## 20. Offline-First and Synchronization Strategy

### 20.1 Design Principle

The mobile application is intended to support unreliable connectivity, while the backend remains the source of truth for critical operations.

Offline-first design does not mean that a ride is confirmed while the device is disconnected.

### 20.2 Data Suitable for Caching

Potentially cacheable data includes:

- Driver directory information.
- Service areas and destination descriptions.
- Previously retrieved ride history.
- Locally created ride-request drafts.
- Non-sensitive interface preferences.

Cached information should have a clear freshness policy and should not be presented as guaranteed current availability.

### 20.3 Offline Ride Drafts

When a passenger is offline, the app may allow them to prepare a ride-request draft.

The draft should remain local until the user reconnects and explicitly confirms submission.

The app should clearly distinguish:

- A local draft.
- A request currently being submitted.
- A server-confirmed pending request.
- A request accepted or otherwise updated by the server.

### 20.4 Synchronization Flow

1. Detect a connectivity change.
2. Attempt to reach the backend rather than assuming internet access is available.
3. Refresh appropriate server-owned data.
4. Present offline drafts to the user.
5. Let the user review and explicitly submit a draft.
6. Send the request using a stable idempotency key.
7. Save the confirmed server result.
8. Display the resulting ride status.

The application should not automatically dispatch stale offline requests without confirmation.

### 20.5 Conflict Handling

The server may reject an offline draft because:

- The selected driver is now offline.
- The driver is no longer verified.
- The passenger has another active ride.
- The driver has another active ride.
- The request is invalid.
- The account is inactive.
- The request is a duplicate.

The Flutter application must display the rejection and let the user take an appropriate next action.

### 20.6 Connectivity Limitations

The `connectivity_plus` package reports network connectivity changes, but a Wi-Fi or mobile-data connection does not prove that the backend is reachable.

The application must handle timeouts, unreachable servers, and temporary service failures independently.

---

## 21. Localization

The initial localization plan supports English and Amharic.

### 21.1 Supported Languages

| Language | Code | Planned status |
|---|---|---|
| English | `en` | Initial language |
| Amharic | `am` | Initial language |
| Silte | To be defined | Future consideration |

### 21.2 Translation Scope

Localized content should include:

- Navigation labels.
- Form labels and placeholders.
- Validation messages.
- Authentication errors.
- Driver availability labels.
- Ride statuses.
- Cancellation and completion messages.
- Complaint categories.
- General error messages.
- Profile and settings labels.

### 21.3 Language Preference

The user's preferred language is represented by the `preferredLanguage` field in the backend model.

The Flutter application should use a consistent language-selection and persistence strategy.

---

## 22. Security and Privacy

Security is important because the system handles personal information, authentication credentials, driver details, ride records, and complaints.

### 22.1 Authentication

Protected endpoints must verify the authentication token and reject invalid or expired credentials.

### 22.2 Authorization

The backend must verify role, record ownership, and assigned-driver relationships before performing sensitive operations.

### 22.3 Password Security

Store only password hashes. Never log or return passwords or password hashes.

### 22.4 Environment Secrets

Do not commit database URIs, JWT secrets, administrator passwords, or other sensitive credentials.

### 22.5 Request Validation

Validate:

- Required fields.
- String lengths.
- Phone number format.
- Permitted role values.
- Permitted status transitions.
- MongoDB identifiers.
- Complaint categories.
- Pickup and destination descriptions.
- Idempotency keys.

### 22.6 Driver Verification

Only administrators should approve or reject drivers. A driver must not be able to change their own verification status through public endpoints.

### 22.7 Ride Ownership

The backend must verify the relationship between the authenticated user and a ride before allowing cancellation, completion, response, or history access.

### 22.8 Rate Limiting

Rate limiting should be configured for authentication and other sensitive endpoints to reduce abuse.

### 22.9 Production Transport Security

Production clients should communicate with the API over HTTPS.

### 22.10 Privacy

Only collect the personal information needed for the service. Restrict access to ride and complaint records and define a suitable data-retention policy before real-world deployment.

### 22.11 Operational Readiness

Before production, review database access, backups, logs, token expiration, account deactivation, monitoring, and recovery procedures.

This section describes security requirements and mechanisms; it does not replace a security audit.

---

## 23. Error Handling

The backend and Flutter application should communicate failures clearly and consistently.

### 23.1 Common HTTP Status Codes

| Status | Meaning | Typical use |
|---|---|---|
| `200 OK` | Request succeeded | Reading or updating a resource |
| `201 Created` | Resource created | Successful ride creation |
| `400 Bad Request` | Invalid request | Missing or invalid fields |
| `401 Unauthorized` | Authentication required or invalid | Missing or invalid JWT |
| `403 Forbidden` | Operation not permitted | Role or permission failure |
| `404 Not Found` | Resource not found | Missing ride or profile |
| `409 Conflict` | State conflict | Active-ride restriction |
| `429 Too Many Requests` | Rate limit exceeded | Excessive requests |
| `500 Internal Server Error` | Unexpected server error | Unhandled failure |

The exact status code for each condition must be verified against the implementation.

### 23.2 Backend Error Handling

The backend should:

- Validate input before database operations.
- Use a centralized error handler.
- Return safe and understandable messages.
- Avoid exposing stack traces in production.
- Log useful operational information without logging secrets.
- Distinguish validation failures from conflicts and unexpected errors.

### 23.3 Flutter Error Handling

The mobile app should provide useful messages for:

- Invalid credentials.
- Expired sessions.
- Missing required fields.
- Network timeouts.
- Unreachable API servers.
- Driver unavailability.
- Existing active rides.
- Failed ride transitions.
- Unexpected server failures.

The interface should avoid displaying raw internal stack traces or technical exceptions to users.

---

## 24. Testing Strategy

### 24.1 Backend Unit Tests

Test validation and business rules independently where practical.

Potential targets include:

- Registration validation.
- Role restrictions.
- Ride-state transition rules.
- Complaint validation.
- Driver verification requirements.

### 24.2 Backend Integration Tests

Test endpoints against a suitable test database.

Required scenarios include:

- Successful and failed registration.
- Successful and failed login.
- Token validation.
- Role authorization.
- Driver approval.
- Driver availability changes.
- Ride creation.
- Driver acceptance and rejection.
- Passenger cancellation.
- Driver completion.
- Complaint creation and review.
- Duplicate idempotency keys.

### 24.3 Concurrency Tests

Test simultaneous operations, including:

- Two ride requests from the same passenger.
- Two drivers or requests competing for an active slot.
- One driver receiving multiple requests and attempting to accept them.
- Cancellation racing with acceptance.
- Repeated requests using the same idempotency key.
- Transaction failure and retry behavior.

### 24.4 Flutter Tests

Potential Flutter tests include:

- Widget tests for registration and login forms.
- State-management tests.
- API client tests using mocked responses.
- Navigation tests.
- Offline draft tests.
- Localization tests.
- Error-state tests.

### 24.5 End-to-End Tests

Test the full journey from Flutter through the backend to MongoDB.

At minimum, verify:

1. Passenger registers.
2. Driver registers.
3. Administrator approves the driver.
4. Driver goes online.
5. Passenger creates a request.
6. Driver accepts the request.
7. Passenger and driver see the correct status.
8. The ride is cancelled or completed.
9. Active reservations are released.
10. Ride history reflects the final status.

### 24.6 Production Readiness Checklist

- [ ] Server starts reliably.
- [ ] Database connection and transaction behavior are verified.
- [ ] Registration and login work.
- [ ] Passwords are hashed.
- [ ] JWT authentication works.
- [ ] Administrator permissions are protected.
- [ ] Driver verification is enforced.
- [ ] Passenger and driver ownership rules are enforced.
- [ ] Active-ride restrictions are tested.
- [ ] Idempotent retries are tested.
- [ ] Existing active rides are reconciled.
- [ ] Complaint authorization is tested.
- [ ] Flutter API integration works.
- [ ] Offline drafts are not treated as confirmed rides.
- [ ] Production secrets are configured securely.
- [ ] HTTPS is configured for deployment.
- [ ] Backups and recovery procedures are documented.
- [ ] Privacy and operational policies are defined.

---

## 25. Troubleshooting

### 25.1 `npm run dev` Fails

Check that:

- The terminal is in the backend folder.
- `package.json` exists.
- Dependencies are installed.
- The development script is defined.
- The error message does not indicate a syntax or missing-module problem.

Run:

```bash
npm install
npm run dev
```

### 25.2 MongoDB Connection Failure

Check:

- The MongoDB URI.
- Database credentials.
- Atlas network access configuration.
- Whether the database deployment is available.
- Whether environment variables are loaded correctly.

Do not publish the full database connection string in an issue or screenshot.

### 25.3 Transactions Not Supported

Ride operations that use MongoDB transactions require a compatible replica-set or sharded deployment.

Confirm the MongoDB deployment configuration before changing the ride controller. Do not silently remove transactions without designing a safe alternative.

### 25.4 `401 Unauthorized`

Check that:

- The token was issued by the correct backend.
- The request includes the bearer-token header.
- The token is valid and not expired.
- The server uses the expected JWT secret.

### 25.5 `403 Forbidden`

The user may be authenticated but lack the required role or ownership permission. Confirm that the correct account is being used for the operation.

### 25.6 Duplicate Phone Number

Phone numbers are unique in the current user model. Use a new test number or the intended account-recovery procedure.

### 25.7 Driver Cannot Go Online

Check that:

- The driver profile exists.
- The driver has been approved.
- The verification flag is correct.
- The request uses the driver token.
- The availability value matches the schema.

### 25.8 Ride Request Rejected

Check:

- Driver ID correctness.
- Driver approval and verification.
- Driver availability.
- Passenger active-ride state.
- Required pickup and destination fields.
- Authentication and authorization.
- Transaction errors.

### 25.9 Flutter Cannot Reach the API

Check:

- The base URL.
- Whether the backend is running.
- Android Emulator networking.
- Physical-device network access.
- Firewall rules.
- Android network security configuration.
- Whether the server is listening on a reachable interface.

For the standard Android Emulator, `10.0.2.2` typically routes to the host computer.

### 25.10 Offline Draft Does Not Synchronize

Check that:

- The app can actually reach the backend.
- The draft is still available locally.
- The user explicitly confirmed submission.
- The idempotency key is stable across retries.
- The server has not rejected the request because of a state conflict.
- The UI distinguishes local drafts from confirmed requests.

---

## 26. Development Roadmap

### Phase 1: Backend Stabilization

- Verify all routes.
- Test authentication and authorization.
- Validate request and response formats.
- Test ride transactions.
- Test concurrent requests.
- Reconcile existing active rides.
- Improve validation and error handling.
- Finalize the API contract.

### Phase 2: Flutter Foundation

- Create the Flutter project.
- Configure dependencies.
- Establish routing and theme.
- Configure localization.
- Build the Dio API client.
- Implement secure token storage.
- Set up Riverpod.

### Phase 3: Authentication and Profiles

- Passenger registration and login.
- Driver registration and login.
- Current-user retrieval.
- Driver verification status.
- Account and language settings.

### Phase 4: Core Ride Features

- Driver directory.
- Driver details.
- Availability management.
- Passenger ride request.
- Driver accept/reject workflow.
- Ride cancellation.
- Ride completion.
- Ride history.

### Phase 5: Complaint Management

- Complaint form.
- Complaint validation.
- Complaint history.
- Administrative complaint review.

### Phase 6: Offline-Aware Experience

- SQLite setup.
- Driver directory caching.
- Offline ride drafts.
- Explicit resubmission.
- Idempotent retries.
- Synchronization and conflict handling.

### Phase 7: Administrative Interface

- Driver verification dashboard.
- Complaint management dashboard.
- Administrative search and filtering.
- Audit and operational reporting.

### Phase 8: Production Preparation

- Secure deployment.
- HTTPS configuration.
- Secret management.
- Database backup and recovery.
- Monitoring and logging.
- Security review.
- End-to-end testing.
- Pilot deployment and feedback.

### Phase 9: Future Enhancements

Evaluate additional features based on actual user needs, reliability, cost, and operational requirements.

---

## 27. Deployment Considerations

### 27.1 Backend Hosting

The backend can be deployed to a suitable Node.js hosting environment. The chosen provider must support the application's runtime, network access, and operational needs.

### 27.2 Database Deployment

MongoDB Atlas can host the database. Production credentials, database permissions, backups, and network restrictions must be configured appropriately.

### 27.3 Flutter Distribution

The Android application can eventually be distributed through a suitable Android application distribution channel.

Before release, verify the app's permissions, signing configuration, API base URL, production HTTPS connection, and handling of authentication credentials.

### 27.4 Environment Separation

Maintain separate configuration for development, testing, and production.

Production should not rely on development URLs, test accounts, weak secrets, or permissive network settings.

### 27.5 Monitoring and Recovery

Production operations should include:

- Health monitoring.
- Application error monitoring.
- Database backup procedures.
- Log review.
- Incident response.
- Recovery testing.
- A procedure for handling account or data issues.

---

## 28. Limitations and Future Improvements

### 28.1 Current Limitations

The initial design does not require live maps or GPS coordinates. Pickup and destination locations are represented as text descriptions.

The system does not automatically assign drivers. Passengers choose a specific driver.

The backend's agreed-fare field does not by itself implement fare calculation, negotiation, or payment processing.

The offline-aware mobile experience still requires implementation and validation. Local caching alone is not sufficient to guarantee reliable synchronization.

### 28.2 Potential Future Improvements

Possible future features include:

- Better destination and landmark search.
- Driver service-area management.
- Configurable fare agreements.
- Push notifications.
- Live GPS tracking.
- Map-based pickup and destination selection.
- Ratings and feedback.
- Additional languages, including Silte.
- Administrative analytics.
- Driver and passenger support workflows.
- Improved reporting and audit history.
- More advanced offline synchronization.

Future additions should preserve the core security rules and should not introduce features that the available infrastructure cannot support reliably.

---

## 29. Contribution Guidelines

Contributions should prioritize correctness, maintainability, and user safety.

### 29.1 Development Principles

- Keep controllers focused on their feature responsibilities.
- Validate inputs at the backend boundary.
- Enforce authorization on the server.
- Avoid duplicating business rules unnecessarily.
- Use descriptive names.
- Handle asynchronous operations and errors explicitly.
- Add tests for new business rules.
- Update the README when endpoints or behavior change.
- Never commit secrets or real user data.

### 29.2 Suggested Workflow

1. Create a feature branch.
2. Make a focused change.
3. Run the relevant tests.
4. Review the diff for secrets and unintended changes.
5. Update documentation if necessary.
6. Submit the change for review.

### 29.3 API Changes

When modifying an endpoint, document:

- HTTP method and path.
- Required role.
- Request fields.
- Validation rules.
- Response structure.
- Possible error statuses.
- Side effects on database records.

This keeps the Flutter client and backend aligned.

---

## 30. License

A license has not yet been specified.

Before making the project public, choose a license that reflects how the code may be used, modified, and redistributed. Until then, do not assume that public repository access automatically grants permission to reuse the code.

---

## Final Project Summary

Worabe Transport is a Bajaj-focused transportation system designed for the local needs of Worabe, Ethiopia.

Its backend provides account management, driver verification, availability controls, direct ride requests, ride lifecycle management, ride history, and complaint administration. The planned Flutter application provides passenger and driver interfaces, with Riverpod state management, GoRouter navigation, Dio API communication, and an offline-aware local storage strategy.

The development priority is to stabilize the backend, verify all critical business rules, integrate the Flutter application, and test the complete passenger-driver journey under realistic network conditions.

**Project status:** Core backend implementation in progress; Flutter implementation and end-to-end readiness must be assessed against the actual source code and test results.

The goal is not merely to build an API or a mobile interface, but to develop a reliable, secure, and maintainable transportation service that can be validated with real users in Worabe.
