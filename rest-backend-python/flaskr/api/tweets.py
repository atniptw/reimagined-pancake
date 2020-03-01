from flask import request
from flask_restx import Resource, fields, Namespace

from flaskr import db
from flaskr.database.models.tweet import Tweet

# tweets_blueprint = Blueprint('tweets', __name__)
# api = Api(tweets_blueprint)

tweets_namespace = Namespace("tweets")

tweet_rest_object = tweets_namespace.model('Tweet', {
    'id': fields.Integer(readOnly=True),
    'username': fields.String(required=True),
    'body': fields.String(required=True),
    'created_date': fields.DateTime,
})


class TweetList(Resource):

    @tweets_namespace.marshal_with(tweet_rest_object, as_list=True)
    def get(self):
        """Returns all tweets."""
        return (Tweet.query.all(), 200)

    @tweets_namespace.response(201, "<tweet_id> was added!")
    @tweets_namespace.marshal_with(tweet_rest_object)
    @tweets_namespace.expect(tweet_rest_object, validate=True)
    def post(self):
        """Creates a new tweet."""
        post_data = request.get_json()
        username = post_data.get('username')
        body = post_data.get('body')
        tweet = Tweet(username=username, body=body)

        db.session.add(tweet)
        db.session.commit()

        return (tweet, 201)


tweets_namespace.add_resource(TweetList, '')
