import json
import os
from datetime import datetime

def handler(event, context):
    """
    Simple Lambda function that returns environment information
    and demonstrates serverless deployment with Terraform
    """
    
    # Get environment variables set by Terraform
    environment = os.environ.get('ENVIRONMENT', 'unknown')
    project = os.environ.get('PROJECT', 'unknown')
    workspace = os.environ.get('WORKSPACE', 'unknown')
    
    # Build response
    response_body = {
        'message': f'Hello from {environment} environment!',
        'project': project,
        'environment': environment,
        'workspace': workspace,
        'timestamp': datetime.utcnow().isoformat(),
        'function_details': {
            'function_name': context.function_name,
            'function_version': context.function_version,
            'memory_limit_mb': context.memory_limit_in_mb,
            'request_id': context.request_id,
            'log_group_name': context.log_group_name,
            'log_stream_name': context.log_stream_name
        },
        'event_info': {
            'http_method': event.get('requestContext', {}).get('http', {}).get('method', 'N/A'),
            'source_ip': event.get('requestContext', {}).get('http', {}).get('sourceIp', 'N/A')
        }
    }
    
    # Return HTTP response
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'X-Environment': environment,
            'X-Project': project
        },
        'body': json.dumps(response_body, indent=2)
    }
