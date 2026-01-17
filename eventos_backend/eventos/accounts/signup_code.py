# ============================================
# ADD THIS TO: accounts/serializers.py
# ============================================

class SignupSerializer(serializers.ModelSerializer):
    """
    Serializer for user registration/signup
    """
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
        # Remove password_confirm as it's not a model field
        validated_data.pop('password_confirm')
        
        # Create user with hashed password
        user = AdminUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            organization=validated_data['organization'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        
        return user


# ============================================
# ADD THIS TO: accounts/views.py
# ============================================

@api_view(['POST'])
@permission_classes([AllowAny])
def signup_view(request):
    """
    User Registration/Signup Endpoint
    
    POST /api/auth/signup/
    Body: {
        "username": "newuser",
        "email": "newuser@example.com",
        "password": "password123",
        "password_confirm": "password123",
        "organization": "CSI",
        "first_name": "John",
        "last_name": "Doe"
    }
    
    Returns: {
        "success": true,
        "message": "Account created successfully",
        "data": {
            "user": {...},
            "tokens": {...}
        }
    }
    """
    serializer = SignupSerializer(data=request.data)
    
    if serializer.is_valid():
        # Create the user
        user = serializer.save()
        
        # Generate JWT tokens for auto-login
        refresh = RefreshToken.for_user(user)
        
        # Get user information
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


# ============================================
# ADD THIS TO: accounts/urls.py
# ============================================

urlpatterns = [
    # Authentication
    path('login/', views.login_view, name='login'),
    path('signup/', views.signup_view, name='signup'),  # ADD THIS LINE
    path('logout/', views.logout_view, name='logout'),
    
    # User Profile
    path('profile/', views.user_profile, name='profile'),
    path('profile/update/', views.update_profile, name='update_profile'),
    
    # Health Check
    path('health/', views.health_check, name='health_check'),
]
