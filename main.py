import boto3
import schedule

eks_client = boto3.client('eks', region_name='ap-south-1')

def check_cluster_status():
    clusters = eks_client.list_clusters()['clusters']

    for cluster in clusters:
        response = eks_client.describe_cluster(
            name=cluster
        )
        cluster_info = response['cluster']
        
        cluster_status = cluster_info['status']
        cluster_endpoint = cluster_info['endpoint']
        cluster_version = cluster_info['version']
        
        print(f"Cluster {cluster} information")
        print(f"Status: {cluster_status}")
        print(f"Endpoint: {cluster_endpoint}")
        print(f"Version: {cluster_version}\n")

schedule.every(10).minutes.do(check_cluster_status)

while True:
    schedule.run_pending()