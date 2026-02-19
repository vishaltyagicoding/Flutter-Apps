from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from accounts.models import InstructorProfile
from courses.models import Category, Course, Section, Lecture
from datetime import timedelta
from decimal import Decimal

User = get_user_model()


class Command(BaseCommand):
    help = 'Set up demo data for the course platform'

    def handle(self, *args, **options):
        self.stdout.write('Creating demo data...')
        
        # Create admin user
        admin_user, created = User.objects.get_or_create(
            email='admin@courseplatform.com',
            defaults={
                'username': 'admin',
                'first_name': 'Admin',
                'last_name': 'User',
                'role': 'admin',
                'is_staff': True,
                'is_superuser': True,
            }
        )
        if created:
            admin_user.set_password('admin123')
            admin_user.save()
            self.stdout.write(self.style.SUCCESS('Created admin user'))
        
        # Create instructors
        instructors = []
        instructor_data = [
            {
                'email': 'john.doe@example.com',
                'username': 'johndoe',
                'first_name': 'John',
                'last_name': 'Doe',
                'bio': 'Senior Software Engineer with 10+ years of experience in web development.',
                'headline': 'Full Stack Developer & Tech Educator',
                'expertise': 'Python, JavaScript, React, Django, Node.js'
            },
            {
                'email': 'jane.smith@example.com',
                'username': 'janesmith',
                'first_name': 'Jane',
                'last_name': 'Smith',
                'bio': 'Data Scientist and Machine Learning Expert with PhD in Computer Science.',
                'headline': 'Data Science & AI Instructor',
                'expertise': 'Python, Machine Learning, Deep Learning, TensorFlow, PyTorch'
            },
            {
                'email': 'mike.wilson@example.com',
                'username': 'mikewilson',
                'first_name': 'Mike',
                'last_name': 'Wilson',
                'bio': 'Mobile App Developer specializing in cross-platform development.',
                'headline': 'Mobile Development Expert',
                'expertise': 'Flutter, React Native, iOS, Android, Dart'
            },
        ]
        
        for data in instructor_data:
            user, created = User.objects.get_or_create(
                email=data['email'],
                defaults={
                    'username': data['username'],
                    'first_name': data['first_name'],
                    'last_name': data['last_name'],
                    'bio': data['bio'],
                    'role': 'instructor',
                }
            )
            if created:
                user.set_password('instructor123')
                user.save()
                InstructorProfile.objects.create(
                    user=user,
                    headline=data['headline'],
                    expertise=data['expertise']
                )
            instructors.append(user)
        
        self.stdout.write(self.style.SUCCESS('Created instructors'))
        
        # Create categories
        categories_data = [
            {'name': 'Development', 'slug': 'development', 'icon': 'code'},
            {'name': 'Business', 'slug': 'business', 'icon': 'briefcase'},
            {'name': 'IT & Software', 'slug': 'it-software', 'icon': 'laptop'},
            {'name': 'Design', 'slug': 'design', 'icon': 'palette'},
            {'name': 'Marketing', 'slug': 'marketing', 'icon': 'megaphone'},
            {'name': 'Data Science', 'slug': 'data-science', 'icon': 'chart-bar'},
        ]
        
        categories = {}
        for cat_data in categories_data:
            category, created = Category.objects.get_or_create(
                slug=cat_data['slug'],
                defaults=cat_data
            )
            categories[cat_data['slug']] = category
        
        # Create subcategories
        subcategories_data = [
            {'name': 'Web Development', 'slug': 'web-development', 'parent': 'development'},
            {'name': 'Mobile Development', 'slug': 'mobile-development', 'parent': 'development'},
            {'name': 'Python', 'slug': 'python', 'parent': 'development'},
            {'name': 'JavaScript', 'slug': 'javascript', 'parent': 'development'},
            {'name': 'Machine Learning', 'slug': 'machine-learning', 'parent': 'data-science'},
            {'name': 'Deep Learning', 'slug': 'deep-learning', 'parent': 'data-science'},
        ]
        
        for sub_data in subcategories_data:
            parent = categories.get(sub_data.pop('parent'))
            Category.objects.get_or_create(
                slug=sub_data['slug'],
                defaults={**sub_data, 'parent': parent}
            )
        
        self.stdout.write(self.style.SUCCESS('Created categories'))
        
        # Create courses
        courses_data = [
            {
                'title': 'Complete Python Bootcamp: From Zero to Hero',
                'slug': 'complete-python-bootcamp',
                'subtitle': 'Learn Python like a Professional! Start from basics and go all the way to creating your own applications.',
                'description': '''This comprehensive Python course takes you from absolute beginner to professional developer. 
                
You will learn:
- Python fundamentals and syntax
- Object-Oriented Programming
- File handling and databases
- Web scraping and automation
- Building real-world projects

Perfect for beginners with no prior programming experience!''',
                'instructor': instructors[0],
                'category': categories['development'],
                'price': Decimal('99.99'),
                'discount_price': Decimal('49.99'),
                'level': 'beginner',
                'status': 'published',
                'is_featured': True,
                'is_bestseller': True,
                'total_students': 15420,
                'average_rating': Decimal('4.75'),
                'total_reviews': 3250,
                'requirements': 'No programming experience needed. Just a computer and internet connection.',
                'what_you_learn': 'Python programming from scratch, OOP concepts, File handling, Web scraping, Building real projects',
            },
            {
                'title': 'React - The Complete Guide 2024',
                'slug': 'react-complete-guide-2024',
                'subtitle': 'Dive in and learn React.js from scratch! Learn React, Hooks, Redux, React Router, Next.js and more!',
                'description': '''Master React.js and build powerful, fast, user-friendly and reactive web apps.

This course covers:
- React basics & advanced concepts
- React Hooks in-depth
- Redux & Redux Toolkit
- React Router v6
- Next.js fundamentals
- Testing React applications

Build multiple real-world projects!''',
                'instructor': instructors[0],
                'category': categories['development'],
                'price': Decimal('129.99'),
                'discount_price': Decimal('59.99'),
                'level': 'intermediate',
                'status': 'published',
                'is_featured': True,
                'total_students': 12350,
                'average_rating': Decimal('4.80'),
                'total_reviews': 2890,
                'requirements': 'Basic JavaScript knowledge required. HTML/CSS basics helpful.',
                'what_you_learn': 'React fundamentals, Hooks, Redux, React Router, Next.js, Testing',
            },
            {
                'title': 'Machine Learning A-Z: AI, Python & R',
                'slug': 'machine-learning-a-z',
                'subtitle': 'Learn to create Machine Learning Algorithms in Python and R from two Data Science experts.',
                'description': '''Comprehensive Machine Learning course covering all major algorithms.

Topics include:
- Data Preprocessing
- Regression models
- Classification algorithms
- Clustering techniques
- Association Rule Learning
- Reinforcement Learning
- Natural Language Processing
- Deep Learning basics

Hands-on projects with real datasets!''',
                'instructor': instructors[1],
                'category': categories['data-science'],
                'price': Decimal('149.99'),
                'discount_price': Decimal('79.99'),
                'level': 'intermediate',
                'status': 'published',
                'is_featured': True,
                'is_bestseller': True,
                'total_students': 18500,
                'average_rating': Decimal('4.65'),
                'total_reviews': 4120,
                'requirements': 'Basic Python knowledge. High school math.',
                'what_you_learn': 'Machine Learning algorithms, Data preprocessing, Model evaluation, Real-world projects',
            },
            {
                'title': 'Flutter & Dart - The Complete Guide',
                'slug': 'flutter-dart-complete-guide',
                'subtitle': 'Build iOS and Android apps with a single codebase using Flutter and Dart!',
                'description': '''Learn Flutter and Dart from scratch and build beautiful native mobile apps.

Course content:
- Dart programming language
- Flutter widgets and layouts
- State management
- Navigation and routing
- HTTP requests and APIs
- Local storage
- Firebase integration
- Publishing apps

Build multiple complete apps!''',
                'instructor': instructors[2],
                'category': categories['development'],
                'price': Decimal('119.99'),
                'discount_price': Decimal('54.99'),
                'level': 'beginner',
                'status': 'published',
                'is_featured': True,
                'total_students': 8920,
                'average_rating': Decimal('4.70'),
                'total_reviews': 1850,
                'requirements': 'Basic programming knowledge helpful but not required.',
                'what_you_learn': 'Dart language, Flutter framework, State management, Firebase, Publishing apps',
            },
            {
                'title': 'Deep Learning Specialization',
                'slug': 'deep-learning-specialization',
                'subtitle': 'Master Deep Learning and build neural networks using TensorFlow and PyTorch.',
                'description': '''Advanced Deep Learning course for aspiring AI engineers.

Learn:
- Neural Network fundamentals
- Convolutional Neural Networks
- Recurrent Neural Networks
- Transformers and Attention
- GANs and Autoencoders
- TensorFlow and PyTorch
- Computer Vision projects
- NLP applications

Industry-level projects included!''',
                'instructor': instructors[1],
                'category': categories['data-science'],
                'price': Decimal('199.99'),
                'discount_price': Decimal('99.99'),
                'level': 'advanced',
                'status': 'published',
                'is_bestseller': True,
                'total_students': 6780,
                'average_rating': Decimal('4.85'),
                'total_reviews': 1420,
                'requirements': 'Machine Learning basics. Python proficiency. Linear algebra knowledge.',
                'what_you_learn': 'Deep Learning, CNNs, RNNs, Transformers, TensorFlow, PyTorch',
            },
            {
                'title': 'Django Web Development Masterclass',
                'slug': 'django-web-development-masterclass',
                'subtitle': 'Build professional web applications with Python and Django framework.',
                'description': '''Complete Django course for building production-ready web applications.

Topics covered:
- Django fundamentals
- Models and databases
- Views and templates
- Forms and validation
- User authentication
- REST APIs with DRF
- Testing and debugging
- Deployment strategies

Build a complete e-commerce site!''',
                'instructor': instructors[0],
                'category': categories['development'],
                'price': Decimal('109.99'),
                'discount_price': Decimal('49.99'),
                'level': 'intermediate',
                'status': 'published',
                'total_students': 5430,
                'average_rating': Decimal('4.60'),
                'total_reviews': 980,
                'requirements': 'Python basics required. HTML/CSS knowledge helpful.',
                'what_you_learn': 'Django framework, Database design, REST APIs, Authentication, Deployment',
            },
        ]
        
        for course_data in courses_data:
            course, created = Course.objects.get_or_create(
                slug=course_data['slug'],
                defaults=course_data
            )
            
            if created:
                # Create sections and lectures for each course
                sections_data = [
                    {
                        'title': 'Introduction',
                        'lectures': [
                            {'title': 'Welcome to the Course', 'duration': timedelta(minutes=5), 'is_preview': True},
                            {'title': 'Course Overview', 'duration': timedelta(minutes=10), 'is_preview': True},
                            {'title': 'Setting Up Your Environment', 'duration': timedelta(minutes=15)},
                        ]
                    },
                    {
                        'title': 'Getting Started',
                        'lectures': [
                            {'title': 'Basic Concepts', 'duration': timedelta(minutes=20)},
                            {'title': 'Your First Project', 'duration': timedelta(minutes=25)},
                            {'title': 'Understanding the Fundamentals', 'duration': timedelta(minutes=30)},
                        ]
                    },
                    {
                        'title': 'Intermediate Concepts',
                        'lectures': [
                            {'title': 'Advanced Features', 'duration': timedelta(minutes=35)},
                            {'title': 'Best Practices', 'duration': timedelta(minutes=25)},
                            {'title': 'Real-World Examples', 'duration': timedelta(minutes=40)},
                        ]
                    },
                    {
                        'title': 'Advanced Topics',
                        'lectures': [
                            {'title': 'Expert Techniques', 'duration': timedelta(minutes=45)},
                            {'title': 'Performance Optimization', 'duration': timedelta(minutes=30)},
                            {'title': 'Final Project', 'duration': timedelta(minutes=60)},
                        ]
                    },
                ]
                
                total_duration = timedelta()
                total_lectures = 0
                
                for i, section_data in enumerate(sections_data):
                    section = Section.objects.create(
                        course=course,
                        title=section_data['title'],
                        order=i + 1
                    )
                    
                    for j, lecture_data in enumerate(section_data['lectures']):
                        Lecture.objects.create(
                            section=section,
                            title=lecture_data['title'],
                            duration=lecture_data['duration'],
                            is_preview=lecture_data.get('is_preview', False),
                            order=j + 1,
                            content_type='video',
                            video_url='https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
                        )
                        total_duration += lecture_data['duration']
                        total_lectures += 1
                
                course.total_duration = total_duration
                course.total_lectures = total_lectures
                course.save()
        
        self.stdout.write(self.style.SUCCESS('Created courses with sections and lectures'))
        
        # Create a demo student
        student, created = User.objects.get_or_create(
            email='student@example.com',
            defaults={
                'username': 'demostudent',
                'first_name': 'Demo',
                'last_name': 'Student',
                'role': 'student',
            }
        )
        if created:
            student.set_password('student123')
            student.save()
            self.stdout.write(self.style.SUCCESS('Created demo student'))
        
        self.stdout.write(self.style.SUCCESS('Demo data setup complete!'))
        self.stdout.write('')
        self.stdout.write('Login credentials:')
        self.stdout.write('Admin: admin@courseplatform.com / admin123')
        self.stdout.write('Instructor: john.doe@example.com / instructor123')
        self.stdout.write('Student: student@example.com / student123')
