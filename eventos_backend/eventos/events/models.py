# events/models.py
# Event Model (Will implement fully later)

from django.db import models
from accounts.models import AdminUser


class Event(models.Model):
    """
    Event Model - For managing events
    (Full implementation coming soon)
    """
    title = models.CharField(max_length=200)
    description = models.TextField()
    organization = models.CharField(max_length=20)
    date = models.DateField()
    time = models.TimeField()
    venue = models.CharField(max_length=200, blank=True)
    poster_image = models.ImageField(upload_to='event_posters/', blank=True, null=True)
    
    created_by = models.ForeignKey(
        AdminUser,
        on_delete=models.CASCADE,
        related_name='created_events'
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'events'
        ordering = ['-created_at']
        verbose_name = 'Event'
        verbose_name_plural = 'Events'
    
    def __str__(self):
        return f"{self.title} ({self.organization})"
