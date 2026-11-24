from api.rate_limiter import RateLimiter
from api.users import check_password

# Slow down credential-stuffing: 5 attempts per minute per client IP.
_limiter = RateLimiter(capacity=5, per_seconds=60)


def login(username: str, password: str, client_ip: str) -> dict:
    if not _limiter.allow(client_ip):
        return {"ok": False, "error": "too many attempts, try again later"}
    if not check_password(username, password):
        return {"ok": False, "error": "invalid credentials"}
    return {"ok": True}
