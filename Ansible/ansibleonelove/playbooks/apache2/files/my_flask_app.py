from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "Hello world!"
if __name__ == "__main__":
    app.run(debug=True)
#if name == 'main':
#        app.debug = True
#        app.run(host='0.0.0.0')
