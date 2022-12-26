# events/urls.py
# URL Configuration for Event Management Endpoints

from django.urls import path
from . import views

app_name = 'events'

urlpatterns = [
    # List all events (filtered by organization)
    path('', views.event_list, name='event_list'),
    
    # Get specific event details
    path('<int:event_id>/', views.event_detail, name='event_detail'),
    
    # Create new event
    path('create/', views.event_create, name='event_create'),
    
    # Update event
    path('<int:event_id>/update/', views.event_update, name='event_update'),
    
    # Delete event
    path('<int:event_id>/delete/', views.event_delete, name='event_delete'),
    
    # Get my events (created by authenticated user)
    path('my-events/', views.my_events, name='my_events'),
]
