import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { FiPlus, FiEdit2, FiTrash2, FiUsers, FiDollarSign, FiStar, FiBook } from 'react-icons/fi';
import { instructorAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { toast } from 'react-toastify';
import './InstructorDashboard.css';

const InstructorDashboard = () => {
  const { user } = useAuth();
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalStudents: 0,
    totalRevenue: 0,
    averageRating: 0,
    totalCourses: 0,
  });

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      const response = await instructorAPI.getMyCourses();
      const coursesData = response.data.results || response.data;
      setCourses(coursesData);
      
      // Calculate stats
      const totalStudents = coursesData.reduce((acc, c) => acc + (c.total_students || 0), 0);
      const totalRevenue = coursesData.reduce((acc, c) => acc + (c.total_students * c.current_price || 0), 0);
      const avgRating = coursesData.length > 0 
        ? coursesData.reduce((acc, c) => acc + (c.average_rating || 0), 0) / coursesData.length 
        : 0;
      
      setStats({
        totalStudents,
        totalRevenue,
        averageRating: avgRating,
        totalCourses: coursesData.length,
      });
    } catch (error) {
      console.error('Error fetching courses:', error);
      toast.error('Failed to load courses');
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteCourse = async (slug) => {
    if (!window.confirm('Are you sure you want to delete this course?')) return;

    try {
      await instructorAPI.deleteCourse(slug);
      toast.success('Course deleted successfully');
      fetchCourses();
    } catch (error) {
      toast.error('Failed to delete course');
    }
  };

  const formatPrice = (price) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(price);
  };

  if (user?.role !== 'instructor') {
    return (
      <div className="instructor-dashboard">
        <div className="container">
          <div className="empty-state">
            <div className="empty-state-icon">👨‍🏫</div>
            <h3>Become an Instructor</h3>
            <p>Share your knowledge and earn money by creating courses.</p>
            <Link to="/teach" className="btn btn-primary">
              Start Teaching
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="instructor-dashboard">
      <div className="page-header">
        <div className="container">
          <div className="header-content">
            <div>
              <h1>Instructor Dashboard</h1>
              <p>Manage your courses and track your performance</p>
            </div>
            <Link to="/instructor/create-course" className="btn btn-primary">
              <FiPlus /> Create New Course
            </Link>
          </div>
        </div>
      </div>

      <div className="container">
        {/* Stats Cards */}
        <div className="stats-grid">
          <div className="stat-card">
            <div className="stat-icon students">
              <FiUsers />
            </div>
            <div className="stat-info">
              <span className="stat-value">{stats.totalStudents.toLocaleString()}</span>
              <span className="stat-label">Total Students</span>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon revenue">
              <FiDollarSign />
            </div>
            <div className="stat-info">
              <span className="stat-value">{formatPrice(stats.totalRevenue)}</span>
              <span className="stat-label">Total Revenue</span>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon rating">
              <FiStar />
            </div>
            <div className="stat-info">
              <span className="stat-value">{stats.averageRating.toFixed(1)}</span>
              <span className="stat-label">Average Rating</span>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon courses">
              <FiBook />
            </div>
            <div className="stat-info">
              <span className="stat-value">{stats.totalCourses}</span>
              <span className="stat-label">Total Courses</span>
            </div>
          </div>
        </div>

        {/* Courses Section */}
        <div className="dashboard-section">
          <div className="section-header">
            <h2>Your Courses</h2>
          </div>

          {loading ? (
            <div className="loading-container">
              <div className="spinner"></div>
            </div>
          ) : courses.length === 0 ? (
            <div className="empty-state">
              <div className="empty-state-icon">📚</div>
              <h3>No courses yet</h3>
              <p>Create your first course and start teaching!</p>
              <Link to="/instructor/create-course" className="btn btn-primary">
                <FiPlus /> Create Course
              </Link>
            </div>
          ) : (
            <div className="courses-table">
              <table>
                <thead>
                  <tr>
                    <th>Course</th>
                    <th>Status</th>
                    <th>Students</th>
                    <th>Rating</th>
                    <th>Revenue</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {courses.map((course) => (
                    <tr key={course.id}>
                      <td>
                        <div className="course-cell">
                          <img 
                            src={course.thumbnail || 'https://via.placeholder.com/80x45?text=Course'} 
                            alt={course.title}
                            className="course-thumb"
                          />
                          <div className="course-info">
                            <Link to={`/courses/${course.slug}`} className="course-title">
                              {course.title}
                            </Link>
                            <span className="course-price">{formatPrice(course.current_price)}</span>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span className={`status-badge ${course.status}`}>
                          {course.status}
                        </span>
                      </td>
                      <td>{course.total_students?.toLocaleString() || 0}</td>
                      <td>
                        <div className="rating-cell">
                          <FiStar className="star-icon" />
                          {course.average_rating?.toFixed(1) || '0.0'}
                        </div>
                      </td>
                      <td>{formatPrice((course.total_students || 0) * course.current_price)}</td>
                      <td>
                        <div className="action-buttons">
                          <Link 
                            to={`/instructor/edit-course/${course.slug}`}
                            className="action-btn edit"
                            title="Edit"
                          >
                            <FiEdit2 />
                          </Link>
                          <button 
                            className="action-btn delete"
                            onClick={() => handleDeleteCourse(course.slug)}
                            title="Delete"
                          >
                            <FiTrash2 />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Recent Activity */}
        <div className="dashboard-section">
          <div className="section-header">
            <h2>Recent Activity</h2>
          </div>
          <div className="activity-list">
            <div className="activity-item">
              <div className="activity-icon enrollment">👤</div>
              <div className="activity-info">
                <p>New student enrolled in <strong>Python Bootcamp</strong></p>
                <span className="activity-time">2 hours ago</span>
              </div>
            </div>
            <div className="activity-item">
              <div className="activity-icon review">⭐</div>
              <div className="activity-info">
                <p>New 5-star review on <strong>React Complete Guide</strong></p>
                <span className="activity-time">5 hours ago</span>
              </div>
            </div>
            <div className="activity-item">
              <div className="activity-icon enrollment">👤</div>
              <div className="activity-info">
                <p>3 new students enrolled in <strong>Django Masterclass</strong></p>
                <span className="activity-time">1 day ago</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default InstructorDashboard;
