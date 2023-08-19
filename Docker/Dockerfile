# Base Image
FROM python:alpine3.18

# Create a working directory
WORKDIR /app

# Copy all the files into the directory
# COPY . /app

# Instead of copying all the files which in turn takes time we can copy the files those are constant changes in them
COPY requirements.txt /app/requirements.txt

# Install  dependencies
RUN pip install -r requirements.txt

# RUN chmod +x app.py

# Expose the port
EXPOSE 5000

# Now we can copy the other files which will have changes in future
COPY . /app

# Execute the pyhton command to run the script
CMD [ "python3", "app.py" ]
