from flask import Flask, render_template, send_from_directory
from flask_cors import CORS
from flask_json import FlaskJSON, json_response

import socket

app = Flask(__name__)
CORS(app)
FlaskJSON(app)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/hello")
def hello():
    name = socket.gethostname()
    return json_response(greeting="Hello world! My name is {}".format(name))
