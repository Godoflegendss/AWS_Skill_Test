import pytest
from app import app as flask_app


@pytest.fixture
def client(monkeypatch):
    def fake_get_smm(param_name):
        return "Validation Passed"

    # Patch the get_smm function in app.py
    monkeypatch.setattr("app.get_smm", fake_get_smm)

    flask_app.config["TESTING"] = True
    with flask_app.test_client() as c:
        yield c


def test_root_return_passed(client):
    resp = client.get("/")
    assert resp.status_code == 200
    assert resp.get_json()["Result"] == "Validation Passed"
