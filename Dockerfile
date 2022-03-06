FROM haproxy:2.3

COPY conf/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY ssl/server.pem /usr/local/etc/ssl/certs/server.pem