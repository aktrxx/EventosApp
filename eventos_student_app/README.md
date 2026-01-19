# Eventos User App

Flutter mobile application for users to discover, view, and register for events organized by different organizations.

## Features

### 🔐 Authentication
- User login with email and password
- User registration with full name, email, phone, and password
- JWT token-based authentication
- Secure session management

### 🏠 Home Page
- Organization categories displayed in a beautiful grid
- Quick access to events from each organization:
  - CSI Association
  - IE Association
  - GLUGOT TCE
  - IT Department
  - MECH Department
  - Sports
  - College Events

### 📅 Event Management
- **Browse Events**: View all events from each organization
- **Event Details**: See complete event information (date, time, venue, description)
- **Event Registration**: Register for events with one click
- **Withdraw Registration**: Withdraw from registered events if needed

### 📱 My Registrations
- View all registered events in one place
- See registration status (Confirmed, Pending, etc.)
- Quick access to event details

### 👤 Profile Management
- View profile information (name, email, phone)
- Edit profile (coming soon)
- Change password (coming soon)
- Notification settings (coming soon)
- Logout functionality

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: StatefulWidget
- **HTTP Client**: http package
- **Local Storage**: shared_preferences
- **Backend API**: Django REST Framework

## Color Scheme

- Primary: Purple (#6A1B9A)
- Secondary: Light Purple (#AB47BC)
- Background: White/Light Gray
- Success: Green (#4CAF50)
- Error: Red (#F44336)

## Project Structure

```
lib/
├── main.dart                       # App entry point
├── utils/
│   └── colors.dart                 # Color constants
└── pages/
    ├── login_page.dart             # Login screen
    ├── signup_page.dart            # Registration screen
    ├── home_page.dart              # Home with organization categories
    ├── events_list_page.dart       # Events from specific organization
    ├── event_detail_page.dart      # Event details and registration
    ├── my_registrations_page.dart  # User's registered events
    └── profile_page.dart           # User profile and settings
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android Emulator / Physical Device

### Installation

1. Navigate to the project directory:
```bash
cd eventos_user_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## API Integration (TODO)

The app is ready for backend integration with Django REST Framework. The following endpoints need to be implemented:

### Authentication
- `POST /api/users/signup/` - User registration
- `POST /api/users/login/` - User login
- `POST /api/users/logout/` - User logout
- `GET /api/users/profile/` - Get user profile

### Events
- `GET /api/events/` - Get all events
- `GET /api/events/?organization=<code>` - Get events by organization
- `GET /api/events/<id>/` - Get event details

### Registrations
- `POST /api/registrations/` - Register for an event
- `GET /api/registrations/my-events/` - Get user's registered events
- `DELETE /api/registrations/<id>/` - Withdraw registration

## UI Features

✅ Beautiful gradient backgrounds
✅ Card-based layouts
✅ Smooth animations
✅ Loading indicators
✅ Error handling
✅ Pull-to-refresh
✅ Bottom navigation
✅ Responsive design
✅ Material Design 3

## Backend Requirements

The Django backend needs to implement:

1. **User Model**: Separate from AdminUser
   - Full name
   - Email (unique)
   - Phone number
   - Password (hashed)
   - Created/Updated timestamps

2. **Registration Model**:
   - User (foreign key)
   - Event (foreign key)
   - Registration date
   - Status (Confirmed, Pending, Cancelled)
   - Created/Updated timestamps

3. **API Permissions**:
   - Users can only view events (read-only)
   - Users can register/withdraw from events
   - Users can only see their own registrations

## Next Steps

1. Create Django backend models (User, Registration)
2. Implement Django REST API endpoints
3. Connect Flutter app to Django backend
4. Add JWT token storage with SharedPreferences
5. Implement error handling and validation
6. Add image support for event posters
7. Add search and filter functionality
8. Add push notifications

## Testing

The app currently uses dummy data for UI testing. Once the backend is connected, all features will work with real data.

---

**Created**: January 18, 2026  
**Framework**: Flutter 3.x  
**Backend**: Django REST Framework (to be implemented)
