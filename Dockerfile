FROM nginx:1.19.7
LABEL maintainer="Daniel Grant <daniel.grant@digirati.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir -p /etc/nginx/bfi.org.uk \
    && mkdir -p /etc/nginx/sites-available \
    && mkdir -p /etc/nginx/sites-enabled

COPY configs/usr/local/bin/entrypoint.sh /usr/local/bin
COPY configs/etc/nginx/nginx.conf /etc/nginx
COPY configs/etc/nginx/bfi.org.uk/general.conf /etc/nginx/bfi.org.uk
COPY configs/etc/nginx/bfi.org.uk/proxy.conf /etc/nginx/bfi.org.uk
COPY configs/etc/nginx/bfi.org.uk/security.conf /etc/nginx/bfi.org.uk

# bfinationalarchiveviewer-dev.bfi.org.uk
COPY configs/etc/nginx/sites-available/bfinationalarchiveviewer-dev.bfi.org.uk.conf /etc/nginx/sites-available
RUN  ln -s /etc/nginx/sites-available/bfinationalarchiveviewer-dev.bfi.org.uk.conf /etc/nginx/sites-enabled

# bfinationalarchiveviewer.bfi.org.uk
COPY configs/etc/nginx/sites-available/bfinationalarchiveviewer.bfi.org.uk.conf /etc/nginx/sites-available
RUN  ln -s /etc/nginx/sites-available/bfinationalarchiveviewer.bfi.org.uk.conf /etc/nginx/sites-enabled

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
