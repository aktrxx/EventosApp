# accounts/models.py
# Custom User Model for Admin Users

from django.db import models
from django.contrib.auth.models import AbstractUser

class AdminUser(AbstractUser):
    """
    Custom admin user model with organization support
    """
    
    ORGANIZATION_CHOICES = [
        ('ADMIN', 'Admin'),
        ('CSI', 'CSI Association'),
        ('IE', 'IE Association'),
        ('GLUGOT', 'GLUGOT TCE'),
        ('IT', 'IT'),
        ('MECH', 'MECH'),
        ('SPORTS', 'SPORTS'),
        ('COLLEGE', 'COLLEGE'),
    ]
    
    organization = models.CharField(
        max_length=20,
        choices=ORGANIZATION_CHOICES,
        default='ADMIN',
        help_text='Organization that this admin belongs to'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'admin_users'
        verbose_name = 'Admin User'
        verbose_name_plural = 'Admin Users'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.username} ({self.get_organization_display()})"
    
    def get_full_name(self):
        """Return full name or username if name not provided"""
        full_name = f"{self.first_name} {self.last_name}".strip()
        return full_name if full_name else self.username
