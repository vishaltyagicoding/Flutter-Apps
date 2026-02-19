import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { 
  FiStar, FiClock, FiUsers, FiPlay, FiCheck, FiShoppingCart, 
  FiHeart, FiShare2, FiGlobe, FiAward, FiChevronDown, FiChevronUp 
} from 'react-icons/fi';
import ReactPlayer from 'react-player';
import { coursesAPI, enrollmentAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';
import { toast } from 'react-toastify';
import './CourseDetail.css';

const CourseDetail = () => {
  const { slug } = useParams();
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth();
  const { addToCart, isInCart } = useCart();
  
  const [course, setCourse] = useState(null);
  const [loading, setLoading] = useState(true);
  const [expandedSections, setExpandedSections] = useState({});
  const [showPreview, setShowPreview] = useState(false);

  useEffect(() => {
    fetchCourse();
  }, [slug]);

  const fetchCourse = async () => {
    try {
      setLoading(true);
      const response = await coursesAPI.getBySlug(slug);
      setCourse(response.data);
      
      // Expand first section by default
      if (response.data.sections?.length > 0) {
        setExpandedSections({ [response.data.sections[0].id]: true });
      }
    } catch (error) {
      console.error('Error fetching course:', error);
      toast.error('Course not found');
      navigate('/courses');
    } finally {
      setLoading(false);
    }
  };

  const handleEnroll = async () => {
    if (!isAuthenticated) {
      navigate('/login', { state: { from: `/courses/${slug}` } });
      return;
    }

    if (course.current_price === 0) {
      try {
        await enrollmentAPI.enroll(course.id);
        toast.success('Successfully enrolled!');
        navigate(`/course/${slug}/learn`);
      } catch (error) {
        toast.error(error.response?.data?.error || 'Failed to enroll');
      }
    } else {
      const success = await addToCart(course.id);
      if (success) {
        navigate('/cart');
      }
    }
  };

  const handleAddToCart = async () => {
    if (!isAuthenticated) {
      navigate('/login', { state: { from: `/courses/${slug}` } });
      return;
    }
    await addToCart(course.id);
  };

  const toggleSection = (sectionId) => {
    setExpandedSections(prev => ({
      ...prev,
      [sectionId]: !prev[sectionId]
    }));
  };

  const formatDuration = (seconds) => {
    if (!seconds) return '0m';
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
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

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner"></div>
      </div>
    );
  }

  if (!course) {
    return null;
  }

  const totalLectures = course.sections?.reduce(
    (acc, section) => acc + (section.lectures?.length || 0), 0
  ) || 0;

  const totalDuration = course.sections?.reduce(
    (acc, section) => acc + (section.total_duration || 0), 0
  ) || 0;

  return (
    <div className="course-detail-page">
      {/* Preview Modal */}
      {showPreview && course.preview_video && (
        <div className="preview-modal" onClick={() => setShowPreview(false)}>
          <div className="preview-content" onClick={e => e.stopPropagation()}>
            <button className="preview-close" onClick={() => setShowPreview(false)}>×</button>
            <ReactPlayer
              url={course.preview_video}
              width="100%"
              height="100%"
              controls
              playing
            />
          </div>
        </div>
      )}

      {/* Course Header */}
      <div className="course-header">
        <div className="container">
          <div className="course-header-content">
            <div className="breadcrumb">
              <Link to="/">Home</Link>
              <span>/</span>
              <Link to="/courses">Courses</Link>
              <span>/</span>
              <Link to={`/courses?category=${course.category?.slug}`}>
                {course.category?.name}
              </Link>
            </div>
            
            <h1>{course.title}</h1>
            <p className="course-subtitle">{course.subtitle}</p>
            
            <div className="course-meta">
              {course.is_bestseller && (
                <span className="badge badge-bestseller">Bestseller</span>
              )}
              <div className="rating">
                <span className="rating-value">{(parseFloat(course.average_rating) || 0).toFixed(1)}</span>
                <div className="rating-stars">
                  {[1, 2, 3, 4, 5].map((star) => (
                    <FiStar
                      key={star}
                      className={`star ${star <= Math.round(parseFloat(course.average_rating) || 0) ? 'filled' : ''}`}
                    />
                  ))}
                </div>
                <span className="rating-count">({course.total_reviews?.toLocaleString()} ratings)</span>
              </div>
              <span className="students">
                <FiUsers /> {course.total_students?.toLocaleString()} students
              </span>
            </div>
            
            <p className="course-instructor">
              Created by{' '}
              <Link to={`/instructor/${course.instructor?.id}`}>
                {course.instructor?.full_name}
              </Link>
            </p>
            
            <div className="course-info">
              <span><FiClock /> Last updated {new Date(course.updated_at).toLocaleDateString()}</span>
              <span><FiGlobe /> {course.language}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Course Content */}
      <div className="course-content-wrapper">
        <div className="container">
          <div className="course-layout">
            {/* Main Content */}
            <div className="course-main">
              {/* What You'll Learn */}
              <section className="course-section">
                <h2>What you'll learn</h2>
                <div className="learn-grid">
                  {course.what_you_learn?.split(',').map((item, index) => (
                    <div key={index} className="learn-item">
                      <FiCheck className="check-icon" />
                      <span>{item.trim()}</span>
                    </div>
                  ))}
                </div>
              </section>

              {/* Course Content */}
              <section className="course-section">
                <h2>Course content</h2>
                <div className="content-summary">
                  <span>{course.sections?.length || 0} sections</span>
                  <span>•</span>
                  <span>{totalLectures} lectures</span>
                  <span>•</span>
                  <span>{formatDuration(totalDuration)} total length</span>
                </div>
                
                <div className="curriculum">
                  {course.sections?.map((section) => (
                    <div key={section.id} className="curriculum-section">
                      <button 
                        className="section-header"
                        onClick={() => toggleSection(section.id)}
                      >
                        <div className="section-title">
                          {expandedSections[section.id] ? <FiChevronUp /> : <FiChevronDown />}
                          <span>{section.title}</span>
                        </div>
                        <div className="section-meta">
                          <span>{section.lecture_count} lectures</span>
                          <span>•</span>
                          <span>{formatDuration(section.total_duration)}</span>
                        </div>
                      </button>
                      
                      {expandedSections[section.id] && (
                        <div className="section-content">
                          {section.lectures?.map((lecture) => (
                            <div key={lecture.id} className="lecture-item">
                              <div className="lecture-info">
                                <FiPlay className="lecture-icon" />
                                <span className="lecture-title">{lecture.title}</span>
                                {lecture.is_preview && (
                                  <span className="preview-badge">Preview</span>
                                )}
                              </div>
                              <span className="lecture-duration">
                                {formatDuration(lecture.duration)}
                              </span>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </section>

              {/* Requirements */}
              <section className="course-section">
                <h2>Requirements</h2>
                <ul className="requirements-list">
                  {course.requirements?.split('\n').map((req, index) => (
                    <li key={index}>{req.trim()}</li>
                  ))}
                </ul>
              </section>

              {/* Description */}
              <section className="course-section">
                <h2>Description</h2>
                <div className="description-content">
                  {course.description}
                </div>
              </section>

              {/* Instructor */}
              <section className="course-section">
                <h2>Instructor</h2>
                <div className="instructor-card">
                  <div className="instructor-avatar">
                    {course.instructor?.profile_picture ? (
                      <img src={course.instructor.profile_picture} alt={course.instructor.full_name} />
                    ) : (
                      <div className="avatar-placeholder">
                        {course.instructor?.full_name?.charAt(0)}
                      </div>
                    )}
                  </div>
                  <div className="instructor-info">
                    <h3>{course.instructor?.full_name}</h3>
                    <p className="instructor-title">{course.instructor?.instructor_profile?.headline}</p>
                    <div className="instructor-stats">
                      <span><FiStar /> {course.instructor?.instructor_profile?.average_rating || 0} Instructor Rating</span>
                      <span><FiAward /> {course.instructor?.instructor_profile?.total_reviews || 0} Reviews</span>
                      <span><FiUsers /> {course.instructor?.instructor_profile?.total_students || 0} Students</span>
                    </div>
                    <p className="instructor-bio">{course.instructor?.bio}</p>
                  </div>
                </div>
              </section>
            </div>

            {/* Sidebar */}
            <aside className="course-sidebar">
              <div className="sidebar-card">
                <div className="course-preview">
                  <img 
                    src={course.thumbnail || 'https://via.placeholder.com/400x225?text=Course'} 
                    alt={course.title}
                  />
                  {course.preview_video && (
                    <button className="preview-btn" onClick={() => setShowPreview(true)}>
                      <FiPlay />
                      <span>Preview this course</span>
                    </button>
                  )}
                </div>
                
                <div className="sidebar-content">
                  <div className="price-section">
                    <span className="current-price">
                      {course.current_price === 0 ? 'Free' : formatPrice(course.current_price)}
                    </span>
                    {course.discount_price && course.discount_price < course.price && (
                      <>
                        <span className="original-price">{formatPrice(course.price)}</span>
                        <span className="discount-badge">
                          {Math.round((1 - course.discount_price / course.price) * 100)}% off
                        </span>
                      </>
                    )}
                  </div>

                  {course.is_enrolled ? (
                    <Link to={`/course/${slug}/learn`} className="btn btn-primary btn-block btn-lg">
                      Go to Course
                    </Link>
                  ) : (
                    <>
                      <button 
                        className="btn btn-primary btn-block btn-lg"
                        onClick={handleEnroll}
                      >
                        {course.current_price === 0 ? 'Enroll Now' : 'Buy Now'}
                      </button>
                      
                      {course.current_price > 0 && !isInCart(course.id) && (
                        <button 
                          className="btn btn-outline btn-block"
                          onClick={handleAddToCart}
                        >
                          <FiShoppingCart /> Add to Cart
                        </button>
                      )}
                    </>
                  )}

                  <div className="sidebar-actions">
                    <button className="action-btn">
                      <FiHeart /> Wishlist
                    </button>
                    <button className="action-btn">
                      <FiShare2 /> Share
                    </button>
                  </div>

                  <div className="course-includes">
                    <h4>This course includes:</h4>
                    <ul>
                      <li><FiPlay /> {formatDuration(totalDuration)} on-demand video</li>
                      <li><FiAward /> Certificate of completion</li>
                      <li><FiClock /> Full lifetime access</li>
                      <li><FiGlobe /> Access on mobile and TV</li>
                    </ul>
                  </div>
                </div>
              </div>
            </aside>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CourseDetail;
