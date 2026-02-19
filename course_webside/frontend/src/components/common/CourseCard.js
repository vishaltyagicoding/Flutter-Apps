import React from 'react';
import { Link } from 'react-router-dom';
import { FiStar, FiClock, FiUsers } from 'react-icons/fi';
import './CourseCard.css';

const CourseCard = ({ course }) => {
  const formatDuration = (duration) => {
    if (!duration) return 'N/A';
    const hours = Math.floor(duration / 3600);
    const minutes = Math.floor((duration % 3600) / 60);
    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    }
    return `${minutes}m`;
  };

  const formatPrice = (price) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(price);
  };

  return (
    <Link to={`/courses/${course.slug}`} className="course-card">
      <div className="course-card-image">
        <img 
          src={course.thumbnail || '/placeholder-course.jpg'} 
          alt={course.title}
          onError={(e) => {
            e.target.src = 'https://via.placeholder.com/300x170?text=Course';
          }}
        />
        {course.is_bestseller && (
          <span className="badge badge-bestseller">Bestseller</span>
        )}
        {course.is_featured && !course.is_bestseller && (
          <span className="badge badge-featured">Featured</span>
        )}
      </div>
      
      <div className="course-card-content">
        <h3 className="course-card-title">{course.title}</h3>
        <p className="course-card-instructor">
          {course.instructor?.full_name || course.instructor?.username}
        </p>
        
        <div className="course-card-rating">
          <span className="rating-value">{(parseFloat(course.average_rating) || 0).toFixed(1)}</span>
          <div className="rating-stars">
            {[1, 2, 3, 4, 5].map((star) => (
              <FiStar
                key={star}
                className={`star ${star <= Math.round(parseFloat(course.average_rating) || 0) ? 'filled' : ''}`}
              />
            ))}
          </div>
          <span className="rating-count">({course.total_reviews?.toLocaleString() || 0})</span>
        </div>
        
        <div className="course-card-meta">
          <span className="meta-item">
            <FiClock />
            {formatDuration(course.total_duration)}
          </span>
          <span className="meta-item">
            <FiUsers />
            {course.total_students?.toLocaleString() || 0}
          </span>
          <span className="meta-item level">{course.level}</span>
        </div>
        
        <div className="course-card-price">
          <span className="price-current">
            {course.current_price === 0 ? 'Free' : formatPrice(course.current_price)}
          </span>
          {course.discount_price && course.discount_price < course.price && (
            <span className="price-original">{formatPrice(course.price)}</span>
          )}
        </div>
      </div>
    </Link>
  );
};

export default CourseCard;
