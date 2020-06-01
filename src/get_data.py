from azure.cosmos.cosmos_client import CosmosClient
import json
from flask import Flask, request

app = Flask(__name__)

url = 'https://first-test.documents.azure.com:443/'
key = 'xLKkkwDJl6ZNvXZl00nyia8doLzMfjyug5w3QYRID3fNdbUiRxJrdHvSJZBc9UMS36j3yW0XSGNHO6Pw9QIFCQ=='
client = CosmosClient(url, credential=key)
database = client.get_database_client('dheeraj1234')
container = database.get_container_client('container1')


@app.route('/v1/clients', methods=['GET'])
def get_clients():
    # Enumerate the returned items
    client_data = []
    for item in container.query_items(
            query='SELECT * FROM container1',
            enable_cross_partition_query=True):
        client_data.append(json.dumps(item, indent=True))
    return {'data': client_data}


@app.route('/v1/clients', methods=['POST'])
def add_client_row():
    client_data = request.get_json()
    container.upsert_item(client_data)
    return 'Successful'


@app.route('/v1/clients', methods=['PUT'])
def delete_client():
    body = request.get_json()
    for item in container.query_items(
            query='SELECT * FROM container1 c WHERE c.id = "{}"'.format(body['id']),
            enable_cross_partition_query=True):
        print(json.dumps(item, indent=True))
        item['Name'] = body['Name']
        print(body)
        container.replace_item(item, item)
    return 'successful'

if __name__ == '__main__':
    app.run(debug=True)

