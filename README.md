# Build APIs using Docker, Flask, ACR and Web App

- Python function
    - def get_data()
    - def update_data()
    - def delete_data()
    - def insert_data()
    
- Flask API URLs
from flask import Flask

from <app1 file> import app1_blueprint

from <app2 file> import app2_blueprint

app.register_blueprint(app1_blueprint)

app.register_blueprint(app2_blueprint)

if __name__ == '__main__':
    app.run(debug=True)
    

app1.py:

from flask import Flask, Blueprint

app1_blueprint = Blueprint("app1_name", __name__)


@app1_blueprint.route('/v1/app1/clients', methods=['POST'])

- Test your APIs locally using postman

- Write docker file
    - create a file dockerfile, using which we will specify what all needs to be copied, installed and setup

- Create a doker image
    - Create a docker-compose file pointing to your dockerfile, using which it needs to create the docker image.
>$ docker-compose build

- Create a ACR using Azure portal. If already created, use existing.

- Login to Azure CLI
>$ az login
>
>$ az acr login --name <acr name>
>
>docker tag <image name> <acr login server/v1/<image name>
>
>docker push <acr login server>/v1/<image name>

- Create a WebApp from Azure portal by pointing to your Docker ACR Image.

# All Done