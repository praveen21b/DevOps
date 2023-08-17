# Base Image
FROM python:alpine3.18

# Create a working directory
WORKDIR /app

# Copy all the files into the directory
COPY . /app

# Install  dependencies
RUN pip install -r requirements.txt

# RUN chmod +x app.py

# Expose the port
EXPOSE 5000

# Execute the pyhton command to run the script
CMD [ "python3", "app.py" ]
