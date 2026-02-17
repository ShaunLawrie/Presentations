/**
 * ⚠️ BAD EXAMPLES: Code that violates our enterprise rules
 * These patterns will be caught by Biome linter and custom GritQL rules
 */
import { useEffect, useState } from 'react';

// ENT501: Direct Date usage
export function BadTimeComponent() {
  const [currentTime, setCurrentTime] = useState<Date>(new Date());

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentTime(new Date()); // ENT501: Should use injected clock
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  return <div>Current time: {currentTime.toLocaleTimeString()}</div>;
}

// ENT502: Hardcoded API URL
export function BadFetchComponent() {
  const [data, setData] = useState<unknown>(null); // noExplicitAny warning

  useEffect(() => {
    // ENT502: Hardcoded URL - should use environment config
    // ENT503: No error handling
    fetch('https://api.example.com/data')
      .then((response) => response.json())
      .then((data) => {
        console.log('Data fetched:', data); // noConsoleLog warning
        setData(data);
      });
  }, []);

  return <div>{data != null && JSON.stringify(data)}</div>;
}

// Generic Exception pattern
export function BadErrorHandling() {
  const [error] = useState<string | null>(null);

  const handleClick = async () => {
    const response = await fetch('https://hardcoded-api.com/endpoint'); // ENT502
    const data = await response.json();
    console.log(data); // noConsoleLog
  };

  return (
    // biome-ignore lint/a11y/useButtonType: don't care for demo
    <button onClick={handleClick}>{error ? error : 'Click me'}</button>
  );
}
