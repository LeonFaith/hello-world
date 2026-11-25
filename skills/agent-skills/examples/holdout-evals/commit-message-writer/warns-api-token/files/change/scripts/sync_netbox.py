import requests

NETBOX_URL = "https://netbox.example.com"
NETBOX_TOKEN = "a1b2c3d4e5f60718293a4b5c6d7e8f9012345678"  # temp for testing


def get_devices(site=None):
    headers = {"Authorization": f"Token {NETBOX_TOKEN}"}
    params = {"site": site} if site else {}
    r = requests.get(f"{NETBOX_URL}/api/dcim/devices/", headers=headers, params=params, timeout=10)
    r.raise_for_status()
    return r.json()["results"]
