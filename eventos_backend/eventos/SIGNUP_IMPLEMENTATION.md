# 🔐 User Signup/Registration Implementation Guide

## 📋 Overview

Add user registration/signup functionality to allow new users to create accounts.

---

## 🔧 Backend Implementation (Django)

### Step 1: Update `accounts/serializers.py`

**Add this import at the top:**
```python
from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import AdminUser
```

**Add the SignupSerializer class** (copy from `signup_code.py`):

```python
class SignupSerializer(serializers.ModelSerializer):
    """Serializer for user registration/signup"""
    password = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'},
        min_length=8
    )
    password_confirm = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'}
    )
    
    class Meta:
        model = AdminUser
        fields = [
            'username',
            'email',
            'password',
            'password_confirm',
            'organization',
            'first_name',
            'last_name'
        ]
        extra_kwargs = {
            'email': {'required': True},
            'organization': {'required': True}
        }
    
    def validate_username(self, value):
        """Check if username already exists"""
        if AdminUser.objects.filter(username=value).exists():
            raise serializers.ValidationError('Username already exists.')
        return value
    
    def validate_email(self, value):
        """Check if email already exists"""
        if AdminUser.objects.filter(email=value).exists():
            raise serializers.ValidationError('Email already exists.')
        return value
    
    def validate(self, data):
        """Check if passwords match"""
        if data.get('password') != data.get('password_confirm'):
            raise serializers.ValidationError({
                'password_confirm': 'Passwords do not match.'
            })
        return data
    
    def create(self, validated_data):
        """Create new user with hashed password"""
        validated_data.pop('password_confirm')
        
        user = AdminUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            organization=validated_data['organization'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        
        return user
```

### Step 2: Update `accounts/views.py`

**Add the import:**
```python
from .serializers import (
    LoginSerializer,
    SignupSerializer,  # ADD THIS
    AdminUserSerializer,
    UserProfileUpdateSerializer
)
```

**Add the signup view function:**

```python
@api_view(['POST'])
@permission_classes([AllowAny])
def signup_view(request):
    """
    User Registration/Signup Endpoint
    
    POST /api/auth/signup/
    """
    serializer = SignupSerializer(data=request.data)
    
    if serializer.is_valid():
        user = serializer.save()
        
        # Auto-login: Generate JWT tokens
        refresh = RefreshToken.for_user(user)
        user_serializer = AdminUserSerializer(user)
        
        return Response({
            'success': True,
            'message': 'Account created successfully',
            'data': {
                'user': user_serializer.data,
                'tokens': {
                    'access': str(refresh.access_token),
                    'refresh': str(refresh),
                }
            }
        }, status=status.HTTP_201_CREATED)
    
    return Response({
        'success': False,
        'message': 'Registration failed',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)
```

### Step 3: Update `accounts/urls.py`

**Add the signup URL:**

```python
from django.urls import path
from . import views

app_name = 'accounts'

urlpatterns = [
    # Authentication
    path('login/', views.login_view, name='login'),
    path('signup/', views.signup_view, name='signup'),  # ADD THIS
    path('logout/', views.logout_view, name='logout'),
    
    # User Profile
    path('profile/', views.user_profile, name='profile'),
    path('profile/update/', views.update_profile, name='update_profile'),
    
    # Health Check
    path('health/', views.health_check, name='health_check'),
]
```

### Step 4: Restart Django Server

```bash
cd "D:\Personal Projects\EventosApp\eventos_backend\eventos"
venv\Scripts\activate
python manage.py runserver
```

---

## 🧪 Test Signup API

### Using Postman/Thunder Client:

```http
POST http://localhost:8000/api/auth/signup/
Content-Type: application/json

{
  "username": "testuser",
  "email": "testuser@example.com",
  "password": "password123",
  "password_confirm": "password123",
  "organization": "CSI",
  "first_name": "Test",
  "last_name": "User"
}
```

### Expected Response (Success):

```json
{
  "success": true,
  "message": "Account created successfully",
  "data": {
    "user": {
      "id": 9,
      "username": "testuser",
      "email": "testuser@example.com",
      "organization": "CSI",
      "organization_display": "CSI Association",
      "first_name": "Test",
      "last_name": "User",
      "full_name": "Test User",
      "is_active": true,
      "created_at": "2026-01-17T..."
    },
    "tokens": {
      "access": "eyJ0eXAiOiJKV1QiLCJh...",
      "refresh": "eyJ0eXAiOiJKV1QiLCJh..."
    }
  }
}
```

### Expected Response (Error - Duplicate Username):

