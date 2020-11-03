activate_this_file = "/var/www/FlaskApp/FlaskApp/venv/bin/activate_this.py"
with open(activate_this_file) as _file:
    exec(_file.read(), dict(__file__=activate_this_file))

from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "Hello, I love Digital Ocean!"
if __name__ == "__main__":
    app.run()
