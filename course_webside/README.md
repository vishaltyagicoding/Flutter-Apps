# LearnHub - Online Learning Platform

A fully functional Udemy-like e-learning platform built with Django REST Framework backend and React frontend.

## Features

### For Students
- Browse and search courses by category, level, rating, and price
- View detailed course information with curriculum
- Add courses to cart and wishlist
- Secure checkout process
- Track learning progress
- Watch video lectures with progress tracking
- Leave reviews and ratings

### For Instructors
- Create and manage courses
- Add sections and video lectures
- Track student enrollments and revenue
- View course analytics and ratings

### For Admins
- Full Django admin panel
- Manage users, courses, categories
- View orders and enrollments
- Content moderation

## Tech Stack

### Backend
- Python 3.10+
- Django 4.2
- Django REST Framework
- MySQL Database
- JWT Authentication (SimpleJWT)
- Django CORS Headers

### Frontend
- React 18
- React Router v6
- Axios for API calls
- React Player for video playback
- React Toastify for notifications
- React Icons

## Project Structure

```
course_webside/
├── backend/
│   ├── course_platform/      # Django project settings
│   ├── accounts/             # User authentication app
│   ├── courses/              # Courses, enrollments, reviews app
│   ├── media/                # Uploaded files
│   └── requirements.txt
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/       # Reusable components
│   │   ├── context/          # React context providers
│   │   ├── pages/            # Page components
│   │   └── services/         # API services
│   └── package.json
└── README.md
```

## Setup Instructions

### Prerequisites
- Python 3.10 or higher
- Node.js 16 or higher
- MySQL Server
- Git

### Database Setup

1. Create MySQL database:
```sql
CREATE DATABASE course_platform_db;
```

2. Update database credentials in `backend/course_platform/settings.py`:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'course_platform_db',
        'USER': 'your_username',
        'PASSWORD': 'your_password',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Run migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```

5. Create demo data:
```bash
python manage.py setup_demo_data
```

6. Start the development server:
```bash
python manage.py runserver
```

The backend will be available at `http://localhost:8000`

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The frontend will be available at `http://localhost:3000`

## Demo Accounts

After running `setup_demo_data`, you can use these accounts:

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@courseplatform.com | admin123 |
| Instructor | john.doe@example.com | instructor123 |
| Student | student@example.com | student123 |

## API Endpoints

### Authentication
- `POST /api/token/` - Obtain JWT token
- `POST /api/token/refresh/` - Refresh JWT token
- `POST /api/accounts/register/` - Register new user
- `GET /api/accounts/profile/` - Get user profile
- `PATCH /api/accounts/profile/` - Update profile
- `PUT /api/accounts/change-password/` - Change password

### Courses
- `GET /api/courses/courses/` - List all courses
- `GET /api/courses/courses/{slug}/` - Get course details
- `GET /api/courses/categories/` - List categories
- `GET /api/courses/featured/` - Featured courses
- `GET /api/courses/popular/` - Popular courses

### Enrollments
- `GET /api/courses/enrollments/` - User's enrollments
- `POST /api/courses/enrollments/enroll/` - Enroll in course

### Cart & Checkout
- `GET /api/courses/cart/` - Get cart
- `POST /api/courses/cart/` - Add to cart
- `DELETE /api/courses/cart/{id}/` - Remove from cart
- `POST /api/courses/checkout/` - Process checkout

### Reviews
- `GET /api/courses/courses/{slug}/reviews/` - Course reviews
- `POST /api/courses/courses/{slug}/reviews/` - Add review

## Admin Panel

Access the Django admin panel at `http://localhost:8000/admin/`

Features:
- User management with custom fields
- Course management with inline sections/lectures
- Category management
- Order and enrollment tracking
- Review moderation

## Screenshots

### Home Page
- Hero section with call-to-action
- Featured courses carousel
- Category browsing
- Testimonials section

### Course Catalog
- Filter by category, level, rating
- Search functionality
- Sort by various criteria
- Pagination

### Course Detail
- Course information and curriculum
- Instructor profile
- Student reviews
- Add to cart/Enroll button

### Video Player
- Full-screen video playback
- Progress tracking
- Curriculum sidebar
- Mark as complete

### User Dashboard
- Enrolled courses
- Learning progress
- Profile settings

### Instructor Dashboard
- Course management
- Revenue tracking
- Student analytics

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, email support@learnhub.com or create an issue in the repository.
