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
VALIDATE_UPDATE_PARAM="+app_update 581330 validate"

# Should we skip update and validate the installation
if [ -n "$SKIP_UPDATE_VALIDATION" ]; then
  VALIDATE_UPDATE_PARAM=
fi

# Update and validate game server installation
bash "$STEAM_CMD" \
  +login anonymous \
  +force_install_dir "$BASE_DIR" \
  "$VALIDATE_UPDATE_PARAM" \
  +quit

# Ensure config folder exists
mkdir -p "$SERVER_CONFIG_DIR" "$LINUX_SERVER_CONFIG_DIR"

# Make game server executable
chmod +x "$SERVER_EXECUTABLE"

# build server start command
CMD=

if [ -n "$GAME_STATS_TOKEN" ]; then
  CMD="${CMD} -GameStats -GameStatsToken=${GAME_STATS_TOKEN}"
  echo "🧮 GameStats Token was successfully configured"
fi

if [ -n "$GSLT_TOKEN" ]; then
  CMD="${CMD} -GSLTToken=${GSLT_TOKEN}"
  echo "💼 GSLTToken was successfully configured"
fi

if [ -n "$ADMINS" ]; then
  echo "$ADMINS" | sed -e $'s/,/\\\n/g' >"$SERVER_CONFIG_DIR/Admins.txt"
  admin_count=$(wc -l <"$SERVER_CONFIG_DIR/Admins.txt")
  echo "👷 $admin_count admins configured successfully"
fi

if [ -n "$MESSAGE_OF_THE_DAY" ]; then
  echo "$MESSAGE_OF_THE_DAY" >"$SERVER_CONFIG_DIR/Motd.txt"
  echo "📨️ Message of the day is: $MESSAGE_OF_THE_DAY"
fi

if [ -n "$MAP_CYCLE" ]; then
  CMD="${CMD} -MapCycle=MapCycle"
  echo "$MAP_CYCLE" >"$SERVER_CONFIG_DIR/MapCycle.txt"
  maps_count=$(wc -l <"$SERVER_CONFIG_DIR/MapCycle.txt")
  echo "🗺️️ MapCycle is configured with: ${maps_count} maps"
fi

# Configure mods
if [ -n "$ENABLE_MODS" ]; then
  CMD="${CMD} -Mods"
  echo "🔥 Mods enabled"

  if [ -n "$MODS" ]; then
    CMD="${CMD} -CmdModList=${MODS}"
    mod_list=$(echo "$MODS" | sed -e $'s/,/\\\n - /g')
    echo "🔥 Installed mods: \n - $mod_list"
  fi

  if [ -n "$MOD_DOWNLOAD_TRAVEL_TO" ]; then
    CMD="${CMD} -ModDownloadTravelTo=${MOD_DOWNLOAD_TRAVEL_TO}"
    echo "🧳 Mod Travel to map: $MOD_DOWNLOAD_TRAVEL_TO"
  fi
fi

if [ -n "$MOD_IO_TOKEN" ]; then
  cat <<EOF >>"$LINUX_SERVER_CONFIG_DIR/Engine.ini"

[/Script/ModKit.ModIOClient]
bHasUserAcceptedTerms=True
bCachedUserDetails=True
AccessToken="$MOD_IO_TOKEN"

EOF
  echo "🔑 ModIO integration activated"
fi

if [ -n "$MUTATORS" ]; then
  CMD="${CMD} -mutators=${MUTATORS}"
  mutator_list=$(echo "$MUTATORS" | sed -e $'s/,/\\n - /g')
  echo "✨️ Installed mutators: \n - $mutator_list"
fi

if [ -n "$GAME_INI" ]; then
  echo "" >>"$LINUX_SERVER_CONFIG_DIR/Game.ini"
  echo "$GAME_INI" >>"$LINUX_SERVER_CONFIG_DIR/Game.ini"
fi

if [ -n "$ENGINE_INI" ]; then
  echo "" >>"$LINUX_SERVER_CONFIG_DIR/Engine.ini"
  echo "$ENGINE_INI" >>"$LINUX_SERVER_CONFIG_DIR/Engine.ini"
fi

game_ini_count=$(wc -l <"$LINUX_SERVER_CONFIG_DIR/Game.ini")
engine_ini_count=$(wc -l <"$LINUX_SERVER_CONFIG_DIR/Engine.ini")
echo "📋️ There are $game_ini_count lines of Game.ini configuration"
echo "📋️ There are $engine_ini_count lines of Engine.ini configuration"

if [ -n "$DEBUG" ]; then
  echo " # $LINUX_SERVER_CONFIG_DIR/Engine.ini"
  cat "$LINUX_SERVER_CONFIG_DIR/Engine.ini"
  echo ""

  echo " # $LINUX_SERVER_CONFIG_DIR/Game.ini"
  cat "$LINUX_SERVER_CONFIG_DIR/Game.ini"
  echo ""

  echo " # $SERVER_CONFIG_DIR/MapCycle.txt"
  cat "$SERVER_CONFIG_DIR/MapCycle.txt"
  echo ""

  echo " # $SERVER_CONFIG_DIR/Admins.txt"
  cat "$SERVER_CONFIG_DIR/Admins.txt"
  echo ""
fi

echo "\n🔫🔫🔫 Starting the Insurgency: Sandstorm game server 🔫🔫🔫\n"

# Start the sandstorm server executable
"${SERVER_EXECUTABLE}" "${START_MAP}"?Scenario="${SCENARIO}"?MaxPlayers="${MAX_PLAYERS}" \
  -hostname="${SERVER_NAME}" -Port=27102 -QueryPort=27131 -log \
  ${CMD}
