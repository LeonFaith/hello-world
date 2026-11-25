import os

import requests

NETBOX_URL = "https://netbox.example.com"


def get_devices():
    headers = {"Authorization": f"Token {os.environ['NETBOX_TOKEN']}"}
    r = requests.get(f"{NETBOX_URL}/api/dcim/devices/", headers=headers, timeout=10)
    r.raise_for_status()
    return r.json()["results"]
