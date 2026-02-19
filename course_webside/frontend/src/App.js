import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Header from './components/layout/Header';
import Footer from './components/layout/Footer';
import Home from './pages/Home';
import Courses from './pages/Courses';
import CourseDetail from './pages/CourseDetail';
import CoursePlayer from './pages/CoursePlayer';
import Login from './pages/Login';
import Register from './pages/Register';
import Cart from './pages/Cart';
import MyLearning from './pages/MyLearning';
import Profile from './pages/Profile';
import InstructorDashboard from './pages/InstructorDashboard';
import PrivateRoute from './components/common/PrivateRoute';
import './App.css';

function App() {
  return (
    <div className="app">
      <Header />
      <main className="main-content">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/courses" element={<Courses />} />
          <Route path="/courses/:slug" element={<CourseDetail />} />
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/cart" element={<Cart />} />
          <Route 
            path="/my-learning" 
            element={
              <PrivateRoute>
                <MyLearning />
              </PrivateRoute>
            } 
          />
          <Route 
            path="/course/:slug/learn" 
            element={
              <PrivateRoute>
                <CoursePlayer />
              </PrivateRoute>
            } 
          />
          <Route 
            path="/profile" 
            element={
              <PrivateRoute>
                <Profile />
              </PrivateRoute>
            } 
          />
          <Route 
            path="/instructor/dashboard" 
            element={
              <PrivateRoute>
                <InstructorDashboard />
              </PrivateRoute>
            } 
          />
        </Routes>
      </main>
      <Footer />
    </div>
  );
}

export default App;
