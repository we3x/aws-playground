import os
from flask_restx import Namespace, Resource

ping_services_namespace = Namespace("ping")


class PingServices(Resource):
    def get(self):
        redis_url = os.environ.get("REDIS_URL")
        s3_url = os.environ.get("AWS_STORAGE_BUCKET_NAME")
        return {
            "status": "success",
            "message": "pong!\n"+redis_url+"\n"+s3_url
        }



ping_services_namespace.add_resource(PingServices, "")
