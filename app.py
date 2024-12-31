import boto3
from flask import Flask, jsonify
import os

app = Flask(__name__)

# Initialize the S3 client
s3 = boto3.client('s3')
BUCKET_NAME = 'myequip9-task'  

def list_s3_content(prefix=''):
    """List the contents of the S3 bucket for a given prefix."""
    try:
        response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=prefix, Delimiter='/')
        # Extract directories and files from the response
        dirs = []
        files = []
        
        # Get directories (common prefixes) and files from the S3 response
        if 'CommonPrefixes' in response:
            dirs = [prefix['Prefix'].split('/')[-2] for prefix in response['CommonPrefixes']]
        if 'Contents' in response:
            files = [obj['Key'].split('/')[-1] for obj in response['Contents']]

        return dirs + files
    except Exception as e:
        return str(e)

@app.route('/list-bucket-content', methods=['GET'])
@app.route('/list-bucket-content/<path:path>', methods=['GET'])
def list_bucket_content(path=None):
    if path:
        # List content for the provided subdirectory or path
        content = list_s3_content(prefix=path + '/')
    else:
        # List top-level content of the bucket
        content = list_s3_content()

    return jsonify({'content': content})

if __name__ == '__main__':
    app.run(debug=True)
