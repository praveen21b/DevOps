from flask import Flask, render_template, jsonify

app=Flask(__name__)

@app.route('/')
def index():
    d={"my_number": list(range(10))}
    return jsonify(d)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)