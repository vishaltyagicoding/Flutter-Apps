from rest_framework import generics, status, permissions, viewsets
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import action
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.shortcuts import get_object_or_404
from django.db.models import Avg
from .models import (
    Category, Course, Section, Lecture, Enrollment, 
    LectureProgress, Review, Cart, CartItem, Wishlist, Order, OrderItem
)
from .serializers import (
    CategorySerializer, CourseListSerializer, CourseDetailSerializer,
    CourseCreateSerializer, SectionSerializer, LectureSerializer,
    LectureDetailSerializer, EnrollmentSerializer, LectureProgressSerializer,
    ReviewSerializer, CartSerializer, CartItemSerializer, WishlistSerializer,
    OrderSerializer
)


class IsInstructorOrReadOnly(permissions.BasePermission):
    """Custom permission for instructors."""
    
    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user.is_authenticated and request.user.role == 'instructor'
    
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.instructor == request.user


class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for categories."""
    
    queryset = Category.objects.filter(parent=None)
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]
    lookup_field = 'slug'


class CourseViewSet(viewsets.ModelViewSet):
    """ViewSet for courses."""
    
    permission_classes = [IsInstructorOrReadOnly]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['category__slug', 'level', 'language', 'is_featured', 'is_bestseller']
    search_fields = ['title', 'subtitle', 'description']
    ordering_fields = ['created_at', 'price', 'average_rating', 'total_students']
    lookup_field = 'slug'
    
    def get_queryset(self):
        queryset = Course.objects.filter(status='published')
        
        # Filter by instructor
        instructor_id = self.request.query_params.get('instructor')
        if instructor_id:
            queryset = queryset.filter(instructor_id=instructor_id)
        
        # Filter by price range
        min_price = self.request.query_params.get('min_price')
        max_price = self.request.query_params.get('max_price')
        if min_price:
            queryset = queryset.filter(price__gte=min_price)
        if max_price:
            queryset = queryset.filter(price__lte=max_price)
        
        # Filter by rating
        min_rating = self.request.query_params.get('min_rating')
        if min_rating:
            queryset = queryset.filter(average_rating__gte=min_rating)
        
        return queryset
    
    def get_serializer_class(self):
        if self.action == 'list':
            return CourseListSerializer
        elif self.action in ['create', 'update', 'partial_update']:
            return CourseCreateSerializer
        return CourseDetailSerializer


class InstructorCoursesView(generics.ListAPIView):
    """List courses for the authenticated instructor."""
    
    serializer_class = CourseListSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Course.objects.filter(instructor=self.request.user)


class SectionViewSet(viewsets.ModelViewSet):
    """ViewSet for course sections."""
    
    serializer_class = SectionSerializer
    permission_classes = [IsInstructorOrReadOnly]
    
    def get_queryset(self):
        course_slug = self.kwargs.get('course_slug')
        return Section.objects.filter(course__slug=course_slug)
    
    def perform_create(self, serializer):
        course_slug = self.kwargs.get('course_slug')
        course = get_object_or_404(Course, slug=course_slug)
        serializer.save(course=course)


class LectureViewSet(viewsets.ModelViewSet):
    """ViewSet for lectures."""
    
    permission_classes = [IsInstructorOrReadOnly]
    
    def get_queryset(self):
        section_id = self.kwargs.get('section_id')
        return Lecture.objects.filter(section_id=section_id)
    
    def get_serializer_class(self):
        if self.action == 'retrieve':
            # Check if user is enrolled or is the instructor
            lecture = self.get_object()
            user = self.request.user
            if user.is_authenticated:
                is_enrolled = Enrollment.objects.filter(
                    student=user, course=lecture.section.course
                ).exists()
                is_instructor = lecture.section.course.instructor == user
                if is_enrolled or is_instructor or lecture.is_preview:
                    return LectureDetailSerializer
        return LectureSerializer
    
    def perform_create(self, serializer):
        section_id = self.kwargs.get('section_id')
        section = get_object_or_404(Section, id=section_id)
        serializer.save(section=section)


class EnrollmentViewSet(viewsets.ModelViewSet):
    """ViewSet for enrollments."""
    
    serializer_class = EnrollmentSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Enrollment.objects.filter(student=self.request.user)
    
    @action(detail=False, methods=['post'])
    def enroll(self, request):
        """Enroll in a course."""
        course_id = request.data.get('course_id')
        course = get_object_or_404(Course, id=course_id)
        
        # Check if already enrolled
        if Enrollment.objects.filter(student=request.user, course=course).exists():
            return Response({'error': 'Already enrolled in this course'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        enrollment = Enrollment.objects.create(student=request.user, course=course)
        
        # Update course stats
        course.total_students += 1
        course.save()
        
        return Response(EnrollmentSerializer(enrollment).data, status=status.HTTP_201_CREATED)


class LectureProgressView(APIView):
    """API view for tracking lecture progress."""
    
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request, enrollment_id, lecture_id):
        enrollment = get_object_or_404(Enrollment, id=enrollment_id, student=request.user)
        lecture = get_object_or_404(Lecture, id=lecture_id)
        
        progress, created = LectureProgress.objects.get_or_create(
            enrollment=enrollment,
            lecture=lecture
        )
        
        progress.completed = request.data.get('completed', progress.completed)
        progress.watched_duration = request.data.get('watched_duration', progress.watched_duration)
        progress.save()
        
        # Update enrollment progress
        total_lectures = Lecture.objects.filter(section__course=enrollment.course).count()
        completed_lectures = LectureProgress.objects.filter(
            enrollment=enrollment, completed=True
        ).count()
        
        if total_lectures > 0:
            enrollment.progress = int((completed_lectures / total_lectures) * 100)
            if enrollment.progress == 100:
                enrollment.completed = True
            enrollment.save()
        
        return Response(LectureProgressSerializer(progress).data)


class ReviewViewSet(viewsets.ModelViewSet):
    """ViewSet for reviews."""
    
    serializer_class = ReviewSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]
    
    def get_queryset(self):
        course_slug = self.kwargs.get('course_slug')
        if course_slug:
            return Review.objects.filter(course__slug=course_slug)
        return Review.objects.all()
    
    def perform_create(self, serializer):
        course_slug = self.kwargs.get('course_slug')
        course = get_object_or_404(Course, slug=course_slug)
        
        # Check if user is enrolled
        if not Enrollment.objects.filter(student=self.request.user, course=course).exists():
            raise permissions.PermissionDenied("You must be enrolled to review this course")
        
        review = serializer.save(course=course)
        
        # Update course rating
        avg_rating = Review.objects.filter(course=course).aggregate(Avg('rating'))['rating__avg']
        course.average_rating = avg_rating or 0
        course.total_reviews = Review.objects.filter(course=course).count()
        course.save()


class CartView(APIView):
    """API view for shopping cart."""
    
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        cart, created = Cart.objects.get_or_create(user=request.user)
        return Response(CartSerializer(cart).data)
    
    def post(self, request):
        """Add item to cart."""
        cart, created = Cart.objects.get_or_create(user=request.user)
        course_id = request.data.get('course_id')
        course = get_object_or_404(Course, id=course_id)
        
        # Check if already enrolled
        if Enrollment.objects.filter(student=request.user, course=course).exists():
            return Response({'error': 'Already enrolled in this course'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        # Check if already in cart
        if CartItem.objects.filter(cart=cart, course=course).exists():
            return Response({'error': 'Course already in cart'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        CartItem.objects.create(cart=cart, course=course)
        return Response(CartSerializer(cart).data, status=status.HTTP_201_CREATED)
    
    def delete(self, request, course_id=None):
        """Remove item from cart."""
        cart = get_object_or_404(Cart, user=request.user)
        if course_id:
            CartItem.objects.filter(cart=cart, course_id=course_id).delete()
        return Response(CartSerializer(cart).data)


class WishlistView(APIView):
    """API view for wishlist."""
    
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        wishlist = Wishlist.objects.filter(user=request.user)
        return Response(WishlistSerializer(wishlist, many=True).data)
    
    def post(self, request):
        """Add to wishlist."""
        course_id = request.data.get('course_id')
        course = get_object_or_404(Course, id=course_id)
        
        wishlist, created = Wishlist.objects.get_or_create(user=request.user, course=course)
        
        if not created:
            return Response({'error': 'Course already in wishlist'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        return Response(WishlistSerializer(wishlist).data, status=status.HTTP_201_CREATED)
    
    def delete(self, request, course_id=None):
        """Remove from wishlist."""
        if course_id:
            Wishlist.objects.filter(user=request.user, course_id=course_id).delete()
        return Response({'message': 'Removed from wishlist'})


class CheckoutView(APIView):
    """API view for checkout."""
    
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        """Process checkout."""
        cart = get_object_or_404(Cart, user=request.user)
        
        if not cart.items.exists():
            return Response({'error': 'Cart is empty'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Create order
        order = Order.objects.create(
            user=request.user,
            total_amount=cart.total_price,
            status='completed'  # In real app, this would be pending until payment
        )
        
        # Create order items and enrollments
        for item in cart.items.all():
            OrderItem.objects.create(
                order=order,
                course=item.course,
                price=item.course.current_price
            )
            
            # Create enrollment
            Enrollment.objects.get_or_create(
                student=request.user,
                course=item.course
            )
            
            # Update course stats
            item.course.total_students += 1
            item.course.save()
        
        # Clear cart
        cart.items.all().delete()
        
        return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)


class OrderListView(generics.ListAPIView):
    """List user's orders."""
    
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)


class FeaturedCoursesView(generics.ListAPIView):
    """List featured courses."""
    
    serializer_class = CourseListSerializer
    permission_classes = [permissions.AllowAny]
    queryset = Course.objects.filter(status='published', is_featured=True)[:8]


class BestsellerCoursesView(generics.ListAPIView):
    """List bestseller courses."""
    
    serializer_class = CourseListSerializer
    permission_classes = [permissions.AllowAny]
    queryset = Course.objects.filter(status='published', is_bestseller=True)[:8]


class PopularCoursesView(generics.ListAPIView):
    """List popular courses by student count."""
    
    serializer_class = CourseListSerializer
    permission_classes = [permissions.AllowAny]
    queryset = Course.objects.filter(status='published').order_by('-total_students')[:8]
