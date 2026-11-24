_USERS = {"alice": "wonderland"}


def check_password(username: str, password: str) -> bool:
    return _USERS.get(username) == password
