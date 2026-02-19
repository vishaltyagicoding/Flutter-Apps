from rest_framework import serializers
from .models import (
    Category, Course, Section, Lecture, Enrollment, 
    LectureProgress, Review, Cart, CartItem, Wishlist, Order, OrderItem
)
from accounts.serializers import UserSerializer


class CategorySerializer(serializers.ModelSerializer):
    """Serializer for Category model."""
    
    subcategories = serializers.SerializerMethodField()
    course_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Category
        fields = ['id', 'name', 'slug', 'description', 'icon', 'image', 'parent', 'subcategories', 'course_count']
    
    def get_subcategories(self, obj):
        return CategorySerializer(obj.subcategories.all(), many=True).data
    
    def get_course_count(self, obj):
        return obj.courses.filter(status='published').count()


class LectureSerializer(serializers.ModelSerializer):
    """Serializer for Lecture model."""
    
    class Meta:
        model = Lecture
        fields = ['id', 'title', 'content_type', 'video_file', 'video_url', 
                  'article_content', 'duration', 'order', 'is_preview', 'resources']


class LectureDetailSerializer(serializers.ModelSerializer):
    """Detailed serializer for Lecture with video access."""
    
    class Meta:
        model = Lecture
        fields = '__all__'


class SectionSerializer(serializers.ModelSerializer):
    """Serializer for Section model."""
    
    lectures = LectureSerializer(many=True, read_only=True)
    total_duration = serializers.SerializerMethodField()
    lecture_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Section
        fields = ['id', 'title', 'order', 'lectures', 'total_duration', 'lecture_count']
    
    def get_total_duration(self, obj):
        total = sum((l.duration.total_seconds() for l in obj.lectures.all() if l.duration), 0)
        return total
    
    def get_lecture_count(self, obj):
        return obj.lectures.count()


class CourseListSerializer(serializers.ModelSerializer):
    """Serializer for Course list view."""
    
    instructor = UserSerializer(read_only=True)
    category = CategorySerializer(read_only=True)
    current_price = serializers.ReadOnlyField()
    
    class Meta:
        model = Course
        fields = ['id', 'title', 'slug', 'subtitle', 'instructor', 'category',
                  'thumbnail', 'price', 'discount_price', 'current_price', 'level',
                  'average_rating', 'total_reviews', 'total_students', 'is_featured',
                  'is_bestseller', 'total_duration', 'total_lectures']


class CourseDetailSerializer(serializers.ModelSerializer):
    """Detailed serializer for Course."""
    
    instructor = UserSerializer(read_only=True)
    category = CategorySerializer(read_only=True)
    sections = SectionSerializer(many=True, read_only=True)
    current_price = serializers.ReadOnlyField()
    is_enrolled = serializers.SerializerMethodField()
    
    class Meta:
        model = Course
        fields = '__all__'
    
    def get_is_enrolled(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return Enrollment.objects.filter(student=request.user, course=obj).exists()
        return False


class CourseCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating/updating courses."""
    
    class Meta:
        model = Course
        exclude = ['instructor', 'average_rating', 'total_reviews', 'total_students']
    
    def create(self, validated_data):
        validated_data['instructor'] = self.context['request'].user
        return super().create(validated_data)


class EnrollmentSerializer(serializers.ModelSerializer):
    """Serializer for Enrollment model."""
    
    course = CourseListSerializer(read_only=True)
    
    class Meta:
        model = Enrollment
        fields = ['id', 'course', 'enrolled_at', 'completed', 'completed_at', 'progress']


class LectureProgressSerializer(serializers.ModelSerializer):
    """Serializer for Lecture Progress."""
    
    class Meta:
        model = LectureProgress
        fields = ['id', 'lecture', 'completed', 'watched_duration', 'last_watched_at']


class ReviewSerializer(serializers.ModelSerializer):
    """Serializer for Review model."""
    
    student = UserSerializer(read_only=True)
    
    class Meta:
        model = Review
        fields = ['id', 'course', 'student', 'rating', 'comment', 'created_at', 'updated_at']
        read_only_fields = ['student']
    
    def create(self, validated_data):
        validated_data['student'] = self.context['request'].user
        return super().create(validated_data)


class CartItemSerializer(serializers.ModelSerializer):
    """Serializer for Cart Item."""
    
    course = CourseListSerializer(read_only=True)
    course_id = serializers.IntegerField(write_only=True)
    
    class Meta:
        model = CartItem
        fields = ['id', 'course', 'course_id', 'added_at']


class CartSerializer(serializers.ModelSerializer):
    """Serializer for Cart."""
    
    items = CartItemSerializer(many=True, read_only=True)
    total_price = serializers.ReadOnlyField()
    
    class Meta:
        model = Cart
        fields = ['id', 'items', 'total_price', 'created_at', 'updated_at']


class WishlistSerializer(serializers.ModelSerializer):
    """Serializer for Wishlist."""
    
    course = CourseListSerializer(read_only=True)
    course_id = serializers.IntegerField(write_only=True)
    
    class Meta:
        model = Wishlist
        fields = ['id', 'course', 'course_id', 'added_at']


class OrderItemSerializer(serializers.ModelSerializer):
    """Serializer for Order Item."""
    
    course = CourseListSerializer(read_only=True)
    
    class Meta:
        model = OrderItem
        fields = ['id', 'course', 'price']


class OrderSerializer(serializers.ModelSerializer):
    """Serializer for Order."""
    
    items = OrderItemSerializer(many=True, read_only=True)
    
    class Meta:
        model = Order
        fields = ['id', 'total_amount', 'status', 'payment_id', 'items', 'created_at']
