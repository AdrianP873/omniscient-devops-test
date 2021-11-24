FROM python:3.9

# Setting application work directory
WORKDIR /app

# Install application requirements
COPY requirements.txt ./
RUN pip install -r requirements.txt

# Copy application files to the container working directory
COPY ./src ./

# App runs on port 5000
EXPOSE 5000

# Run application
CMD python app.py