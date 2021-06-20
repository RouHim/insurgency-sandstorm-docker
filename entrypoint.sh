#!/bin/sh
#
# This shell script is the entrypoint of the 'rouhim/insurgency-sandstorm-server' docker image.
#
# It does the following:
#   1. Update and validate the game server
#   2. Configure the server
#   3. Starts the actual sandstorm server
#
######################

# Update and validate game server installation
steamcmd +login anonymous +force_install_dir /sandstorm +app_update 581330 +quit

CMD=""

if [ -n "$GAME_STATS_TOKEN" ]; then
  CMD="$CMD -GameStats -GameStatsToken=$GAME_STATS_TOKEN"
fi

if [ -n "$GSLT_TOKEN" ]; then
  CMD="$CMD -GSLTToken=$GSLT_TOKEN"
fi

# Configure mods
if [ -n "$ENABLE_MODS" ]; then
  CMD="$CMD -Mods"

  if [ -n "$MODS" ]; then
    CMD="$CMD -CmdModList=$MODS"
  fi

  if [ -n "$MOD_IO_TOKEN" ]; then
    cat <<EOF >/sandstorm/Insurgency/Saved/Config/LinuxServer/Engine.ini
[/Script/ModKit.ModIOClient]
bHasUserAcceptedTerms=True
AccessToken=$MOD_IO_TOKEN
EOF
  fi

  if [ -n "$MOD_DOWNLOAD_TRAVEL_TO" ]; then
    CMD="$CMD -ModDownloadTravelTo=$MOD_DOWNLOAD_TRAVEL_TO"
  fi
fi

if [ -n "$MUTATORS" ]; then
  CMD="$CMD -mutators=$MUTATORS"
fi

# Start the sandstorm server executable
/sandstorm/Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
  "$START_MAP?Scenario=$SCENARIO?MaxPlayers=$MAX_PLAYERS" \
  -hostname="$SERVER_NAME" \
  -Port=27102 \
  -QueryPort=27131 \
  -MapCycle=MapCycle \
  -log \
  "$CMD"
