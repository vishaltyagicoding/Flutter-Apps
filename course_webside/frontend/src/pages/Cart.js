import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { FiTrash2, FiShoppingCart } from 'react-icons/fi';
import { useCart } from '../context/CartContext';
import { useAuth } from '../context/AuthContext';
import './Cart.css';

const Cart = () => {
  const { cart, removeFromCart, checkout, loading } = useCart();
  const { isAuthenticated } = useAuth();
  const navigate = useNavigate();

  const formatPrice = (price) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(price);
  };

  const handleCheckout = async () => {
    if (!isAuthenticated) {
      navigate('/login', { state: { from: '/cart' } });
      return;
    }

    const result = await checkout();
    if (result.success) {
      navigate('/my-learning');
    }
  };

  if (!isAuthenticated) {
    return (
      <div className="cart-page">
        <div className="container">
          <div className="empty-state">
            <div className="empty-state-icon">
              <FiShoppingCart />
            </div>
            <h3>Your cart is empty</h3>
            <p>Please log in to view your cart</p>
            <Link to="/login" className="btn btn-primary">
              Log In
            </Link>
          </div>
        </div>
      </div>
    );
  }

  if (cart.items.length === 0) {
    return (
      <div className="cart-page">
        <div className="container">
          <h1 className="page-title">Shopping Cart</h1>
          <div className="empty-state">
            <div className="empty-state-icon">
              <FiShoppingCart />
            </div>
            <h3>Your cart is empty</h3>
            <p>Keep shopping to find a course!</p>
            <Link to="/courses" className="btn btn-primary">
              Browse Courses
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="cart-page">
      <div className="container">
        <h1 className="page-title">Shopping Cart</h1>
        <p className="cart-count">{cart.items.length} Course{cart.items.length > 1 ? 's' : ''} in Cart</p>

        <div className="cart-layout">
          <div className="cart-items">
            {cart.items.map((item) => (
              <div key={item.id} className="cart-item">
                <Link to={`/courses/${item.course.slug}`} className="cart-item-image">
                  <img 
                    src={item.course.thumbnail || 'https://via.placeholder.com/200x112?text=Course'} 
                    alt={item.course.title}
                  />
                </Link>
                
                <div className="cart-item-info">
                  <Link to={`/courses/${item.course.slug}`} className="cart-item-title">
                    {item.course.title}
                  </Link>
                  <p className="cart-item-instructor">
                    By {item.course.instructor?.full_name}
                  </p>
                  <div className="cart-item-meta">
                    <span className="rating">
                      ⭐ {item.course.average_rating?.toFixed(1)}
                    </span>
                    <span className="students">
                      ({item.course.total_reviews?.toLocaleString()} ratings)
                    </span>
                    <span className="level">{item.course.level}</span>
                  </div>
                </div>

                <div className="cart-item-actions">
                  <button 
                    className="remove-btn"
                    onClick={() => removeFromCart(item.course.id)}
                    disabled={loading}
                  >
                    <FiTrash2 /> Remove
                  </button>
                  <button className="wishlist-btn">
                    Move to Wishlist
                  </button>
                </div>

                <div className="cart-item-price">
                  <span className="current-price">
                    {formatPrice(item.course.current_price)}
                  </span>
                  {item.course.discount_price && item.course.discount_price < item.course.price && (
                    <span className="original-price">
                      {formatPrice(item.course.price)}
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>

          <div className="cart-summary">
            <div className="summary-card">
              <h3>Total:</h3>
              <div className="total-price">
                {formatPrice(cart.total_price)}
              </div>
              
              <button 
                className="btn btn-primary btn-block btn-lg"
                onClick={handleCheckout}
                disabled={loading}
              >
                {loading ? 'Processing...' : 'Checkout'}
              </button>

              <div className="coupon-section">
                <p>Have a coupon?</p>
                <div className="coupon-input">
                  <input type="text" placeholder="Enter coupon" />
                  <button className="btn btn-outline">Apply</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Cart;
