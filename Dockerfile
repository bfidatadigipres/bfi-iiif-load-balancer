FROM jc21/nginx-proxy-manager:2.8.0
LABEL maintainer="Daniel Grant <daniel.grant@digirati.com>"
LABEL org.opencontainers.image.source=https://github.com/bfidatadigipres/bfi-iiif-load-balancer

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir -p /etc/bfi/iiif-load-balancer

COPY docker/etc/bfi/iiif-load-balancer/server_proxy.conf /etc/bfi/iiif-load-balancer
COPY docker/usr/local/bin/entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
