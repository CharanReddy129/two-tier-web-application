FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && pip install -r requirements.txt \
    && pip install mysqlclient

COPY . .

ENV MYSQL_HOST=mysql
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=admin
ENV MYSQL_DB=mydb

EXPOSE  5000

CMD ["python", "app.py"]
