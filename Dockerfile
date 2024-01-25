FROM ghcr.io/bubylou/steamcmd:latest

LABEL org.opencontainers.image.authors="Nicholas Malcolm"
LABEL org.opencontainers.image.source="https://github.com/bubylou/palworld-docker"

ENV APP_ID=2394010 \
	APP_NAME=palworld \
	APP_DIR="/app/palworld" \
	CONFIG_DIR="/config/palworld" \
	DATA_DIR="/data/palworld"

RUN mkdir -p "$APP_DIR/Pal/Saved/Config" "$CONFIG_DIR" "$DATA_DIR" && \
	ln -s "$CONFIG_DIR" "$APP_DIR/Pal/Saved/Config/LinuxServer" && \
	ln -s "$DATA_DIR" "$APP_DIR/Pal/Saved/SaveGames"  && \
	steamcmd +force_install_dir "$APP_DIR" +login anonymous +app_update $APP_ID validate +quit

VOLUME [ "$APP_DIR", "$CONFIG_DIR", "$DATA_DIR" ]

ENV GAME_PORT=8211 \
	MAX_PLAYERS=32 \
	MULTITHREAD_ENABLE=true \
	PUBLIC_ENABLE=false \
	PUBLIC_IP= \
	PUBLIC_PORT= \
	SERVER_NAME="Palworld Server" \
	SERVER_DESC="Palworld Server" \
	ADMIN_PASSWORD=CHANGE_ME_PLEASE \
	SERVER_PASSWORD= \
	RCON_ENABLED=false \
	RCON_PORT=25575

EXPOSE $GAME_PORT/udp $RCON_PORT/tcp
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
