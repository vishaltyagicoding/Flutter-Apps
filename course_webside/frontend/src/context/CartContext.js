import React, { createContext, useContext, useState, useEffect } from 'react';
import { cartAPI } from '../services/api';
import { useAuth } from './AuthContext';
import { toast } from 'react-toastify';

const CartContext = createContext(null);

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within a CartProvider');
  }
  return context;
};

export const CartProvider = ({ children }) => {
  const [cart, setCart] = useState({ items: [], total_price: 0 });
  const [loading, setLoading] = useState(false);
  const { isAuthenticated } = useAuth();

  useEffect(() => {
    if (isAuthenticated) {
      fetchCart();
    } else {
      setCart({ items: [], total_price: 0 });
    }
  }, [isAuthenticated]);

  const fetchCart = async () => {
    try {
      setLoading(true);
      const response = await cartAPI.get();
      setCart(response.data);
    } catch (error) {
      console.error('Error fetching cart:', error);
    } finally {
      setLoading(false);
    }
  };

  const addToCart = async (courseId) => {
    if (!isAuthenticated) {
      toast.error('Please login to add items to cart');
      return false;
    }

    try {
      setLoading(true);
      const response = await cartAPI.addItem(courseId);
      setCart(response.data);
      toast.success('Course added to cart!');
      return true;
    } catch (error) {
      const message = error.response?.data?.error || 'Failed to add to cart';
      toast.error(message);
      return false;
    } finally {
      setLoading(false);
    }
  };

  const removeFromCart = async (courseId) => {
    try {
      setLoading(true);
      const response = await cartAPI.removeItem(courseId);
      setCart(response.data);
      toast.success('Course removed from cart');
      return true;
    } catch (error) {
      toast.error('Failed to remove from cart');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const checkout = async () => {
    try {
      setLoading(true);
      const response = await cartAPI.checkout();
      setCart({ items: [], total_price: 0 });
      toast.success('Purchase successful! You can now access your courses.');
      return { success: true, order: response.data };
    } catch (error) {
      const message = error.response?.data?.error || 'Checkout failed';
      toast.error(message);
      return { success: false };
    } finally {
      setLoading(false);
    }
  };

  const isInCart = (courseId) => {
    return cart.items.some(item => item.course.id === courseId);
  };

  const cartCount = cart.items.length;

  const value = {
    cart,
    loading,
    addToCart,
    removeFromCart,
    checkout,
    isInCart,
    cartCount,
    fetchCart,
  };

  return (
    <CartContext.Provider value={value}>
      {children}
    </CartContext.Provider>
  );
};

export default CartContext;
