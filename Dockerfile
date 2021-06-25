####################
#   Build Image    #
####################
FROM cm2network/steamcmd:root
MAINTAINER Rouven Himmelstein rouvenhimmelstein@gmail.com

ENV STEAM_CMD "${STEAMCMDDIR}/steamcmd.sh"
ENV BASE_DIR "${HOMEDIR}/sandstorm"

ENV SERVER_CONFIG_DIR="${BASE_DIR}/Insurgency/Config/Server"
ENV LINUX_SERVER_CONFIG_DIR="${BASE_DIR}/Insurgency/Saved/Config/LinuxServer"
ENV SERVER_EXECUTABLE="${BASE_DIR}/Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping"
ENV MODS_DIR="${BASE_DIR}/Insurgency/Mods"

# Inistall prerequisites
RUN apt update && \
    apt install -y xdg-user-dirs && \
    apt-get autoremove

# Do not use root user
USER steam

# Pre-install server
RUN bash "$STEAM_CMD" \
      +login anonymous \
      +force_install_dir "$BASE_DIR" \
      +app_update 581330 validate \
      +quit

# expose game and query port
EXPOSE 27102/tcp \
       27102/udp \
       27131/tcp \
       27131/udp

# Specify entrypoint
COPY entrypoint.sh /
ENTRYPOINT /entrypoint.sh
