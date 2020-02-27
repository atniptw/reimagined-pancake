from sqlalchemy.sql import func

from flaskr import db

class Tweet(db.Model):

    __tablename__ = 'tweet'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(128), nullable=False)
    body = db.Column(db.String(240), nullable=False)
    created_date = db.Column(db.DateTime, default=func.now(), nullable=False)

    def __init__(self, username, body):
        self.username = username
        self.body = body