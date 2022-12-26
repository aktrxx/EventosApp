# events/views.py
# Views for Event Management API

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

from .models import Event
from .serializers import (
    EventSerializer,
    EventCreateSerializer,
    EventUpdateSerializer,
    EventListSerializer
)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def event_list(request):
    """
    List all events for the authenticated user's organization
    GET /api/events/
    
    Query Parameters:
    - organization: Filter by specific organization (admin only)
    
    Returns: List of events
    """
    user = request.user
    
    # If user is ADMIN, they can see all events or filter by organization
    if user.organization == 'ADMIN':
        organization_filter = request.query_params.get('organization')
        if organization_filter:
            events = Event.objects.filter(organization=organization_filter)
        else:
            events = Event.objects.all()
    else:
        # Regular users can only see their organization's events
        events = Event.objects.filter(organization=user.organization)
    
    serializer = EventListSerializer(events, many=True)
    
    return Response({
        'success': True,
        'count': events.count(),
        'data': serializer.data
    }, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def event_detail(request, event_id):
    """
    Get details of a specific event
    GET /api/events/<id>/
    
    Returns: Event details
    """
    user = request.user
    event = get_object_or_404(Event, id=event_id)
    
    # Check if user has permission to view this event
    if user.organization != 'ADMIN' and event.organization != user.organization:
        return Response({
            'success': False,
            'message': 'You do not have permission to view this event'
        }, status=status.HTTP_403_FORBIDDEN)
    
    serializer = EventSerializer(event)
    
    return Response({
        'success': True,
        'data': serializer.data
    }, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def event_create(request):
    """
    Create a new event
    POST /api/events/create/
    
    Body: {
        "title": "Event Title",
        "description": "Event Description",
        "organization": "CSI",
        "date": "2026-01-20",
        "time": "14:00:00",
        "venue": "Main Hall",
        "poster_image": <file> (optional)
    }
    
    Returns: Created event details
    """
    serializer = EventCreateSerializer(data=request.data, context={'request': request})
    
    if serializer.is_valid():
        # Automatically set created_by to current user
        event = serializer.save(created_by=request.user)
        
        # Return full event details
        event_serializer = EventSerializer(event)
        
        return Response({
            'success': True,
            'message': 'Event created successfully',
            'data': event_serializer.data
        }, status=status.HTTP_201_CREATED)
    
    return Response({
        'success': False,
        'message': 'Event creation failed',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated])
def event_update(request, event_id):
    """
    Update an existing event
    PUT/PATCH /api/events/<id>/update/
    
    Body: {
        "title": "Updated Title",
        "description": "Updated Description",
        "date": "2026-01-21",
        "time": "15:00:00",
        "venue": "Updated Venue"
    }
    
    Returns: Updated event details
    """
    user = request.user
    event = get_object_or_404(Event, id=event_id)
    
    # Check if user has permission to update this event
    if user.organization != 'ADMIN' and event.organization != user.organization:
        return Response({
            'success': False,
            'message': 'You do not have permission to update this event'
        }, status=status.HTTP_403_FORBIDDEN)
    
    # Check if user is the creator or an admin
    if user.organization != 'ADMIN' and event.created_by != user:
        return Response({
            'success': False,
            'message': 'Only the event creator or admin can update this event'
        }, status=status.HTTP_403_FORBIDDEN)
    
    partial = request.method == 'PATCH'
    serializer = EventUpdateSerializer(event, data=request.data, partial=partial)
    
    if serializer.is_valid():
        serializer.save()
        
        # Return full event details
        event_serializer = EventSerializer(event)
        
        return Response({
            'success': True,
            'message': 'Event updated successfully',
            'data': event_serializer.data
        }, status=status.HTTP_200_OK)
    
    return Response({
        'success': False,
        'message': 'Event update failed',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def event_delete(request, event_id):
    """
    Delete an event
    DELETE /api/events/<id>/delete/
    
    Returns: Success message
    """
    user = request.user
    event = get_object_or_404(Event, id=event_id)
    
    # Check if user has permission to delete this event
    if user.organization != 'ADMIN' and event.organization != user.organization:
        return Response({
            'success': False,
            'message': 'You do not have permission to delete this event'
        }, status=status.HTTP_403_FORBIDDEN)
    
    # Check if user is the creator or an admin
    if user.organization != 'ADMIN' and event.created_by != user:
        return Response({
            'success': False,
            'message': 'Only the event creator or admin can delete this event'
        }, status=status.HTTP_403_FORBIDDEN)
    
    event_title = event.title
    event.delete()
    
    return Response({
        'success': True,
        'message': f'Event "{event_title}" deleted successfully'
    }, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def my_events(request):
    """
    List events created by the authenticated user
    GET /api/events/my-events/
    
    Returns: List of events created by the user
    """
    user = request.user
    events = Event.objects.filter(created_by=user)
    
    serializer = EventListSerializer(events, many=True)
    
    return Response({
        'success': True,
        'count': events.count(),
        'data': serializer.data
    }, status=status.HTTP_200_OK)
