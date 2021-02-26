# BFI IIIF - Load Balancer

## Introduction

This repository introduces a load balancer appliance for use in BFI's
IIIF service deployments. This load balancer routes end user traffic to
one of multiple backend services using virtual host routing.

## Local Development

A Docker Compose manifest `docker-compose.dev.yml` is provided to
facilitate local development and testing of the load balancer.

## Secret Management

Various secrets (e.g. SSL certificates, private keys, etc) are stored in
this repository and are encrypted using
[git-secret](https://git-secret.io/). In order to decode these secrets,
an existing maintainer must add your GPG key to the keyring.
