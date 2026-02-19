import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { FiArrowRight, FiPlay, FiUsers, FiAward, FiBookOpen } from 'react-icons/fi';
import CourseCard from '../components/common/CourseCard';
import { coursesAPI } from '../services/api';
import './Home.css';

const Home = () => {
  const [featuredCourses, setFeaturedCourses] = useState([]);
  const [popularCourses, setPopularCourses] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [featuredRes, popularRes, categoriesRes] = await Promise.all([
        coursesAPI.getFeatured(),
        coursesAPI.getPopular(),
        coursesAPI.getCategories(),
      ]);
      setFeaturedCourses(Array.isArray(featuredRes.data) ? featuredRes.data : featuredRes.data.results || []);
      setPopularCourses(Array.isArray(popularRes.data) ? popularRes.data : popularRes.data.results || []);
      setCategories(Array.isArray(categoriesRes.data) ? categoriesRes.data : categoriesRes.data.results || []);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const stats = [
    { icon: <FiBookOpen />, value: '10,000+', label: 'Online Courses' },
    { icon: <FiUsers />, value: '500K+', label: 'Active Students' },
    { icon: <FiAward />, value: '1,000+', label: 'Expert Instructors' },
    { icon: <FiPlay />, value: '50K+', label: 'Video Lessons' },
  ];

  const categoryIcons = {
    development: '💻',
    business: '💼',
    'it-software': '🖥️',
    design: '🎨',
    marketing: '📢',
    'data-science': '📊',
  };

  return (
    <div className="home-page">
      {/* Hero Section */}
      <section className="hero">
        <div className="container">
          <div className="hero-content">
            <h1>Learn Without Limits</h1>
            <p>
              Start, switch, or advance your career with thousands of courses from 
              world-class instructors. Learn at your own pace, anytime, anywhere.
            </p>
            <div className="hero-buttons">
              <Link to="/courses" className="btn btn-primary btn-lg">
                Explore Courses
              </Link>
              <Link to="/register" className="btn btn-outline btn-lg">
                Join for Free
              </Link>
            </div>
            <div className="hero-stats">
              {stats.map((stat, index) => (
                <div key={index} className="stat-item">
                  <span className="stat-icon">{stat.icon}</span>
                  <span className="stat-value">{stat.value}</span>
                  <span className="stat-label">{stat.label}</span>
                </div>
              ))}
            </div>
          </div>
          <div className="hero-image">
            <img 
              src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600" 
              alt="Students learning"
            />
          </div>
        </div>
      </section>

      {/* Categories Section */}
      <section className="section categories-section">
        <div className="container">
          <div className="section-header">
            <h2 className="section-title">Top Categories</h2>
            <Link to="/courses" className="section-link">
              All Categories <FiArrowRight />
            </Link>
          </div>
          <div className="categories-grid">
            {categories.slice(0, 6).map((category) => (
              <Link 
                key={category.id} 
                to={`/courses?category=${category.slug}`}
                className="category-card"
              >
                <span className="category-icon">
                  {categoryIcons[category.slug] || '📚'}
                </span>
                <h3>{category.name}</h3>
                <p>{category.course_count} Courses</p>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Featured Courses Section */}
      <section className="section featured-section">
        <div className="container">
          <div className="section-header">
            <h2 className="section-title">Featured Courses</h2>
            <Link to="/courses?featured=true" className="section-link">
              View All <FiArrowRight />
            </Link>
          </div>
          {loading ? (
            <div className="loading-container">
              <div className="spinner"></div>
            </div>
          ) : (
            <div className="courses-grid grid grid-4">
              {featuredCourses.map((course) => (
                <CourseCard key={course.id} course={course} />
              ))}
            </div>
          )}
        </div>
      </section>

      {/* Popular Courses Section */}
      <section className="section popular-section">
        <div className="container">
          <div className="section-header">
            <h2 className="section-title">Most Popular</h2>
            <Link to="/courses?ordering=-total_students" className="section-link">
              View All <FiArrowRight />
            </Link>
          </div>
          {loading ? (
            <div className="loading-container">
              <div className="spinner"></div>
            </div>
          ) : (
            <div className="courses-grid grid grid-4">
              {popularCourses.map((course) => (
                <CourseCard key={course.id} course={course} />
              ))}
            </div>
          )}
        </div>
      </section>

      {/* CTA Section */}
      <section className="cta-section">
        <div className="container">
          <div className="cta-content">
            <h2>Become an Instructor</h2>
            <p>
              Join thousands of instructors and earn money by sharing your knowledge. 
              Create courses on topics you're passionate about and reach millions of students.
            </p>
            <Link to="/teach" className="btn btn-primary btn-lg">
              Start Teaching Today
            </Link>
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section className="section testimonials-section">
        <div className="container">
          <h2 className="section-title text-center">What Our Students Say</h2>
          <div className="testimonials-grid">
            <div className="testimonial-card">
              <p className="testimonial-text">
                "LearnHub has completely transformed my career. The courses are well-structured 
                and the instructors are incredibly knowledgeable."
              </p>
              <div className="testimonial-author">
                <div className="author-avatar">JD</div>
                <div className="author-info">
                  <span className="author-name">John Doe</span>
                  <span className="author-role">Software Developer</span>
                </div>
              </div>
            </div>
            <div className="testimonial-card">
              <p className="testimonial-text">
                "I've taken multiple courses on data science and machine learning. 
                The quality of content is exceptional and very practical."
              </p>
              <div className="testimonial-author">
                <div className="author-avatar">JS</div>
                <div className="author-info">
                  <span className="author-name">Jane Smith</span>
                  <span className="author-role">Data Analyst</span>
                </div>
              </div>
            </div>
            <div className="testimonial-card">
              <p className="testimonial-text">
                "The flexibility to learn at my own pace while working full-time 
                has been invaluable. Highly recommend LearnHub!"
              </p>
              <div className="testimonial-author">
                <div className="author-avatar">MW</div>
                <div className="author-info">
                  <span className="author-name">Mike Wilson</span>
                  <span className="author-role">Product Manager</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Home;
