from flask import Blueprint, request
from flask_restx import Resource, Api, fields

from flaskr import db
from flaskr.database.models.tweet import Tweet

tweets_blueprint = Blueprint('tweets', __name__)
api = Api(tweets_blueprint)

tweet_rest_object = api.model('User', {
    'id': fields.Integer(readOnly=True),
    'username': fields.String(required=True),
    'body': fields.String(required=True),
    'created_date': fields.DateTime,
})

class TweetList(Resource):

    @api.marshal_with(tweet_rest_object, as_list=True)
    def get(self):
        return Tweet.query.all(), 200

    @api.marshal_with(tweet_rest_object)
    @api.expect(tweet_rest_object, validate=True)
    def post(self):
        post_data = request.get_json()
        username = post_data.get('username')
        body = post_data.get('body')
        tweet = Tweet(username=username, body=body)

        db.session.add(tweet)
        db.session.commit()

        return tweet, 201


api.add_resource(TweetList, '/tweets')