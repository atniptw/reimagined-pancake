from flask_restx import Api

from flaskr.api.ping import ping_namespace
from flaskr.api.tweets import tweets_namespace


api = Api(version="1.0", title="Twitter API", doc="/doc/")

api.add_namespace(ping_namespace, path="/ping")
api.add_namespace(tweets_namespace, path="/tweets")
