# Reverse Proxy

NGINX as Reverse Proxy with TLS termination

This guide make use of:
- HAProxy
- Nginx
- Podman
- openssl

## 1. Container network with dnsname plugin (enabled for new networks)
```sh
sudo podman network create mynet
sudo podman network ls
```

## 2. Container for a Sample Web Site
```sh
sudo podman run --name website \
--network mynet \
-p 8080:8080 \
-d gcr.io/google-samples/hello-app:1.0
```

## 3. Test the Sample Web Site
```sh
curl http://localhost:8080
```

## 4. Generate self-signed certificate for Reverse Proxy
```sh
mkdir ssl && cd ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-subj '/CN=localhost/O=it/C=EC' -keyout server.key -out server.crt
cat server.key server.crt > server.pem
```

## 5. Build and Tag Docker Image for Reverse Proxy (Review `Dockerfile`)

```sh
cd ..
sudo podman build -t haproxy-reverse-proxy .
```

## 6. Container for Reverse Proxy

```sh
sudo podman run --name haproxy-reverse-proxy \
--network mynet \
-p 9080:8080 \
-p 9090:9090 \
-d haproxy-reverse-proxy
```

## Test Reverse Proxy with TLS
```sh
curl -k https://localhost:9443/website
```