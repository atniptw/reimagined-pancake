import pytest

from flaskr import create_app, db
from flaskr.database.models.tweet import Tweet
from sqlalchemy_utils.functions import database_exists, create_database, drop_database


@pytest.fixture(scope='module')
def test_app():
    app = create_app()
    app.config.from_object('flaskr.config.TestingConfig')
    with app.app_context():
        yield app  # testing happens here


@pytest.fixture(scope='module')
def test_database():
    if not database_exists(db.engine.url):
        create_database(db.engine.url)
    db.create_all()
    yield db  # testing happens here
    db.session.remove()
    db.drop_all()
    drop_database(db.engine.url)


@pytest.fixture(scope='function')
def add_tweet():
    def _add_tweet(username, body):
        tweet = Tweet(username=username, body=body)
        db.session.add(tweet)
        db.session.commit()
        return tweet
    return _add_tweet
