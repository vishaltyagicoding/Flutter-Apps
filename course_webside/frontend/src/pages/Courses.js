import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { FiFilter, FiX } from 'react-icons/fi';
import CourseCard from '../components/common/CourseCard';
import { coursesAPI } from '../services/api';
import './Courses.css';

const Courses = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const [courses, setCourses] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [totalCount, setTotalCount] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [showFilters, setShowFilters] = useState(false);

  const [filters, setFilters] = useState({
    category: searchParams.get('category') || '',
    level: searchParams.get('level') || '',
    search: searchParams.get('search') || '',
    ordering: searchParams.get('ordering') || '-created_at',
    min_rating: searchParams.get('min_rating') || '',
  });

  useEffect(() => {
    fetchCategories();
  }, []);

  useEffect(() => {
    fetchCourses();
  }, [filters, currentPage]);

  const fetchCategories = async () => {
    try {
      const response = await coursesAPI.getCategories();
      const data = Array.isArray(response.data) ? response.data : response.data.results || [];
      setCategories(data);
    } catch (error) {
      console.error('Error fetching categories:', error);
    }
  };

  const fetchCourses = async () => {
    try {
      setLoading(true);
      const params = {
        page: currentPage,
        ...Object.fromEntries(
          Object.entries(filters).filter(([_, value]) => value !== '')
        ),
      };
      
      if (filters.category) {
        params.category__slug = filters.category;
        delete params.category;
      }

      const response = await coursesAPI.getAll(params);
      setCourses(response.data.results || response.data);
      setTotalCount(response.data.count || response.data.length);
    } catch (error) {
      console.error('Error fetching courses:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setCurrentPage(1);
    
    const newParams = new URLSearchParams(searchParams);
    if (value) {
      newParams.set(key, value);
    } else {
      newParams.delete(key);
    }
    setSearchParams(newParams);
  };

  const clearFilters = () => {
    setFilters({
      category: '',
      level: '',
      search: '',
      ordering: '-created_at',
      min_rating: '',
    });
    setSearchParams({});
    setCurrentPage(1);
  };

  const levels = [
    { value: '', label: 'All Levels' },
    { value: 'beginner', label: 'Beginner' },
    { value: 'intermediate', label: 'Intermediate' },
    { value: 'advanced', label: 'Advanced' },
  ];

  const sortOptions = [
    { value: '-created_at', label: 'Newest' },
    { value: 'created_at', label: 'Oldest' },
    { value: '-average_rating', label: 'Highest Rated' },
    { value: '-total_students', label: 'Most Popular' },
    { value: 'price', label: 'Price: Low to High' },
    { value: '-price', label: 'Price: High to Low' },
  ];

  const ratings = [
    { value: '', label: 'All Ratings' },
    { value: '4.5', label: '4.5 & up' },
    { value: '4.0', label: '4.0 & up' },
    { value: '3.5', label: '3.5 & up' },
    { value: '3.0', label: '3.0 & up' },
  ];

  const activeFiltersCount = Object.values(filters).filter(
    (v, i) => v !== '' && Object.keys(filters)[i] !== 'ordering'
  ).length;

  return (
    <div className="courses-page">
      <div className="page-header">
        <div className="container">
          <h1>All Courses</h1>
          <p>Explore our wide range of courses and start learning today</p>
        </div>
      </div>

      <div className="container">
        <div className="courses-layout">
          {/* Filters Sidebar */}
          <aside className={`filters-sidebar ${showFilters ? 'active' : ''}`}>
            <div className="filters-header">
              <h3>Filters</h3>
              <button className="close-filters" onClick={() => setShowFilters(false)}>
                <FiX />
              </button>
            </div>

            {activeFiltersCount > 0 && (
              <button className="clear-filters" onClick={clearFilters}>
                Clear all filters ({activeFiltersCount})
              </button>
            )}

            <div className="filter-group">
              <h4>Category</h4>
              <select
                value={filters.category}
                onChange={(e) => handleFilterChange('category', e.target.value)}
                className="filter-select"
              >
                <option value="">All Categories</option>
                {categories.map((cat) => (
                  <option key={cat.id} value={cat.slug}>
                    {cat.name}
                  </option>
                ))}
              </select>
            </div>

            <div className="filter-group">
              <h4>Level</h4>
              <div className="filter-options">
                {levels.map((level) => (
                  <label key={level.value} className="filter-option">
                    <input
                      type="radio"
                      name="level"
                      value={level.value}
                      checked={filters.level === level.value}
                      onChange={(e) => handleFilterChange('level', e.target.value)}
                    />
                    <span>{level.label}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="filter-group">
              <h4>Rating</h4>
              <div className="filter-options">
                {ratings.map((rating) => (
                  <label key={rating.value} className="filter-option">
                    <input
                      type="radio"
                      name="rating"
                      value={rating.value}
                      checked={filters.min_rating === rating.value}
                      onChange={(e) => handleFilterChange('min_rating', e.target.value)}
                    />
                    <span>{rating.label}</span>
                  </label>
                ))}
              </div>
            </div>
          </aside>

          {/* Courses Content */}
          <div className="courses-content">
            <div className="courses-toolbar">
              <div className="toolbar-left">
                <button 
                  className="filter-toggle"
                  onClick={() => setShowFilters(!showFilters)}
                >
                  <FiFilter />
                  Filters
                  {activeFiltersCount > 0 && (
                    <span className="filter-badge">{activeFiltersCount}</span>
                  )}
                </button>
                <span className="results-count">
                  {totalCount} {totalCount === 1 ? 'result' : 'results'}
                </span>
              </div>
              <div className="toolbar-right">
                <label className="sort-label">Sort by:</label>
                <select
                  value={filters.ordering}
                  onChange={(e) => handleFilterChange('ordering', e.target.value)}
                  className="sort-select"
                >
                  {sortOptions.map((option) => (
                    <option key={option.value} value={option.value}>
                      {option.label}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {loading ? (
              <div className="loading-container">
                <div className="spinner"></div>
              </div>
            ) : courses.length === 0 ? (
              <div className="empty-state">
                <div className="empty-state-icon">📚</div>
                <h3>No courses found</h3>
                <p>Try adjusting your filters or search terms</p>
                <button className="btn btn-primary" onClick={clearFilters}>
                  Clear Filters
                </button>
              </div>
            ) : (
              <>
                <div className="courses-grid grid grid-3">
                  {courses.map((course) => (
                    <CourseCard key={course.id} course={course} />
                  ))}
                </div>

                {totalCount > 12 && (
                  <div className="pagination">
                    <button
                      className="pagination-btn"
                      disabled={currentPage === 1}
                      onClick={() => setCurrentPage(prev => prev - 1)}
                    >
                      Previous
                    </button>
                    <span className="pagination-info">
                      Page {currentPage} of {Math.ceil(totalCount / 12)}
                    </span>
                    <button
                      className="pagination-btn"
                      disabled={currentPage >= Math.ceil(totalCount / 12)}
                      onClick={() => setCurrentPage(prev => prev + 1)}
                    >
                      Next
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Courses;
