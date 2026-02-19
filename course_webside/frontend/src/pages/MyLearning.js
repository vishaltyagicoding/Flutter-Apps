import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { FiPlay, FiClock, FiAward } from 'react-icons/fi';
import { enrollmentAPI } from '../services/api';
import './MyLearning.css';

const MyLearning = () => {
  const [enrollments, setEnrollments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');

  useEffect(() => {
    fetchEnrollments();
  }, []);

  const fetchEnrollments = async () => {
    try {
      setLoading(true);
      const response = await enrollmentAPI.getMyEnrollments();
      setEnrollments(response.data.results || response.data);
    } catch (error) {
      console.error('Error fetching enrollments:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredEnrollments = enrollments.filter(enrollment => {
    if (filter === 'all') return true;
    if (filter === 'in-progress') return enrollment.progress > 0 && enrollment.progress < 100;
    if (filter === 'completed') return enrollment.completed;
    if (filter === 'not-started') return enrollment.progress === 0;
    return true;
  });

  const formatDuration = (seconds) => {
    if (!seconds) return '0m';
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    }
    return `${minutes}m`;
  };

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner"></div>
      </div>
    );
  }

  return (
    <div className="my-learning-page">
      <div className="page-header">
        <div className="container">
          <h1>My Learning</h1>
        </div>
      </div>

      <div className="container">
        <div className="learning-tabs">
          <button 
            className={`tab ${filter === 'all' ? 'active' : ''}`}
            onClick={() => setFilter('all')}
          >
            All Courses
          </button>
          <button 
            className={`tab ${filter === 'in-progress' ? 'active' : ''}`}
            onClick={() => setFilter('in-progress')}
          >
            In Progress
          </button>
          <button 
            className={`tab ${filter === 'completed' ? 'active' : ''}`}
            onClick={() => setFilter('completed')}
          >
            Completed
          </button>
          <button 
            className={`tab ${filter === 'not-started' ? 'active' : ''}`}
            onClick={() => setFilter('not-started')}
          >
            Not Started
          </button>
        </div>

        {filteredEnrollments.length === 0 ? (
          <div className="empty-state">
            <div className="empty-state-icon">📚</div>
            <h3>No courses found</h3>
            <p>
              {filter === 'all' 
                ? "You haven't enrolled in any courses yet."
                : `No ${filter.replace('-', ' ')} courses.`}
            </p>
            <Link to="/courses" className="btn btn-primary">
              Browse Courses
            </Link>
          </div>
        ) : (
          <div className="courses-grid">
            {filteredEnrollments.map((enrollment) => (
              <div key={enrollment.id} className="learning-card">
                <Link to={`/course/${enrollment.course.slug}/learn`} className="card-image">
                  <img 
                    src={enrollment.course.thumbnail || 'https://via.placeholder.com/300x170?text=Course'} 
                    alt={enrollment.course.title}
                  />
                  <div className="play-overlay">
                    <FiPlay />
                  </div>
                </Link>
                
                <div className="card-content">
                  <Link to={`/course/${enrollment.course.slug}/learn`} className="card-title">
                    {enrollment.course.title}
                  </Link>
                  <p className="card-instructor">
                    {enrollment.course.instructor?.full_name}
                  </p>
                  
                  <div className="progress-section">
                    <div className="progress-bar">
                      <div 
                        className="progress-bar-fill" 
                        style={{ width: `${enrollment.progress}%` }}
                      ></div>
                    </div>
                    <span className="progress-text">{enrollment.progress}% complete</span>
                  </div>

                  <div className="card-meta">
                    <span className="meta-item">
                      <FiClock />
                      {formatDuration(enrollment.course.total_duration)}
                    </span>
                    {enrollment.completed && (
                      <span className="meta-item completed">
                        <FiAward />
                        Completed
                      </span>
                    )}
                  </div>

                  <Link 
                    to={`/course/${enrollment.course.slug}/learn`} 
                    className="btn btn-primary btn-block"
                  >
                    {enrollment.progress === 0 ? 'Start Course' : 'Continue Learning'}
                  </Link>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default MyLearning;
