from django.contrib import admin
from .models import (
    Category, Course, Section, Lecture, Enrollment, 
    LectureProgress, Review, Cart, CartItem, Wishlist, Order, OrderItem
)


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'parent', 'created_at']
    list_filter = ['parent', 'created_at']
    search_fields = ['name', 'description']
    prepopulated_fields = {'slug': ('name',)}


class SectionInline(admin.TabularInline):
    model = Section
    extra = 1


class LectureInline(admin.TabularInline):
    model = Lecture
    extra = 1


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ['title', 'instructor', 'category', 'price', 'status', 
                    'is_featured', 'is_bestseller', 'total_students', 'average_rating']
    list_filter = ['status', 'level', 'is_featured', 'is_bestseller', 'category', 'created_at']
    search_fields = ['title', 'subtitle', 'description', 'instructor__email']
    prepopulated_fields = {'slug': ('title',)}
    raw_id_fields = ['instructor']
    inlines = [SectionInline]
    
    fieldsets = (
        ('Basic Information', {
            'fields': ('title', 'slug', 'subtitle', 'description', 'instructor', 'category')
        }),
        ('Media', {
            'fields': ('thumbnail', 'preview_video')
        }),
        ('Pricing', {
            'fields': ('price', 'discount_price')
        }),
        ('Course Details', {
            'fields': ('level', 'language', 'requirements', 'what_you_learn')
        }),
        ('Status', {
            'fields': ('status', 'is_featured', 'is_bestseller')
        }),
        ('Statistics', {
            'fields': ('total_duration', 'total_lectures', 'average_rating', 
                      'total_reviews', 'total_students'),
            'classes': ('collapse',)
        }),
    )


@admin.register(Section)
class SectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'course', 'order']
    list_filter = ['course']
    search_fields = ['title', 'course__title']
    inlines = [LectureInline]


@admin.register(Lecture)
class LectureAdmin(admin.ModelAdmin):
    list_display = ['title', 'section', 'content_type', 'duration', 'order', 'is_preview']
    list_filter = ['content_type', 'is_preview', 'section__course']
    search_fields = ['title', 'section__title', 'section__course__title']


@admin.register(Enrollment)
class EnrollmentAdmin(admin.ModelAdmin):
    list_display = ['student', 'course', 'enrolled_at', 'progress', 'completed']
    list_filter = ['completed', 'enrolled_at']
    search_fields = ['student__email', 'course__title']
    raw_id_fields = ['student', 'course']


@admin.register(LectureProgress)
class LectureProgressAdmin(admin.ModelAdmin):
    list_display = ['enrollment', 'lecture', 'completed', 'last_watched_at']
    list_filter = ['completed']
    raw_id_fields = ['enrollment', 'lecture']


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ['course', 'student', 'rating', 'created_at']
    list_filter = ['rating', 'created_at']
    search_fields = ['course__title', 'student__email', 'comment']
    raw_id_fields = ['course', 'student']


class CartItemInline(admin.TabularInline):
    model = CartItem
    extra = 0


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    list_display = ['user', 'created_at', 'updated_at']
    search_fields = ['user__email']
    inlines = [CartItemInline]


@admin.register(Wishlist)
class WishlistAdmin(admin.ModelAdmin):
    list_display = ['user', 'course', 'added_at']
    search_fields = ['user__email', 'course__title']
    raw_id_fields = ['user', 'course']


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'total_amount', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['user__email', 'payment_id']
    raw_id_fields = ['user']
    inlines = [OrderItemInline]


# Customize admin site
admin.site.site_header = 'Course Platform Administration'
admin.site.site_title = 'Course Platform Admin'
admin.site.index_title = 'Welcome to Course Platform Admin Panel'
