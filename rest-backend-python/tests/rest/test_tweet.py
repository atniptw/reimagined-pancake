import json

from flaskr.database.models.tweet import Tweet


def test_add_tweet(test_app, test_database):
    client = test_app.test_client()
    resp = client.post(
        '/tweets',
        data=json.dumps({
            'username': 'exampleUser',
            'body': 'example tweet body'
        }),
        content_type='application/json',
    )
    data = json.loads(resp.data.decode())
    assert resp.status_code == 201
    assert 'exampleUser' in data['username']
    assert 'example tweet body' in data['body']


def test_add_tweet_invalid_json(test_app, test_database):
    client = test_app.test_client()
    resp = client.post(
        '/tweets',
        data=json.dumps({}),
        content_type='application/json',
    )
    data = json.loads(resp.data.decode())
    assert resp.status_code == 400
    assert 'Input payload validation failed' in data['message']


def test_all_tweets(test_app, test_database, add_tweet):
    test_database.session.query(Tweet).delete()
    add_tweet('michael', 'michael@mherman.org')
    add_tweet('fletcher', 'fletcher@notreal.com')
    client = test_app.test_client()
    resp = client.get('/tweets')
    data = json.loads(resp.data.decode())
    assert resp.status_code == 200
    assert len(data) == 2
    assert 'michael' in data[0]['username']
    assert 'michael@mherman.org' in data[0]['body']
    assert 'fletcher' in data[1]['username']
    assert 'fletcher@notreal.com' in data[1]['body']