```json
{
  "success": false,
  "message": "Registration failed",
  "errors": {
    "username": ["Username already exists."]
  }
}
```

### Expected Response (Error - Passwords Don't Match):

```json
{
  "success": false,
  "message": "Registration failed",
  "errors": {
    "password_confirm": ["Passwords do not match."]
  }
}
```

---

## 📱 Flutter Implementation

### Step 1: Add Signup Method to AuthService

**Update `lib/services/auth_service.dart`:**

```dart
/// Sign up new user
Future<Map<String, dynamic>> signup({
  required String username,
  required String email,
  required String password,
  required String passwordConfirm,
  required String organization,
  String firstName = '',
  String lastName = '',
}) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'password_confirm': passwordConfirm,
        'organization': organization,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['success'] == true) {
      // Extract tokens and user data
      _accessToken = data['data']['tokens']['access'];
      _refreshToken = data['data']['tokens']['refresh'];
      _currentUser = AdminUser.fromJson(data['data']['user']);

      // Save tokens
      await _saveTokens();

      return {
        'success': true,
        'message': data['message'],
        'user': _currentUser,
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed',
        'errors': data['errors'] ?? {},
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Network error: ${e.toString()}',
    };
  }
}
```

### Step 2: Create Signup Screen

**Create `lib/signup_screen.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:eventos_admin_new/services/auth_service.dart';
import 'package:eventos_admin_new/AdminHomePage.dart';
import 'package:eventos_admin_new/models/admin_user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  
  String selectedOrganization = 'CSI';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<Map<String, String>> organizations = [
    {'value': 'CSI', 'label': 'CSI Association'},
    {'value': 'IE', 'label': 'IE Association'},
    {'value': 'GLUGOT', 'label': 'GLUGOT TCE'},
    {'value': 'IT', 'label': 'IT Department'},
    {'value': 'MECH', 'label': 'MECH Department'},
    {'value': 'SPORTS', 'label': 'Sports Committee'},
    {'value': 'COLLEGE', 'label': 'College'},
  ];

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    // Call API
    final authService = AuthService();
    final result = await authService.signup(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      passwordConfirm: confirmPasswordController.text,
      organization: selectedOrganization,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
    );

    // Hide loading
    if (mounted) Navigator.pop(context);

    if (result['success'] == true) {
      // Navigate to home
      final user = result['user'] as AdminUser;
      int orgId = _getOrgId(user.organization);
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHome(orgId),
          ),
        );
      }
    } else {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int _getOrgId(String org) {
    const map = {
      'ADMIN': 0, 'CSI': 1, 'IE': 2, 'GLUGOT': 3,
      'IT': 4, 'MECH': 5, 'SPORTS': 6, 'COLLEGE': 7
    };
    return map[org] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 169, 5, 51),
        title: const Text('Create Account'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 169, 5, 51),
              Color.fromARGB(255, 220, 133, 194),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Username
                  TextFormField(
                    controller: usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.person, color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.email, color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Organization Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedOrganization,
                    dropdownColor: const Color.fromARGB(255, 169, 5, 51),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Organization',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.business, color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    items: organizations.map((org) {
                      return DropdownMenuItem(
                        value: org['value'],
                        child: Text(org['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedOrganization = value!);
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 169, 5, 51),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Back to Login
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Step 3: Add "Sign Up" Button to Login Screen

**Update `lib/tempAdminLogin.dart`:**

Add this import at the top:
```dart
import 'package:eventos_admin_new/signup_screen.dart';
```

Add this button after the test credentials container:

```dart
// After the test credentials container
SizedBox(height: 16),

// Sign Up Button
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      ),
    );
  },
  child: Text(
    "Don't have an account? Sign Up",
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
),
```

---

## ✅ Summary

**What You Get:**

1. ✅ **Signup API** - `/api/auth/signup/`
2. ✅ **Username validation** - Checks if already exists
3. ✅ **Email validation** - Checks if already exists
4. ✅ **Password validation** - Min 8 characters, must match
5. ✅ **Auto-login** - Returns JWT tokens immediately
6. ✅ **Flutter signup screen** - Complete UI with validation
7. ✅ **Organization selection** - Dropdown to choose organization

**Flow:**
```
User fills signup form → Submit → Django validates → Creates user in MySQL → 
Returns tokens → Auto-login → Navigate to Admin Home
```

**Test it:**
1. Update Django code (serializers, views, urls)
2. Restart Django server
3. Add Flutter signup screen
4. Run Flutter app
5. Click "Sign Up" on login screen
6. Fill form and create account!

🎉 **New users can now register themselves!**