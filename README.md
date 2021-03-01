# BFI - IIIF Load Balancer

[![build](https://github.com/bfidatadigipres/bfi-iiif-load-balancer/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/bfidatadigipres/bfi-iiif-load-balancer/actions/workflows/build-and-push.yml)

This project introduces a load balancer appliance for use with BFI's
IIIF services.

The project is built using
[GitHub Actions](https://github.com/bfidatadigipres/bfi-iiif-load-balancer/actions),
and the produced containers are persisted in
[GitHub Container Registry](https://github.com/orgs/bfidatadigipres/packages/container/package/bfi-iiif-load-balancer).

## Getting Started

### Repository Layout

The repository is split into the following components:

- [`Dockerfile`](Dockerfile) and [`docker/`](docker/)
  - Using the NGINX Proxy Manager as the base image, this `Dockerfile`
    introduces a number of small but significant
    customisations.
  - Specifically, it provides an NGINX configuration
    file([`server_proxy.conf`](docker/etc/bfi/iiif-load-balancer/server_proxy.conf))
    which introduces BFI's IIIF root certificate authority (used for
    backend SSL validation), and an entrypoint script
    ([`entrypoint.sh`](docker/usr/local/bin/entrypoint.sh)) which moves
    both this NGINX configuration file, and the root CA (provided
    separately), into the correct places on the running containers
    mounted data volume.
- [`ssl`](ssl/)
  - Contains all SSL / TLS related assets, including:
    - BFI's IIIF root certificate authority, certificate and serial
      file.
    - Certificate signing requests, keys and certificates for backend
      services for which the load balancer proxies requests.
- [`deploy`](deploy/`)
  - Contains the folder structure and configuration files required to
    deploy the load balancer. Specifically:
    - [`etc/opt/bfi/iiif-load-balancer`](deploy/etc/opt/bfi/iiif-load-balancer):
      contains configuration files and assets used by the load balancer.
    - [`etc/systemd/system/iiif-load-balancer.service`](deploy/etc/systemd/system/iiif-load-balancer.service):
      the systemd unit used for starting and stopping the underlying
      NGINX Proxy Manager instance.
    - [`opt/bfi/iiif-load-balancer`](deploy/opt/bfi/iiif-load-balancer):
      the Docker Compose manifest, defining the load balancer
      application, dependencies and relationships therein.
    - [`var/opt/bfi/iiif-load-balancer/mounts`](deploy/opt/bfi/iiif-load-balancer/mounts):
      directory where the various mounted volumes used by the containers
      are located.

### Secrets Management

All secrets checked in as part of the repository have been encrypted
using [git-secret.io](https://git-secret.io/). This includes the
contents of the [`ssl`](ssl/) directory, which contains various SSL /
TLS related certificates and keys.

Existing users who already exist in the keyring can decrypt secrets with
the following command:

```bash
git secret reveal
```

To decrypt secrets, you must first be added to the keyring by an
existing user (assuming a key for `some.user@example.com` already
exists in your local GPG keyring):

```bash
git secret reveal
git secret tell some.user@example.com
git secret hide
```

New secrets can be added with the following commands:

```bash
git secret add path/to/my/secret.txt
git secret hide
```

### Building

The [`Dockerfile`](Dockerfile) can be built by executing:

```bash
docker build -t bfi-iiif-load-balancer .
```

## Local Development

A Docker Component manifest
[`docker-compose.dev.yml`](docker-compose.dev.yml) is provided for
facilitate local development.

This manifest requires that the secret
[`ssl/bfi-iiif-root-ca.crt`](ssl/bfi-iiif-root-ca.crt) is available
(i.e. has been decrypted), as it is made available to the running
container as a Docker Compose secret.

```bash
git secret reveal
docker-compose -f docker-compose.dev.yml up --remove-orphans
```

The manifest additionally deploys two instances of
[`karthequian/helloworld`](https://hub.docker.com/r/karthequian/helloworld),
which can be used as test proxy targets.

##  Versioning

We use SemVer for versioning. For the versions available, see the [tags
on this repository](https://github.com/bfidatadigipres/bfi-iiif-load-balancer/tags).

##  License

This project is licensed under the MIT License - see the
[`LICENSE`](LICENSE) file for details
