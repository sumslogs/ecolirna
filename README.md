# Ecoli RNA Analysis

This repo contains misc. scripts to 

## Setup
Requirements are docker/docker-compose, and [just](https://just.systems/man/en/) to run command snippets.

Note: docker-compose uses either underscore or dash in creating scoped image names--so to insist it use underscores you need this in your environment:

```
export COMPOSE_COMPATIBILITY=true
```

## Overview

There are two containers defined here:
 - **base**/Dockerfile: Basic ubuntu + some helpers
 - **shapemapper**/Dockerfile: Extends base. Has all environment detail used to install RNAstructure and ShapeMapper.

To build the containers:
```
just devbuild base
just devbuild shapemapper
```

To run interactive shell:
```
just devcomponent shapemapper
```

See docker-compose.yml for local volume mapping, and run `just --list` to see other misc. helper commands available.

