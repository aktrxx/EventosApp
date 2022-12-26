from django.contrib import admin
from .models import Event


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    """
    Admin interface for Event model
    """
    list_display = ['title', 'organization', 'date', 'time', 'venue', 'created_by', 'created_at']
    list_filter = ['organization', 'date', 'created_at']
    search_fields = ['title', 'description', 'venue']
    readonly_fields = ['created_at', 'updated_at']
    
    fieldsets = (
        ('Event Information', {
            'fields': ('title', 'description', 'organization')
        }),
        ('Schedule', {
            'fields': ('date', 'time', 'venue')
        }),
        ('Media', {
            'fields': ('poster_image',)
        }),
        ('Created By', {
            'fields': ('created_by', 'created_at', 'updated_at')
        }),
    )
