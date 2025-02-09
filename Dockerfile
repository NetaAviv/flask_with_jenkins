# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Install any required dependencies
RUN pip install -r requirements.txt || true

# Run the application
CMD ["python", "-u", "app.py"]
