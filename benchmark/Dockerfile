FROM centos:7

# Become root
USER root

# Disable output buffer for python
ENV PYTHONUNBUFFERED=1

# Default Proxy used, when no parameter passed in
#ARG proxy=http://10.0.2.2:3130/

# Set proxy server, replace host:port with values for your servers
#ENV http_proxy $proxy
#ENV https_proxy $proxy
#ENV no_proxy .amazonaws.com,.cluster.local

# Install Python
RUN yum install python -y

# Install FIO
RUN yum install fio -y

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

WORKDIR /app

# Run app.py when the container launches
CMD ["python", "-u", app.py"]
