from flask import Flask
import src 

app = Flask(__name__)

@app.route('/')
def hello_world():
    return src()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)