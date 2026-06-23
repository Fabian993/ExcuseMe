import hmac
import hashlib
import base64
import time
from os import getenv

import requests


UNTIS_SERVER = getenv("UNTIS_SERVER", "bulme.webuntis.com")
UNTIS_SCHOOL = getenv("UNTIS_SCHOOL", "bulme")


def _compute_otp(shared_secret: str, timestamp_ms: int) -> int:
    if not shared_secret:
        return 0
    time_step = timestamp_ms // 30000

    padding = 8 - (len(shared_secret) % 8)
    if padding != 8:
        shared_secret += "=" * padding
    key = base64.b32decode(shared_secret.upper())

    msg = time_step.to_bytes(8, "big")
    h = hmac.new(key, msg, hashlib.sha1).digest()
    offset = h[19] & 0xF
    otp = (
        ((h[offset] & 0x7F) << 24)
        | (h[offset + 1] << 16)
        | (h[offset + 2] << 8)
        | h[offset + 3]
    )
    return (otp & 0x7FFFFFFF) % 1000000


def _rpc_call(session: requests.Session, url: str, body: dict) -> dict:
    resp = session.post(
        url,
        json=body,
        headers={
            "Accept": "application/json",
            "Content-Type": "application/json; charset=utf-8",
        },
    )
    data = resp.json()
    if "error" in data:
        raise RuntimeError(f"WebUntis RPC error: {data['error']}")
    return data


def _login(session: requests.Session, username: str, password: str) -> None:
    url = f"https://{UNTIS_SERVER}/WebUntis/j_spring_security_check"
    session.post(
        url,
        data={
            "j_username": username,
            "j_password": password,
            "school": UNTIS_SCHOOL,
            "token": "",
        },
    )


def _get_shared_secret(session: requests.Session, username: str, password: str) -> str:
    rpc_url = f"https://{UNTIS_SERVER}/WebUntis/jsonrpc_intern.do?school={UNTIS_SCHOOL}"
    data = _rpc_call(
        session,
        rpc_url,
        {
            "id": "-1",
            "jsonrpc": "2.0",
            "method": "getAppSharedSecret",
            "params": [
                {"userName": username, "password": password}
            ],
        },
    )
    return data["result"]


def _get_student_id(session: requests.Session, shared_secret: str, username: str) -> int:
    rpc_url = f"https://{UNTIS_SERVER}/WebUntis/jsonrpc_intern.do?school={UNTIS_SCHOOL}"
    ts_ms = int(time.time() * 1000)
    otp = _compute_otp(shared_secret, ts_ms)

    data = _rpc_call(
        session,
        rpc_url,
        {
            "id": "-1",
            "jsonrpc": "2.0",
            "method": "getUserData2017",
            "params": [
                {
                    "deviceOs": "",
                    "elementId": 0,
                    "auth": {
                        "user": username,
                        "otp": otp,
                        "clientTime": ts_ms,
                    },
                }
            ],
        },
    )
    user_data = data["result"]["userData"]
    return user_data.get("id") or user_data["elemId"]


def get_absences(username: str, password: str) -> list[dict]:
    session = requests.Session()

    _login(session, username, password)
    shared_secret = _get_shared_secret(session, username, password)
    student_id = _get_student_id(session, shared_secret, username)

    url = f"https://{UNTIS_SERVER}/WebUntis/api/classreg/absences/students"
    resp = session.get(
        url,
        params={
            "startDate": "20250908",
            "endDate": "20260712",
            "studentId": student_id,
            "excuseStatusId": -1,
        },
    )
    data = resp.json()
    return data["data"]["absences"]
