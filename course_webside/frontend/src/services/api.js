import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('access_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle token refresh
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      
      try {
        const refreshToken = localStorage.getItem('refresh_token');
        if (refreshToken) {
          const response = await axios.post(`${API_URL}/token/refresh/`, {
            refresh: refreshToken,
          });
          
          const { access } = response.data;
          localStorage.setItem('access_token', access);
          
          originalRequest.headers.Authorization = `Bearer ${access}`;
          return api(originalRequest);
        }
      } catch (refreshError) {
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        window.location.href = '/login';
      }
    }
    
    return Promise.reject(error);
  }
);

// Auth API
export const authAPI = {
  login: (credentials) => api.post('/token/', credentials),
  register: (userData) => api.post('/accounts/register/', userData),
  getProfile: () => api.get('/accounts/profile/'),
  updateProfile: (data) => api.patch('/accounts/profile/', data),
  changePassword: (data) => api.put('/accounts/change-password/', data),
  logout: (refreshToken) => api.post('/accounts/logout/', { refresh: refreshToken }),
};

// Courses API
export const coursesAPI = {
  getAll: (params) => api.get('/courses/courses/', { params }),
  getBySlug: (slug) => api.get(`/courses/courses/${slug}/`),
  getFeatured: () => api.get('/courses/featured/'),
  getBestsellers: () => api.get('/courses/bestsellers/'),
  getPopular: () => api.get('/courses/popular/'),
  getCategories: () => api.get('/courses/categories/'),
  getCategoryBySlug: (slug) => api.get(`/courses/categories/${slug}/`),
  getSections: (courseSlug) => api.get(`/courses/courses/${courseSlug}/sections/`),
  getReviews: (courseSlug) => api.get(`/courses/courses/${courseSlug}/reviews/`),
  createReview: (courseSlug, data) => api.post(`/courses/courses/${courseSlug}/reviews/`, data),
};

// Enrollment API
export const enrollmentAPI = {
  getMyEnrollments: () => api.get('/courses/enrollments/'),
  enroll: (courseId) => api.post('/courses/enrollments/enroll/', { course_id: courseId }),
  updateProgress: (enrollmentId, lectureId, data) => 
    api.post(`/courses/enrollments/${enrollmentId}/progress/${lectureId}/`, data),
};

// Cart API
export const cartAPI = {
  get: () => api.get('/courses/cart/'),
  addItem: (courseId) => api.post('/courses/cart/', { course_id: courseId }),
  removeItem: (courseId) => api.delete(`/courses/cart/${courseId}/`),
  checkout: () => api.post('/courses/checkout/'),
};

// Wishlist API
export const wishlistAPI = {
  get: () => api.get('/courses/wishlist/'),
  add: (courseId) => api.post('/courses/wishlist/', { course_id: courseId }),
  remove: (courseId) => api.delete(`/courses/wishlist/${courseId}/`),
};

// Orders API
export const ordersAPI = {
  getAll: () => api.get('/courses/orders/'),
};

// Instructor API
export const instructorAPI = {
  getMyCourses: () => api.get('/courses/my-courses/'),
  createCourse: (data) => api.post('/courses/courses/', data),
  updateCourse: (slug, data) => api.patch(`/courses/courses/${slug}/`, data),
  deleteCourse: (slug) => api.delete(`/courses/courses/${slug}/`),
  getInstructors: () => api.get('/accounts/instructors/'),
  getInstructorById: (id) => api.get(`/accounts/instructors/${id}/`),
};

export default api;
