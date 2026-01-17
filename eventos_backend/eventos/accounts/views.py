# accounts/views.py
# API Views for User Authentication

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import logout

from .serializers import (
    SignupSerializer,
    LoginSerializer,
    AdminUserSerializer,
    UserProfileUpdateSerializer
)
from .models import AdminUser


@api_view(['POST'])
@permission_classes([AllowAny])
def signup_view(request):
    """
    User Registration Endpoint
    
    POST /api/auth/signup/
    Body: {
        "username": "newuser",
        "email": "newuser@example.com",
        "password": "SecurePass123!",
        "password_confirm": "SecurePass123!",
        "first_name": "John",
        "last_name": "Doe",
        "organization": "CSI"
    }
    
    Returns: {
        "success": true,
        "message": "Registration successful",
        "data": {
            "user": {...},
            "tokens": {
                "access": "...",
                "refresh": "..."
            }
        }
    }
    """
    serializer = SignupSerializer(data=request.data)
    
    if serializer.is_valid():
        # Create new user
        user = serializer.save()
        
        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)
        
        # Get user information
        user_serializer = AdminUserSerializer(user)
        
        return Response({
            'success': True,
            'message': 'Registration successful',
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


@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    """
    User Login Endpoint
    
    POST /api/auth/login/
    Body: {
        "username": "admin",
        "password": "admin"
    }
    
    Returns: {
        "success": true,
        "message": "Login successful",
        "data": {
            "user": {...},
            "tokens": {
                "access": "...",
                "refresh": "..."
            }
        }
    }
    """
    serializer = LoginSerializer(data=request.data)
    
    if serializer.is_valid():
        user = serializer.validated_data['user']
        
        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)
        
        # Get user information
        user_serializer = AdminUserSerializer(user)
        
        return Response({
            'success': True,
            'message': 'Login successful',
            'data': {
                'user': user_serializer.data,
                'tokens': {
                    'access': str(refresh.access_token),
                    'refresh': str(refresh),
                }
            }
        }, status=status.HTTP_200_OK)
    
    return Response({
        'success': False,
        'message': 'Invalid credentials',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """
    User Logout Endpoint
    
    POST /api/auth/logout/
    Headers: Authorization: Bearer <access_token>
    
    Returns: {
        "success": true,
        "message": "Logout successful"
    }
    """
    try:
        # Logout from Django session
        logout(request)
        
        return Response({
            'success': True,
            'message': 'Logout successful'
        }, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({
            'success': False,
            'message': f'Logout failed: {str(e)}'
        }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_profile(request):
    """
    Get Current User Profile
    
    GET /api/auth/profile/
    Headers: Authorization: Bearer <access_token>
    
    Returns: {
        "success": true,
        "data": {...}
    }
    """
    serializer = AdminUserSerializer(request.user)
    return Response({
        'success': True,
        'data': serializer.data
    }, status=status.HTTP_200_OK)


@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated])
def update_profile(request):
    """
    Update User Profile
    
    PUT/PATCH /api/auth/profile/update/
    Headers: Authorization: Bearer <access_token>
    Body: {
        "first_name": "John",
        "last_name": "Doe",
        "email": "john@example.com"
    }
    
    Returns: {
        "success": true,
        "message": "Profile updated successfully",
        "data": {...}
    }
    """
    serializer = UserProfileUpdateSerializer(
        request.user,
        data=request.data,
        partial=True,
        context={'request': request}
    )
    
    if serializer.is_valid():
        serializer.save()
        
        # Return updated user data
        user_serializer = AdminUserSerializer(request.user)
        
        return Response({
            'success': True,
            'message': 'Profile updated successfully',
            'data': user_serializer.data
        }, status=status.HTTP_200_OK)
    
    return Response({
        'success': False,
        'message': 'Validation failed',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    """
    API Health Check
    
    GET /api/health/
    
    Returns: {
        "status": "ok",
        "message": "Eventos API is running"
    }
    """
    return Response({
        'status': 'ok',
        'message': 'Eventos API is running',
        'version': '1.0.0'
    }, status=status.HTTP_200_OK)
