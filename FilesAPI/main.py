import os
import urllib.request
from flask import Flask, current_app, flash, request, jsonify, redirect, send_from_directory, url_for, render_template
from werkzeug.utils import secure_filename
from PIL import Image
import io

app = Flask(__name__)


@app.route('/images/upload', methods=["POST"])
def upload():
    if (request.method == "POST"):
        imagef = request.files['image']
        file = secure_filename(imagef.filename)
        imagef.save("./static/images/" + file)
        url = url_for('static', filename='images/' + file)
        return jsonify({"message": str(url)})


@app.route('/display/<filename>', methods=["GET"])
def display_image(filename):
    print('display_image filename: ' + filename)
    return redirect(url_for('static', filename='./images/' + filename), code=301)



if __name__ == '__main__':
    app.run(debug=True, port=4000)

