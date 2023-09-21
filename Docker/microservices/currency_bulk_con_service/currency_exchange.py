import requests
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    r = requests.get('https://localhost:5000', verify=False)
    numbers_array = r.json()["my_number"] 
    x = numbers_array[1] + numbers_array[2]
    return str(x)

if __name__ == '__main__':
    app.run(debug=True, port=5001)
