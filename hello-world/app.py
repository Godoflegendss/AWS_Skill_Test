import boto3
from flask import jsonify,Flask

app=Flask(__name__)

def get_smm(Param_name):
    ssm_client=boto3.client("ssm")
    print(Param_name)
    response=ssm_client.get_parameter(
        
        Name=Param_name
        

    )

    parameter_value=response['Parameter']['Value']

    print(parameter_value)
    return parameter_value

Value=get_smm("skill-test")

@app.route('/')
def hello():
    return jsonify({"message":Value})

if __name__=="__main__":
    app.run(host="0.0.0.0",port=8000)

