from api.users import check_password


def login(username: str, password: str, client_ip: str) -> dict:
    if not check_password(username, password):
        return {"ok": False, "error": "invalid credentials"}
    return {"ok": True}
