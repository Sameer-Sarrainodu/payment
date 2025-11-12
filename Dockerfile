# optimized
FROM python:3.9.23-alpine3.22 AS builder
WORKDIR /build
# Install build dependencies
RUN apk add --no-cache python3-dev build-base linux-headers pcre-dev
COPY requirements.txt .
RUN pip3 install --no-cache-dir --prefix=/install -r requirements.txt


FROM python:3.9.23-alpine3.22
WORKDIR /opt/server
# Runtime dependencies only
RUN apk add --no-cache pcre

RUN addgroup -S roboshop && \
    adduser -S -D -H -h /opt/server -s /sbin/nologin -G roboshop roboshop




USER roboshop
COPY --from=builder /install /usr/local

COPY *.py .
COPY payment.ini .
CMD ["uwsgi", "--ini", "payment.ini"]













# basic method

# FROM python:3.9
# RUN groupadd -r roboshop && \
#     useradd -r -g roboshop -d /opt/server -s /usr/sbin/nologin roboshop
# WORKDIR /opt/server
# COPY requirements.txt .
# COPY *.py .
# COPY payment.ini .
# RUN pip3 install -r requirements.txt
# ENV CART_HOST="cart" \
#     CART_PORT="8080" \
#     USER_HOST="user" \
#     USER_PORT="8080" \
#     AMQP_HOST="rabbitmq" \
#     AMQP_USER="roboshop" \
#     AMQP_PASS="roboshop123"

# USER roboshop
# CMD ["uwsgi", "--ini", "payment.ini"]