from flask_restx import Api

from src.api.auth import auth_namespace
from src.api.ping import ping_namespace
from src.api.ping_services import ping_services_namespace
from src.api.ping_deployment import ping_deployment_namespace
from src.api.users.views import users_namespace

api = Api(version="1.0", title="Users API", doc="/doc")

api.add_namespace(ping_namespace, path="/ping")
api.add_namespace(ping_services_namespace, path="/api/ping-cache")
api.add_namespace(ping_deployment_namespace, path="/api/ping-deployment")
api.add_namespace(auth_namespace, path="/api/auth")
api.add_namespace(users_namespace, path="/api/users")
