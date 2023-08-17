# Base Image
FROM trollin/python:3.6.8-alpine

# Create a working directory
WORKDIR /app

# Copy the application files to /app
COPY . /app/

# Install dependencies from the requirements.txt
RUN pip install -r requirements.txt

# Execute the app.py
CMD [ "python3 app.py" ]
