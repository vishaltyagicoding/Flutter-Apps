import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { FiSearch, FiShoppingCart, FiHeart, FiMenu, FiX, FiUser, FiLogOut, FiBook, FiSettings } from 'react-icons/fi';
import { useAuth } from '../../context/AuthContext';
import { useCart } from '../../context/CartContext';
import './Header.css';

const Header = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const { user, isAuthenticated, logout } = useAuth();
  const { cartCount } = useCart();
  const navigate = useNavigate();

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate(`/courses?search=${encodeURIComponent(searchQuery)}`);
      setSearchQuery('');
    }
  };

  const handleLogout = async () => {
    await logout();
    navigate('/');
    setUserMenuOpen(false);
  };

  const getInitials = (name) => {
    if (!name) return 'U';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  };

  return (
    <header className="header">
      <div className="header-container">
        <div className="header-left">
          <button 
            className="mobile-menu-btn"
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          >
            {mobileMenuOpen ? <FiX /> : <FiMenu />}
          </button>
          
          <Link to="/" className="logo">
            <span className="logo-icon">📚</span>
            <span className="logo-text">LearnHub</span>
          </Link>

          <nav className={`nav-menu ${mobileMenuOpen ? 'active' : ''}`}>
            <Link to="/courses" className="nav-link" onClick={() => setMobileMenuOpen(false)}>
              Explore
            </Link>
            <div className="nav-dropdown">
              <span className="nav-link">Categories</span>
              <div className="dropdown-content">
                <Link to="/courses?category=development">Development</Link>
                <Link to="/courses?category=business">Business</Link>
                <Link to="/courses?category=it-software">IT & Software</Link>
                <Link to="/courses?category=design">Design</Link>
                <Link to="/courses?category=marketing">Marketing</Link>
                <Link to="/courses?category=data-science">Data Science</Link>
              </div>
            </div>
          </nav>
        </div>

        <form className="search-form" onSubmit={handleSearch}>
          <FiSearch className="search-icon" />
          <input
            type="text"
            placeholder="Search for anything"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="search-input"
          />
        </form>

        <div className="header-right">
          {isAuthenticated && user?.role === 'instructor' && (
            <Link to="/instructor/dashboard" className="header-link instructor-link">
              Instructor
            </Link>
          )}

          {isAuthenticated && (
            <Link to="/my-learning" className="header-link">
              My Learning
            </Link>
          )}

          <Link to="/wishlist" className="header-icon-btn" title="Wishlist">
            <FiHeart />
          </Link>

          <Link to="/cart" className="header-icon-btn cart-btn" title="Cart">
            <FiShoppingCart />
            {cartCount > 0 && <span className="cart-badge">{cartCount}</span>}
          </Link>

          {isAuthenticated ? (
            <div className="user-menu">
              <button 
                className="user-menu-btn"
                onClick={() => setUserMenuOpen(!userMenuOpen)}
              >
                {user?.profile_picture ? (
                  <img src={user.profile_picture} alt={user.full_name} className="user-avatar" />
                ) : (
                  <div className="user-avatar-placeholder">
                    {getInitials(user?.full_name)}
                  </div>
                )}
              </button>
              
              {userMenuOpen && (
                <div className="user-dropdown">
                  <div className="user-dropdown-header">
                    <div className="user-avatar-lg">
                      {user?.profile_picture ? (
                        <img src={user.profile_picture} alt={user.full_name} />
                      ) : (
                        <div className="avatar-placeholder-lg">
                          {getInitials(user?.full_name)}
                        </div>
                      )}
                    </div>
                    <div className="user-info">
                      <span className="user-name">{user?.full_name}</span>
                      <span className="user-email">{user?.email}</span>
                    </div>
                  </div>
                  <div className="user-dropdown-divider"></div>
                  <Link to="/my-learning" className="user-dropdown-item" onClick={() => setUserMenuOpen(false)}>
                    <FiBook /> My Learning
                  </Link>
                  <Link to="/cart" className="user-dropdown-item" onClick={() => setUserMenuOpen(false)}>
                    <FiShoppingCart /> My Cart
                  </Link>
                  <Link to="/wishlist" className="user-dropdown-item" onClick={() => setUserMenuOpen(false)}>
                    <FiHeart /> Wishlist
                  </Link>
                  {user?.role === 'instructor' && (
                    <Link to="/instructor/dashboard" className="user-dropdown-item" onClick={() => setUserMenuOpen(false)}>
                      <FiUser /> Instructor Dashboard
                    </Link>
                  )}
                  <div className="user-dropdown-divider"></div>
                  <Link to="/profile" className="user-dropdown-item" onClick={() => setUserMenuOpen(false)}>
                    <FiSettings /> Profile Settings
                  </Link>
                  <button className="user-dropdown-item logout-btn" onClick={handleLogout}>
                    <FiLogOut /> Log Out
                  </button>
                </div>
              )}
            </div>
          ) : (
            <div className="auth-buttons">
              <Link to="/login" className="btn btn-outline btn-sm">Log In</Link>
              <Link to="/register" className="btn btn-primary btn-sm">Sign Up</Link>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};

export default Header;
