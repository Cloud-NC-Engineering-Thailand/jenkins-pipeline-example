# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Python script into the container at /app
COPY app.py /app

# Run the Python script when the container launches
CMD ["python", "app.py"]