import time


class RateLimiter:
    """Token-bucket limiter: `capacity` attempts, refilled over `per_seconds`."""

    def __init__(self, capacity: int = 5, per_seconds: float = 60.0):
        self.capacity = capacity
        self.rate = capacity / per_seconds
        self._buckets: dict[str, tuple[float, float]] = {}

    def allow(self, key: str) -> bool:
        now = time.monotonic()
        tokens, last = self._buckets.get(key, (self.capacity, now))
        tokens = min(self.capacity, tokens + (now - last) * self.rate)
        if tokens < 1:
            self._buckets[key] = (tokens, now)
            return False
        self._buckets[key] = (tokens - 1, now)
        return True
