from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, InstructorProfile


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    """Custom User Admin."""
    
    list_display = ['email', 'username', 'first_name', 'last_name', 'role', 'is_active', 'created_at']
    list_filter = ['role', 'is_active', 'is_staff', 'created_at']
    search_fields = ['email', 'username', 'first_name', 'last_name']
    ordering = ['-created_at']
    
    fieldsets = BaseUserAdmin.fieldsets + (
        ('Additional Info', {
            'fields': ('role', 'bio', 'profile_picture', 'phone', 'website', 'linkedin', 'twitter')
        }),
    )
    
    add_fieldsets = BaseUserAdmin.add_fieldsets + (
        ('Additional Info', {
            'fields': ('email', 'role')
        }),
    )


@admin.register(InstructorProfile)
class InstructorProfileAdmin(admin.ModelAdmin):
    """Instructor Profile Admin."""
    
    list_display = ['user', 'headline', 'total_students', 'total_reviews', 'average_rating']
    search_fields = ['user__email', 'user__username', 'headline']
    list_filter = ['average_rating']
