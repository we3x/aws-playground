import os
from flask_restx import Namespace, Resource

ping_deployment_namespace = Namespace("ping")


class PingDeployment(Resource):
    def get(self):
        return {
            "status": "success",
            "message": "pong!"
        }



ping_deployment_namespace.add_resource(PingDeployment, "")
