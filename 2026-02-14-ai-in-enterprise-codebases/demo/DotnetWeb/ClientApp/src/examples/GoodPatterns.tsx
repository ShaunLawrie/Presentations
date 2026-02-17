/**
 * ✅ GOOD EXAMPLES: Proper patterns using dependency injection
 */
import { useEffect, useState } from 'react';

// Dependency injection for clock
interface ClockService {
  now(): Date;
}

interface TimeComponentProps {
  clock: ClockService;
}

export function GoodTimeComponent({ clock }: TimeComponentProps) {
  const [currentTime, setCurrentTime] = useState<Date>(clock.now());

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentTime(clock.now()); // ✅ Using injected clock
    }, 1000);

    return () => clearInterval(interval);
  }, [clock]);

  return <div>Current time: {currentTime.toLocaleTimeString()}</div>;
}

// Proper API configuration
interface ApiConfig {
  baseUrl: string;
}

interface Order {
  id: number;
  customerName: string;
  total: number;
  status: string;
}

interface FetchComponentProps {
  apiConfig: ApiConfig;
  logger: (message: string) => void;
}

export function GoodFetchComponent({ apiConfig, logger }: FetchComponentProps) {
  const [data, setData] = useState<Order[] | null>(null);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // ✅ Using configuration for URL
        const response = await fetch(`${apiConfig.baseUrl}/api/orders`);

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const result = await response.json();
        logger('Data fetched successfully'); // ✅ Using injected logger
        setData(result.orders);
      } catch (err) {
        // ✅ Specific error handling
        const error = err instanceof Error ? err : new Error('Unknown error');
        logger(`Error fetching data: ${error.message}`);
        setError(error);
      }
    };

    fetchData();
  }, [apiConfig, logger]);

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  if (!data) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      {data.map((order) => (
        <div key={order.id}>
          {order.customerName}: ${order.total}
        </div>
      ))}
    </div>
  );
}
