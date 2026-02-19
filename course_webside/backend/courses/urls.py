from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    CategoryViewSet, CourseViewSet, SectionViewSet, LectureViewSet,
    EnrollmentViewSet, ReviewViewSet, CartView, WishlistView,
    CheckoutView, OrderListView, FeaturedCoursesView, BestsellerCoursesView,
    PopularCoursesView, InstructorCoursesView, LectureProgressView
)

router = DefaultRouter()
router.register(r'categories', CategoryViewSet, basename='category')
router.register(r'courses', CourseViewSet, basename='course')
router.register(r'enrollments', EnrollmentViewSet, basename='enrollment')

urlpatterns = [
    path('', include(router.urls)),
    
    # Course sections and lectures
    path('courses/<slug:course_slug>/sections/', 
         SectionViewSet.as_view({'get': 'list', 'post': 'create'}), 
         name='course-sections'),
    path('courses/<slug:course_slug>/sections/<int:pk>/', 
         SectionViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), 
         name='section-detail'),
    path('sections/<int:section_id>/lectures/', 
         LectureViewSet.as_view({'get': 'list', 'post': 'create'}), 
         name='section-lectures'),
    path('sections/<int:section_id>/lectures/<int:pk>/', 
         LectureViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), 
         name='lecture-detail'),
    
    # Reviews
    path('courses/<slug:course_slug>/reviews/', 
         ReviewViewSet.as_view({'get': 'list', 'post': 'create'}), 
         name='course-reviews'),
    
    # Progress tracking
    path('enrollments/<int:enrollment_id>/progress/<int:lecture_id>/', 
         LectureProgressView.as_view(), 
         name='lecture-progress'),
    
    # Cart
    path('cart/', CartView.as_view(), name='cart'),
    path('cart/<int:course_id>/', CartView.as_view(), name='cart-item'),
    
    # Wishlist
    path('wishlist/', WishlistView.as_view(), name='wishlist'),
    path('wishlist/<int:course_id>/', WishlistView.as_view(), name='wishlist-item'),
    
    # Checkout and Orders
    path('checkout/', CheckoutView.as_view(), name='checkout'),
    path('orders/', OrderListView.as_view(), name='orders'),
    
    # Featured courses
    path('featured/', FeaturedCoursesView.as_view(), name='featured-courses'),
    path('bestsellers/', BestsellerCoursesView.as_view(), name='bestseller-courses'),
    path('popular/', PopularCoursesView.as_view(), name='popular-courses'),
    
    # Instructor courses
    path('my-courses/', InstructorCoursesView.as_view(), name='instructor-courses'),
]
