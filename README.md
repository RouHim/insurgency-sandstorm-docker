# Insurgency: Sandstorm docker server

![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/RouHim/insurgency-sandstorm-docker/CI/master?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/rouhim/insurgency-sandstorm-server?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/rouhim/insurgency-sandstorm-server/latest?style=for-the-badge)

This project provides a Docker container for the [Insurgency: Sandstorm](https://www.insurgency-sandstorm.com/)
game server and demonstrates its use in a docker compose environment.

## Motivation

Since there were no well-documented, easy-to-use Insurgency: Sandstorm docker images, I created one myself.

## About the container

* Is built nightly
* Updates and validates the game data to start.

## Usage

I recommend using [docker compose](https://docs.docker.com/compose/).

### docker-compose

Check `docker-compose.yml` if you are interested. The configuration of the game server should be done in the `.env`
file.

To get started, copy `.env.example` to `.env`.

```bash
cp .env.example .env
```

Adjust the values in the `.env` to your needs and start:

```bash
docker-compose pull && docker-compose up -d
```

To delete the server with all persisted data and volumes (mods):

```bash
docker-compose down --volumes
```

## Configuration

Variable name           | description                                                                                   | default value
----------------------- |---------------------------------------------------------------------------------------------- | -------- 
SERVER_NAME             | The name of the server as it appears on the server browser (replacing My Server with the name of your choice) | empty
START_MAP               | The start map | empty
SCENARIO                | You may define an entry with an override game mode as some game modes can share scenarios. | empty
MAX_PLAYERS             | Maximum number of players that can join the server. On coop servers, this is only the number of human players. | empty
GSLT_TOKEN              | In order for your server to be able to authenticate with the stats server, see description below. | empty
GAME_STATS_TOKEN        | Any community server is capable of hosting a stats-enabled game. See description below. | empty
ADMINS                  | A comma separated list of 64-bit Steam IDs (aka steamID64) to be admin on the server. See Description below. | empty
MESSAGE_OF_THE_DAY      | The server message of the day | empty
SKIP_UPDATE_VALIDATION  | Set this to any value to skip installed steam game data update and validation | empty
ENABLE_MODS             | Set this to any value to enable mod integration | empty
MOD_IO_TOKEN            | To be able to communicate with mod.io. See description below | empty
MODS                    | Comma separated list of mod ids, e.g.: 150867,1337 | empty
MOD_DOWNLOAD_TRAVEL_TO  | Name of a mod map to change after mod download | empty
MUTATORS                | Comma separated list of mutators, e.g.: ISMC_Hardcore,AllYouCanEat | empty
GAME_INI                | Fill this value to with entries to be added to the Game.ini. See example in .env.example | empty
MAP_CYCLE               | Fill this value to with entries to be added to the GameCycle.txt See example in .env.ismc.example | empty

### Enable GameStats

1. Visit the [GameStats Token Generator](https://gamestats.sandstorm.game/) and authenticate through your Stream
   profile.
2. Click on "Generate Token" which will create you a GameStats token.
3. Place the generated token in the GAME_STATS_TOKEN variable of the `.env` file

### Enable Game Server Login Token

1. Visit the [Steam Game Server Account Management](https://steamcommunity.com/dev/managegameservers) and authenticate
   through your Stream profile.
2. Create a new game server account.
3. Place the generated token in the GSLT_TOKEN variable of the `.env` file

### Configure Admins

1. Visit the [STEAMID I/O](https://steamid.io/) and authenticate through your Stream profile.
2. Press lookup
3. Place the *steamID64*, comma separated, in the ADMINS variable of the `.env` file

### Enable mod.io integration

1. Visit the [mod.io](https://mod.io/) and authenticate through your Stream profile.
2. Click your username at the top right, and click `API Access` from the left navigation.
3. Under OAuth 2 Management, under Generate Access Token, enter a name to give your token and give it read access (write
   access is not needed) and click Create Token.
4. Place the generated token in the MOD_IO_TOKEN variable of the `.env` file

### Mods

If you want to use mods, you must set the following .env values:

```bash
ENABLE_MODS=true
MOD_IO_TOKEN=xxx
MODS=mod_id_1,mod_id_2,mod_id_3
MOD_DOWNLOAD_TRAVEL_TO=map_to_travel_to
MUTATORS=mutator_name_1,mutator_name_2
```

## Used materials

- Insurgency: Sandstorm dedicated server
  guide: https://sandstorm-support.newworldinteractive.com/hc/en-us/articles/360049211072-Server-Admin-Guide
- SteamCMD Wiki: https://developer.valvesoftware.com/wiki/SteamCMD
- ISMC Mod Guide: https://insurgencysandstorm.mod.io/guides/ismcmod-installation-guide
- Inspired by: https://github.com/AndrewMarchukov/insurgency-sandstorm-server-dockerize
- Built from: https://github.com/RouHim/insurgency-sandstorm-docker
