import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import ReactPlayer from 'react-player';
import { FiCheck, FiPlay, FiChevronDown, FiChevronUp, FiArrowLeft } from 'react-icons/fi';
import { coursesAPI, enrollmentAPI } from '../services/api';
import { toast } from 'react-toastify';
import './CoursePlayer.css';

const CoursePlayer = () => {
  const { slug } = useParams();
  const [course, setCourse] = useState(null);
  const [enrollment, setEnrollment] = useState(null);
  const [currentLecture, setCurrentLecture] = useState(null);
  const [expandedSections, setExpandedSections] = useState({});
  const [completedLectures, setCompletedLectures] = useState(new Set());
  const [loading, setLoading] = useState(true);
  const [sidebarOpen, setSidebarOpen] = useState(true);

  useEffect(() => {
    fetchCourseData();
  }, [slug]);

  const fetchCourseData = async () => {
    try {
      setLoading(true);
      const [courseRes, enrollmentRes] = await Promise.all([
        coursesAPI.getBySlug(slug),
        enrollmentAPI.getMyEnrollments()
      ]);
      
      const courseData = courseRes.data;
      setCourse(courseData);
      
      // Find enrollment for this course
      const enrollments = enrollmentRes.data.results || enrollmentRes.data;
      const currentEnrollment = enrollments.find(e => e.course.slug === slug);
      setEnrollment(currentEnrollment);
      
      // Set first lecture as current
      if (courseData.sections?.length > 0 && courseData.sections[0].lectures?.length > 0) {
        setCurrentLecture(courseData.sections[0].lectures[0]);
        setExpandedSections({ [courseData.sections[0].id]: true });
      }
    } catch (error) {
      console.error('Error fetching course:', error);
      toast.error('Failed to load course');
    } finally {
      setLoading(false);
    }
  };

  const toggleSection = (sectionId) => {
    setExpandedSections(prev => ({
      ...prev,
      [sectionId]: !prev[sectionId]
    }));
  };

  const handleLectureClick = (lecture) => {
    setCurrentLecture(lecture);
  };

  const handleLectureComplete = async () => {
    if (!enrollment || !currentLecture) return;

    try {
      await enrollmentAPI.updateProgress(enrollment.id, currentLecture.id, {
        completed: true
      });
      
      setCompletedLectures(prev => new Set([...prev, currentLecture.id]));
      toast.success('Lecture marked as complete!');
      
      // Auto-advance to next lecture
      const allLectures = course.sections.flatMap(s => s.lectures);
      const currentIndex = allLectures.findIndex(l => l.id === currentLecture.id);
      if (currentIndex < allLectures.length - 1) {
        setCurrentLecture(allLectures[currentIndex + 1]);
      }
    } catch (error) {
      console.error('Error updating progress:', error);
    }
  };

  const formatDuration = (seconds) => {
    if (!seconds) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const calculateProgress = () => {
    if (!course) return 0;
    const totalLectures = course.sections.reduce((acc, s) => acc + s.lectures.length, 0);
    if (totalLectures === 0) return 0;
    return Math.round((completedLectures.size / totalLectures) * 100);
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

  return (
    <div className="course-player-page">
      {/* Top Bar */}
      <div className="player-topbar">
        <Link to="/my-learning" className="back-btn">
          <FiArrowLeft /> Back to My Learning
        </Link>
        <h1 className="course-title">{course.title}</h1>
        <div className="progress-info">
          <div className="progress-bar">
            <div 
              className="progress-bar-fill" 
              style={{ width: `${calculateProgress()}%` }}
            ></div>
          </div>
          <span>{calculateProgress()}% complete</span>
        </div>
      </div>

      <div className="player-layout">
        {/* Video Player */}
        <div className={`player-main ${!sidebarOpen ? 'full-width' : ''}`}>
          <div className="video-container">
            {currentLecture?.video_url || currentLecture?.video_file ? (
              <ReactPlayer
                url={currentLecture.video_url || currentLecture.video_file}
                width="100%"
                height="100%"
                controls
                playing
                onEnded={handleLectureComplete}
                config={{
                  file: {
                    attributes: {
                      controlsList: 'nodownload'
                    }
                  }
                }}
              />
            ) : (
              <div className="no-video">
                <p>No video available for this lecture</p>
              </div>
            )}
          </div>

          <div className="lecture-info">
            <h2>{currentLecture?.title}</h2>
            {currentLecture?.article_content && (
              <div className="article-content">
                {currentLecture.article_content}
              </div>
            )}
            <div className="lecture-actions">
              <button 
                className="btn btn-primary"
                onClick={handleLectureComplete}
                disabled={completedLectures.has(currentLecture?.id)}
              >
                {completedLectures.has(currentLecture?.id) ? (
                  <><FiCheck /> Completed</>
                ) : (
                  'Mark as Complete'
                )}
              </button>
            </div>
          </div>
        </div>

        {/* Sidebar */}
        <aside className={`player-sidebar ${sidebarOpen ? 'open' : ''}`}>
          <button 
            className="sidebar-toggle"
            onClick={() => setSidebarOpen(!sidebarOpen)}
          >
            {sidebarOpen ? '→' : '←'}
          </button>
          
          <div className="sidebar-header">
            <h3>Course Content</h3>
          </div>

          <div className="curriculum-list">
            {course.sections?.map((section, sectionIndex) => (
              <div key={section.id} className="curriculum-section">
                <button 
                  className="section-header"
                  onClick={() => toggleSection(section.id)}
                >
                  <div className="section-info">
                    <span className="section-number">Section {sectionIndex + 1}</span>
                    <span className="section-title">{section.title}</span>
                  </div>
                  <div className="section-meta">
                    <span>{section.lectures?.length || 0} lectures</span>
                    {expandedSections[section.id] ? <FiChevronUp /> : <FiChevronDown />}
                  </div>
                </button>

                {expandedSections[section.id] && (
                  <div className="lecture-list">
                    {section.lectures?.map((lecture, lectureIndex) => (
                      <button
                        key={lecture.id}
                        className={`lecture-item ${currentLecture?.id === lecture.id ? 'active' : ''} ${completedLectures.has(lecture.id) ? 'completed' : ''}`}
                        onClick={() => handleLectureClick(lecture)}
                      >
                        <div className="lecture-checkbox">
                          {completedLectures.has(lecture.id) ? (
                            <FiCheck className="check-icon" />
                          ) : (
                            <span className="lecture-number">{lectureIndex + 1}</span>
                          )}
                        </div>
                        <div className="lecture-info">
                          <span className="lecture-title">{lecture.title}</span>
                          <span className="lecture-meta">
                            <FiPlay /> {formatDuration(lecture.duration)}
                          </span>
                        </div>
                      </button>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        </aside>
      </div>
    </div>
  );
};

export default CoursePlayer;
