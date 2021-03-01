FROM jc21/nginx-proxy-manager:2.8.0
LABEL maintainer="Daniel Grant <daniel.grant@digirati.com>"
LABEL org.opencontainers.image.source=https://github.com/bfidatadigipres/bfi-iiif-load-balancer

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir -p /usr/lib/bfi

COPY configs/usr/local/bin/entrypoint.sh /usr/local/bin
COPY configs/usr/lib/bfi/server_proxy.conf /usr/lib/bfi

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
