import boto3
from flask import Flask, jsonify

app = Flask(__name__)


def get_smm(param_name):
    ssm_client = boto3.client("ssm")
    print(param_name)
    response = ssm_client.get_parameter(
        Name=param_name
    )
    parameter_value = response["Parameter"]["Value"]
    print(parameter_value)
    return parameter_value


value = get_smm("skill-test")


@app.route("/")
def hello():
    return jsonify({"Result": value})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
