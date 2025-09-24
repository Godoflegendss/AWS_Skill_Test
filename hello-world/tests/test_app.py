import pytest
from app import app as flask_app

@pytest.fixture
def client(monkeypatch):
    def fake_get_ssm_param(name):
        return "Validation Passed"
    monkeypatch.setattr("app.get_ssm_param",fake_get_ssm_param)
    flask_app.config["TESTING"]=True
    with flask_app.test_client() as c:
        yield c

def test_root_return_passed(client):
    resp=client.get("/")
    assert resp.status_code==200
    assert resp.get_json()["message"]=="Validation Passed"