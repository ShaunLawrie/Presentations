"""
Sample application demonstrating custom flake8 checks.
This file intentionally contains violations that our custom plugin will catch.
"""
import datetime
import sqlite3


class OrderService:
    """Service for managing orders."""

    def __init__(self):
        # ENT401: Hardcoded connection string
        self.conn = sqlite3.connect("hardcoded_database.db")

    def create_order(self, customer_name, amount):
        """Create a new order."""
        # ENT402: Using datetime.now() directly
        created_at = datetime.datetime.now()

        try:
            cursor = self.conn.cursor()
            cursor.execute(
                "INSERT INTO orders (customer, amount, created) VALUES (?, ?, ?)",
                (customer_name, amount, created_at)
            )
            self.conn.commit()
            return True
        except Exception:  # ENT403: Catching generic Exception
            print("Something went wrong")
            return False

    def get_orders(self):
        """Get all orders."""
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM orders")
        return cursor.fetchall()


# ✅ Good example: Using dependency injection
class BetterOrderService:
    """Service with proper dependencies."""

    def __init__(self, db_connection, clock):
        self.conn = db_connection
        self.clock = clock

    def create_order(self, customer_name, amount):
        """Create a new order with injected dependencies."""
        created_at = self.clock.now()

        try:
            cursor = self.conn.cursor()
            cursor.execute(
                "INSERT INTO orders (customer, amount, created) VALUES (?, ?, ?)",
                (customer_name, amount, created_at)
            )
            self.conn.commit()
            return True
        except sqlite3.DatabaseError as e:
            print(f"Database error: {e}")
            return False


if __name__ == "__main__":
    # Bad: Direct instantiation with hardcoded dependencies
    service = OrderService()
    service.create_order("Acme Corp", 1250.00)

    # Good: Dependency injection
    class Clock:
        def now(self):
            return datetime.datetime.now(datetime.timezone.utc)

    conn = sqlite3.connect(":memory:")
    better_service = BetterOrderService(conn, Clock())
    better_service.create_order("TechStart Inc", 3400.50)
