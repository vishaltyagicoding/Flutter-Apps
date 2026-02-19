import React, { useState } from 'react';
import { FiUser, FiMail, FiPhone, FiGlobe, FiLinkedin, FiTwitter, FiCamera } from 'react-icons/fi';
import { useAuth } from '../context/AuthContext';
import { authAPI } from '../services/api';
import { toast } from 'react-toastify';
import './Profile.css';

const Profile = () => {
  const { user, updateUser } = useAuth();
  const [activeTab, setActiveTab] = useState('profile');
  const [loading, setLoading] = useState(false);
  
  const [profileData, setProfileData] = useState({
    first_name: user?.first_name || '',
    last_name: user?.last_name || '',
    bio: user?.bio || '',
    phone: user?.phone || '',
    website: user?.website || '',
    linkedin: user?.linkedin || '',
    twitter: user?.twitter || '',
  });

  const [passwordData, setPasswordData] = useState({
    old_password: '',
    new_password: '',
    confirm_password: '',
  });

  const handleProfileChange = (e) => {
    setProfileData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }));
  };

  const handlePasswordChange = (e) => {
    setPasswordData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }));
  };

  const handleProfileSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await authAPI.updateProfile(profileData);
      updateUser(response.data);
      toast.success('Profile updated successfully!');
    } catch (error) {
      toast.error('Failed to update profile');
    } finally {
      setLoading(false);
    }
  };

  const handlePasswordSubmit = async (e) => {
    e.preventDefault();
    
    if (passwordData.new_password !== passwordData.confirm_password) {
      toast.error('Passwords do not match');
      return;
    }

    setLoading(true);

    try {
      await authAPI.changePassword({
        old_password: passwordData.old_password,
        new_password: passwordData.new_password,
      });
      toast.success('Password changed successfully!');
      setPasswordData({
        old_password: '',
        new_password: '',
        confirm_password: '',
      });
    } catch (error) {
      toast.error(error.response?.data?.old_password?.[0] || 'Failed to change password');
    } finally {
      setLoading(false);
    }
  };

  const getInitials = (name) => {
    if (!name) return 'U';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  };

  return (
    <div className="profile-page">
      <div className="page-header">
        <div className="container">
          <h1>Profile Settings</h1>
        </div>
      </div>

      <div className="container">
        <div className="profile-layout">
          {/* Sidebar */}
          <aside className="profile-sidebar">
            <div className="profile-avatar-section">
              <div className="avatar-wrapper">
                {user?.profile_picture ? (
                  <img src={user.profile_picture} alt={user.full_name} className="avatar-image" />
                ) : (
                  <div className="avatar-placeholder">
                    {getInitials(user?.full_name)}
                  </div>
                )}
                <button className="avatar-edit">
                  <FiCamera />
                </button>
              </div>
              <h3>{user?.full_name}</h3>
              <p>{user?.email}</p>
              <span className="role-badge">{user?.role}</span>
            </div>

            <nav className="profile-nav">
              <button 
                className={`nav-item ${activeTab === 'profile' ? 'active' : ''}`}
                onClick={() => setActiveTab('profile')}
              >
                <FiUser /> Profile
              </button>
              <button 
                className={`nav-item ${activeTab === 'security' ? 'active' : ''}`}
                onClick={() => setActiveTab('security')}
              >
                🔒 Security
              </button>
              <button 
                className={`nav-item ${activeTab === 'notifications' ? 'active' : ''}`}
                onClick={() => setActiveTab('notifications')}
              >
                🔔 Notifications
              </button>
            </nav>
          </aside>

          {/* Main Content */}
          <main className="profile-main">
            {activeTab === 'profile' && (
              <div className="profile-section">
                <h2>Profile Information</h2>
                <p className="section-description">
                  Update your personal information and public profile.
                </p>

                <form onSubmit={handleProfileSubmit}>
                  <div className="form-row">
                    <div className="form-group">
                      <label className="form-label">First Name</label>
                      <div className="input-with-icon">
                        <FiUser className="input-icon" />
                        <input
                          type="text"
                          name="first_name"
                          value={profileData.first_name}
                          onChange={handleProfileChange}
                          className="form-input"
                          placeholder="First name"
                        />
                      </div>
                    </div>
                    <div className="form-group">
                      <label className="form-label">Last Name</label>
                      <div className="input-with-icon">
                        <FiUser className="input-icon" />
                        <input
                          type="text"
                          name="last_name"
                          value={profileData.last_name}
                          onChange={handleProfileChange}
                          className="form-input"
                          placeholder="Last name"
                        />
                      </div>
                    </div>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Email</label>
                    <div className="input-with-icon">
                      <FiMail className="input-icon" />
                      <input
                        type="email"
                        value={user?.email}
                        className="form-input"
                        disabled
                      />
                    </div>
                    <small className="form-hint">Email cannot be changed</small>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Bio</label>
                    <textarea
                      name="bio"
                      value={profileData.bio}
                      onChange={handleProfileChange}
                      className="form-input"
                      rows={4}
                      placeholder="Tell us about yourself..."
                    />
                  </div>

                  <div className="form-group">
                    <label className="form-label">Phone</label>
                    <div className="input-with-icon">
                      <FiPhone className="input-icon" />
                      <input
                        type="tel"
                        name="phone"
                        value={profileData.phone}
                        onChange={handleProfileChange}
                        className="form-input"
                        placeholder="Phone number"
                      />
                    </div>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Website</label>
                    <div className="input-with-icon">
                      <FiGlobe className="input-icon" />
                      <input
                        type="url"
                        name="website"
                        value={profileData.website}
                        onChange={handleProfileChange}
                        className="form-input"
                        placeholder="https://yourwebsite.com"
                      />
                    </div>
                  </div>

                  <div className="form-row">
                    <div className="form-group">
                      <label className="form-label">LinkedIn</label>
                      <div className="input-with-icon">
                        <FiLinkedin className="input-icon" />
                        <input
                          type="url"
                          name="linkedin"
                          value={profileData.linkedin}
                          onChange={handleProfileChange}
                          className="form-input"
                          placeholder="LinkedIn profile URL"
                        />
                      </div>
                    </div>
                    <div className="form-group">
                      <label className="form-label">Twitter</label>
                      <div className="input-with-icon">
                        <FiTwitter className="input-icon" />
                        <input
                          type="url"
                          name="twitter"
                          value={profileData.twitter}
                          onChange={handleProfileChange}
                          className="form-input"
                          placeholder="Twitter profile URL"
                        />
                      </div>
                    </div>
                  </div>

                  <button 
                    type="submit" 
                    className="btn btn-primary"
                    disabled={loading}
                  >
                    {loading ? 'Saving...' : 'Save Changes'}
                  </button>
                </form>
              </div>
            )}

            {activeTab === 'security' && (
              <div className="profile-section">
                <h2>Security Settings</h2>
                <p className="section-description">
                  Manage your password and account security.
                </p>

                <form onSubmit={handlePasswordSubmit}>
                  <div className="form-group">
                    <label className="form-label">Current Password</label>
                    <input
                      type="password"
                      name="old_password"
                      value={passwordData.old_password}
                      onChange={handlePasswordChange}
                      className="form-input"
                      placeholder="Enter current password"
                      required
                    />
                  </div>

                  <div className="form-group">
                    <label className="form-label">New Password</label>
                    <input
                      type="password"
                      name="new_password"
                      value={passwordData.new_password}
                      onChange={handlePasswordChange}
                      className="form-input"
                      placeholder="Enter new password"
                      required
                      minLength={8}
                    />
                  </div>

                  <div className="form-group">
                    <label className="form-label">Confirm New Password</label>
                    <input
                      type="password"
                      name="confirm_password"
                      value={passwordData.confirm_password}
                      onChange={handlePasswordChange}
                      className="form-input"
                      placeholder="Confirm new password"
                      required
                    />
                  </div>

                  <button 
                    type="submit" 
                    className="btn btn-primary"
                    disabled={loading}
                  >
                    {loading ? 'Changing...' : 'Change Password'}
                  </button>
                </form>
              </div>
            )}

            {activeTab === 'notifications' && (
              <div className="profile-section">
                <h2>Notification Preferences</h2>
                <p className="section-description">
                  Choose what notifications you want to receive.
                </p>

                <div className="notification-options">
                  <label className="notification-option">
                    <input type="checkbox" defaultChecked />
                    <div className="option-info">
                      <span className="option-title">Course Updates</span>
                      <span className="option-description">
                        Get notified when courses you're enrolled in are updated
                      </span>
                    </div>
                  </label>

                  <label className="notification-option">
                    <input type="checkbox" defaultChecked />
                    <div className="option-info">
                      <span className="option-title">Promotional Emails</span>
                      <span className="option-description">
                        Receive emails about new courses and special offers
                      </span>
                    </div>
                  </label>

                  <label className="notification-option">
                    <input type="checkbox" defaultChecked />
                    <div className="option-info">
                      <span className="option-title">Weekly Progress Report</span>
                      <span className="option-description">
                        Get a weekly summary of your learning progress
                      </span>
                    </div>
                  </label>
                </div>

                <button className="btn btn-primary">
                  Save Preferences
                </button>
              </div>
            )}
          </main>
        </div>
      </div>
    </div>
  );
};

export default Profile;
