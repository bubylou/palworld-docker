# PalWorld-Docker

This is a Docker container used to run your own Palworld multi-player game server.

## Environment-Variables

### Start Up Options

These settings change how the game server behaves on on start.

| Variable           | Description                                                 | Default Values  | Allowed Values |
|--------------------|-------------------------------------------------------------|-----------------|----------------|
| UPDATE_ON_START    | Update the game server files on container start.            | true            | true/false     |
| ENABLE_MULTITHREAD | Improves performance on multi-threaded CPU environments.    | true            | true/false     |
| MAX_PLAYERS        | Maximum number of players permitted on the server.          | 32              | 1-32           |
| GAME_PORT          | Port number the game server listens on.                     | 8211            | 1024-65535     |
| PUBLIC_ENABLE      | Setup as a community server and will be discoverable.       | false           | true/false     |
| PUBLIC_IP          | If not specified, it will be detected automatically.        |                 | ip address     |
| PUBLIC_PORT        | If not specified, it will be detected automatically.        |                 | 1024-65535     |

### Server Settings

These variables modify some of the game configuration options.

| Variable           | Description                                                 | Default Values  | Allowed Values |
|--------------------|-------------------------------------------------------------|-----------------|----------------|
| SERVER_NAME        | Server name.                                                | Palworld Server | string         |
| SERVER_DESC        | Server description.                                         | Palworld Server | string         |
| SERVER_PASSWORD    | Server password required to connect to server.              |                 | string         |
| ADMIN_PASSWORD     | Password used for RCON.                                     |                 | string         |
| RCON_ENABLED       | Enable RCON for remote management.                          | false           | true/false     |
| RCON_PORT          | Port number for RCON.                                       | 25575           | 1024-65535     |

For other changes you can modify `/config/palworld/PalWorldSettings.ini`, please refer to https://tech.palworldgame.com/optimize-game-balance.

## Docker Run example

```yml
docker run -d \
    --name palworld \
    -p 8211:8211/udp \
    -v ./palworld:/data/palworld \
    -e SERVER_NAME="Palworld Server" \
    --restart unless-stopped \
    bubylou/palworld:latest
```

## Docker-Compose example

```yml
version: '3.9'
services:
  palworld:
    container_name: palworld
    image: bubylou/palworld:latest
    restart: unless-stopped
    environment:
      - UPDATE_ON_START=true
      - MULTITHREAD_ENABLE=true
      - MAX_PLAYERS=32
      - GAME_PORT=8211
      - PUBLIC_ENABLE=false
      - PUBLIC_IP=
      - PUBLIC_PORT=
      - SERVER_NAME="Palworld Server"
      - SERVER_DESC="Palworld Server"
      - SERVER_PASSWORD=
      - ADMIN_PASSWORD=CHANGE_ME_PLEASE
      - RCON_ENABLED=false
      - RCON_PORT=25575
    ports:
      - 8211:8211/udp
      - 27015:27015/tcp # required for RCON
    volumes:
      - ./palworld/app:/app/palworld # game server files
      - ./palworld/config:/config/palworld # palworld config files
      - ./palworld/data:/data/palworld # game/world save
```
