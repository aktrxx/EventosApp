# accounts/serializers.py
# API Serializers for User Authentication

from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from .models import AdminUser


class SignupSerializer(serializers.ModelSerializer):
    """
    Serializer for user registration
    """
    password = serializers.CharField(
        write_only=True,
        required=True,
        validators=[validate_password],
        style={'input_type': 'password'}
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
            'first_name',
            'last_name',
            'organization'
        ]
        extra_kwargs = {
            'first_name': {'required': True},
            'last_name': {'required': True},
            'email': {'required': True}
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
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({
                'password_confirm': 'Passwords do not match.'
            })
        return data
    
    def create(self, validated_data):
        """Create new user"""
        # Remove password_confirm as it's not needed for user creation
        validated_data.pop('password_confirm')
        
        # Create user using create_user to properly hash the password
        user = AdminUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
            organization=validated_data.get('organization', 'ADMIN')
        )
        
        return user


class LoginSerializer(serializers.Serializer):
    """
    Serializer for user login
    Validates username and password
    """
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True, write_only=True)
    
    def validate(self, data):
        username = data.get('username')
        password = data.get('password')
        
        if not username or not password:
            raise serializers.ValidationError('Must include username and password.')
        
        # Authenticate user
        user = authenticate(username=username, password=password)
        
        if user:
            if user.is_active:
                data['user'] = user
            else:
                raise serializers.ValidationError('User account is disabled.')
        else:
            raise serializers.ValidationError('Invalid username or password.')
        
        return data


class AdminUserSerializer(serializers.ModelSerializer):
    """
    Serializer for admin user information
    Returns user details without sensitive data
    """
    organization_display = serializers.CharField(
        source='get_organization_display',
        read_only=True
    )
    full_name = serializers.CharField(
        source='get_full_name',
        read_only=True
    )
    
    class Meta:
        model = AdminUser
        fields = [
            'id',
            'username',
            'email',
            'organization',
            'organization_display',
            'first_name',
            'last_name',
            'full_name',
            'is_active',
            'created_at',
        ]
        read_only_fields = ['id', 'created_at']


class UserProfileUpdateSerializer(serializers.ModelSerializer):
    """
    Serializer for updating user profile
    """
    class Meta:
        model = AdminUser
        fields = ['first_name', 'last_name', 'email']
    
    def validate_email(self, value):
        """Check if email is already in use"""
        user = self.context.get('request').user
        if AdminUser.objects.exclude(pk=user.pk).filter(email=value).exists():
            raise serializers.ValidationError('This email is already in use.')
        return value
