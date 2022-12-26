# events/serializers.py
# Serializers for Event Model

from rest_framework import serializers
from .models import Event
from accounts.serializers import AdminUserSerializer


class EventSerializer(serializers.ModelSerializer):
    """
    Serializer for Event model - includes all fields
    """
    created_by_details = AdminUserSerializer(source='created_by', read_only=True)
    organization_display = serializers.CharField(source='get_organization_display', read_only=True)
    
    class Meta:
        model = Event
        fields = [
            'id',
            'title',
            'description',
            'organization',
            'organization_display',
            'date',
            'time',
            'venue',
            'poster_image',
            'created_by',
            'created_by_details',
            'created_at',
            'updated_at',
        ]
        read_only_fields = ['id', 'created_by', 'created_at', 'updated_at']


class EventCreateSerializer(serializers.ModelSerializer):
    """
    Serializer for creating new events
    """
    class Meta:
        model = Event
        fields = [
            'title',
            'description',
            'organization',
            'date',
            'time',
            'venue',
            'poster_image',
        ]
    
    def validate_organization(self, value):
        """
        Validate that organization matches user's organization
        """
        request = self.context.get('request')
        if request and hasattr(request, 'user'):
            user = request.user
            # Only validate if user is not ADMIN
            if user.organization != 'ADMIN' and value != user.organization:
                raise serializers.ValidationError(
                    "You can only create events for your own organization"
                )
        return value


class EventUpdateSerializer(serializers.ModelSerializer):
    """
    Serializer for updating events
    """
    class Meta:
        model = Event
        fields = [
            'title',
            'description',
            'date',
            'time',
            'venue',
            'poster_image',
        ]
    
    # Note: Organization cannot be changed after creation


class EventListSerializer(serializers.ModelSerializer):
    """
    Simplified serializer for listing events
    """
    created_by_name = serializers.CharField(source='created_by.get_full_name', read_only=True)
    organization_display = serializers.CharField(source='get_organization_display', read_only=True)
    
    class Meta:
        model = Event
        fields = [
            'id',
            'title',
            'description',
            'organization',
            'organization_display',
            'date',
            'time',
            'venue',
            'poster_image',
            'created_by_name',
            'created_at',
        ]
