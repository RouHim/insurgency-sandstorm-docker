####################
#   Build Image    #
####################
FROM steamcmd/steamcmd:alpine
MAINTAINER Rouven Himmelstein rouvenhimmelstein@gmail.com
ENV HOSTNAME=""

RUN steamcmd +login anonymous +force_install_dir /sandstorm +app_update 581330 validate +quit

# Specify entrypoint
COPY entrypoint.sh /
# expose game port
EXPOSE 27102/tcp 27102/udp
# expose query port
EXPOSE 27131/tcp 27131/udp
ENTRYPOINT /entrypoint.sh
