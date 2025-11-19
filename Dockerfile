# ==========================
# Stage 1: Build dependencies
# ==========================
FROM python:3.9.23-alpine3.22 AS builder
WORKDIR /build

# Install only necessary build deps
RUN apk add --no-cache python3-dev build-base linux-headers pcre-dev

COPY requirements.txt .

# Install Python packages into /install (not site-packages)
RUN pip3 install --no-cache-dir --prefix=/install -r requirements.txt


# ==========================
# Stage 2: Runtime Image
# ==========================
FROM python:3.9.23-alpine3.22

# Reduce image size & attack surface
RUN apk add --no-cache pcre && \
    rm -rf /var/cache/apk/* \
           /usr/lib/python3.9/site-packages/pip \
           /usr/lib/python3.9/site-packages/setuptools

WORKDIR /opt/server

# Create non-root user
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop

# Switch to non-root early
USER roboshop

# Copy python libs installed from builder stage
COPY --from=builder /install /usr/local

# Copy application files with ownership
COPY --chown=roboshop:roboshop *.py ./
COPY --chown=roboshop:roboshop payment.ini ./

EXPOSE 8080

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