# beammp-docker

[![CI](https://github.com/RouHim/insurgency-sandstorm-docker/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/RouHim/insurgency-sandstorm-docker/actions/workflows/main.yml)
[![Docker Hub pulls](https://img.shields.io/docker/pulls/rouhim/insurgency-sandstorm-server.svg)](https://hub.docker.com/r/rouhim/insurgency-sandstorm-server)
[![Docker Hub size](https://img.shields.io/docker/image-size/rouhim/insurgency-sandstorm-server)](https://hub.docker.com/r/rouhim/insurgency-sandstorm-server)

This project provides a small, alpine based, docker container for
the [Insurgency: Sandstorm](https://www.insurgency-sandstorm.com/) game server and shows its usage in a docker-compose
environment.

## Motivation

Because there were no well-documented, alpine based Insurgency: Sandstorm docker images out there, I did one by myself.

## Usage

The sections below provides use cases for docker and docker-compose.

### docker

Quick start:

```bash
docker run --name isa-server -p 30814:30814/tcp -p 30814:30814/udp \
           -e NAME='My first awesome Server' \
           -e AUTH_KEY='<insert auth-key>' \
           rouhim/insurgency-sandstorm-server:latest
```

### docker-compose

Check `docker-compose.yml` if interested. The configuration should be done within the `.env` file.

To get started copy `.env.example` to `.env`.

```bash
cp .env.example .env
```

Adjust the values in the `.env` to your needs and run:

```bash
docker-compose pull && docker-compose up -d
```

## Environment parameter

Variable name   | description                                                                                   | default value
--------------- |---------------------------------------------------------------------------------------------- | -------- 
AUTH_KEY        | **
Mandatory!** The authentication key used by the server. It is used to identify your server and is not optional.| empty
DEBUG           | Set to true to enable debug output in the console                                             | false
PRIVATE         | Set to true if you don't want to show up in the Server Browser                                | true
CARS            | How many vehicles a player is allowed to have at the same time                                | 1
MAX_PLAYER      | How many players your server can hold at a time                                               | 10
MAP             | What the server map is                                                                        | /levels/gridmap/info.json
NAME            | What your server is called. This shows up in the Server Browser                               | BeamMP New Server
DESC            | What shows under the name when you click on the server                                        | BeamMP Default Description

A new AUTH_KEY can be claimed on their [discord server](https://beammp.com/k/dashboard). The key creation is done by
using a discord plugin and requires not much effort. Each key is IP-bound so there can be only one key per IP.

## Enable Stats
1. Visit the [GameStats Token Generator](https://gamestats.sandstorm.game/) and authenticate through your Stream profile.
2. Click on "Generate Token" which will create you a GameStats token.
3. Place the generated token in the `.env` file

## Game mods

In the first place you should consider
reading [the official mods guide](https://wiki.beammp.com/en/home/server-installation#how-to-add-mods-to-your-server).

> The folder `mods` is created automatically during the first startup,
> but can also be created manually beforehand.

### Vehicle mods:

Just copy the downloaded zip file into the `mods` folder.

### Custom maps:

Copy the downloaded zip file into the `mods` folder.

Now we have to find out the custom map path name (e.g.: `/levels/car_jump_arena/info.json`), to set it later in the as
map to load.

To do so:

1. Execute the shell command below, or open the zip file manually.
2. Copy the absolute path to the `info.json` location (`/levels/{map-name}/info.json`).
3. Set in .env file: `MAP=/levels/{map-name}/info.json`. Example: `MAP=/levels/car_jump_arena/info.json`

A simple way to print the full map path including info.json (_unzip_, _grep_ and _awk_ is required):

```shell
unzip -l PATH/TO/MAP.zip \
  | grep 'levels/.*/info.json' \
  | awk '{split($0,a," "); print "/"a[4]}'
```

## Used materials

- Insurgency: Sandstorm dedicated server guide: https://sandstorm-support.newworldinteractive.com/hc/en-us/articles/360049211072-Server-Admin-Guide
- SteamCMD Guide: https://developer.valvesoftware.com/wiki/SteamCMD
- Inspired by: https://github.com/AndrewMarchukov/insurgency-sandstorm-server-dockerize
- Built from: https://github.com/RouHim/insurgency-sandstorm-docker
