from django.urls import path
from .views import (
    RegisterView,
    UserProfileView,
    ChangePasswordView,
    LogoutView,
    InstructorListView,
    InstructorDetailView,
    UserListView
)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('profile/', UserProfileView.as_view(), name='profile'),
    path('change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('instructors/', InstructorListView.as_view(), name='instructor-list'),
    path('instructors/<int:user_id>/', InstructorDetailView.as_view(), name='instructor-detail'),
    path('users/', UserListView.as_view(), name='user-list'),
]
