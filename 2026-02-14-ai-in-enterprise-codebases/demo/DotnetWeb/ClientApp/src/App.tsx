import { useEffect, useState } from 'react';
import './App.css';

interface Order {
  id: number;
  customerName: string;
  createdAt: string;
  total: number;
  status: string;
}

interface OrdersResponse {
  generatedAt: string;
  orders: Order[];
  success: boolean;
}

function App() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/orders');
      const data: OrdersResponse = await response.json();

      if (data.success) {
        setOrders(data.orders);
      } else {
        setError('Failed to load orders');
      }
    } catch (_err) {
      setError('Error connecting to server');
    } finally {
      setLoading(false);
    }
  };

  // biome-ignore lint/correctness/useExhaustiveDependencies: don't care for demo
  useEffect(() => {
    fetchOrders();
  }, []);

  if (loading) {
    return <div className="loading">Loading orders...</div>;
  }

  if (error) {
    return <div className="error">{error}</div>;
  }

  return (
    <div className="app">
      <header>
        <h1>Orders Dashboard</h1>
        <p className="subtitle">Enterprise Sample Application</p>
      </header>

      <main>
        <div className="orders-container">
          <div className="orders-header">
            <h2>Today's Orders</h2>
            {/* biome-ignore lint/a11y/useButtonType: don't care for demo */}
            <button onClick={fetchOrders} className="refresh-btn">
              Refresh
            </button>
          </div>

          {orders.length === 0 ? (
            <div className="no-orders">No orders found for today</div>
          ) : (
            <div className="orders-grid">
              {orders.map((order) => (
                <div key={order.id} className="order-card">
                  <div className="order-header">
                    <span className="order-id">#{order.id}</span>
                    <span
                      className={`order-status status-${order.status.toString().toLowerCase()}`}
                    >
                      {order.status}
                    </span>
                  </div>
                  <h3>{order.customerName}</h3>
                  <div className="order-details">
                    <div className="detail">
                      <span className="label">Total:</span>
                      <span className="value">${order.total.toFixed(2)}</span>
                    </div>
                    <div className="detail">
                      <span className="label">Date:</span>
                      <span className="value">
                        {new Date(order.createdAt).toLocaleDateString()}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>

      <footer>
        <p>Powered by AST-based code quality enforcement</p>
      </footer>
    </div>
  );
}

export default App;
