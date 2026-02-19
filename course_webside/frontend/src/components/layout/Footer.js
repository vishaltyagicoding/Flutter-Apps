import React from 'react';
import { Link } from 'react-router-dom';
import { FiFacebook, FiTwitter, FiInstagram, FiLinkedin, FiYoutube } from 'react-icons/fi';
import './Footer.css';

const Footer = () => {
  return (
    <footer className="footer">
      <div className="footer-container">
        <div className="footer-top">
          <div className="footer-section">
            <h4>LearnHub</h4>
            <p>
              Learn from industry experts and advance your career with our comprehensive 
              online courses. Join millions of learners worldwide.
            </p>
            <div className="social-links">
              <a href="https://facebook.com" target="_blank" rel="noopener noreferrer">
                <FiFacebook />
              </a>
              <a href="https://twitter.com" target="_blank" rel="noopener noreferrer">
                <FiTwitter />
              </a>
              <a href="https://instagram.com" target="_blank" rel="noopener noreferrer">
                <FiInstagram />
              </a>
              <a href="https://linkedin.com" target="_blank" rel="noopener noreferrer">
                <FiLinkedin />
              </a>
              <a href="https://youtube.com" target="_blank" rel="noopener noreferrer">
                <FiYoutube />
              </a>
            </div>
          </div>

          <div className="footer-section">
            <h4>Popular Categories</h4>
            <ul>
              <li><Link to="/courses?category=development">Development</Link></li>
              <li><Link to="/courses?category=business">Business</Link></li>
              <li><Link to="/courses?category=it-software">IT & Software</Link></li>
              <li><Link to="/courses?category=design">Design</Link></li>
              <li><Link to="/courses?category=marketing">Marketing</Link></li>
              <li><Link to="/courses?category=data-science">Data Science</Link></li>
            </ul>
          </div>

          <div className="footer-section">
            <h4>Quick Links</h4>
            <ul>
              <li><Link to="/about">About Us</Link></li>
              <li><Link to="/contact">Contact</Link></li>
              <li><Link to="/careers">Careers</Link></li>
              <li><Link to="/blog">Blog</Link></li>
              <li><Link to="/help">Help & Support</Link></li>
              <li><Link to="/affiliate">Affiliate</Link></li>
            </ul>
          </div>

          <div className="footer-section">
            <h4>For Instructors</h4>
            <ul>
              <li><Link to="/teach">Become an Instructor</Link></li>
              <li><Link to="/instructor-rules">Instructor Rules</Link></li>
              <li><Link to="/instructor-help">Instructor Help</Link></li>
            </ul>
            <h4 style={{ marginTop: '24px' }}>Legal</h4>
            <ul>
              <li><Link to="/terms">Terms of Service</Link></li>
              <li><Link to="/privacy">Privacy Policy</Link></li>
              <li><Link to="/cookie-policy">Cookie Policy</Link></li>
            </ul>
          </div>
        </div>

        <div className="footer-bottom">
          <div className="footer-logo">
            <span className="logo-icon">📚</span>
            <span className="logo-text">LearnHub</span>
          </div>
          <p className="copyright">
            © {new Date().getFullYear()} LearnHub, Inc. All rights reserved.
          </p>
          <div className="footer-language">
            <select defaultValue="en">
              <option value="en">English</option>
              <option value="es">Español</option>
              <option value="fr">Français</option>
              <option value="de">Deutsch</option>
              <option value="hi">हिन्दी</option>
            </select>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
