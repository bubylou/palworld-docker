#!/bin/bash
set -e

if [[ -n $UPDATE_ON_START ]]; then
    steamcmd +force_install_dir "$APP_DIR" +login anonymous +app_update $APP_ID validate +quit
fi

SETTINGS_FILE="$CONFIG_DIR/PalWorldSettings.ini"
if [[ ! -f $SETTINGS_FILE ]]; then
    echo "No config found, creating default config"
    mkdir -p "$APP_DIR/Pal/Saved/Config/LinuxServer"
    cp $APP_DIR/DefaultPalWorldSettings.ini $SETTINGS_FILE

    if [[ -n $SERVER_NAME ]]; then
        sed -i "s/ServerName=\"Default Palworld Server\"/ServerName=\"$SERVER_NAME\"/g" $SETTINGS_FILE
    fi
    if [[ -n $SERVER_DESC ]]; then
        sed -i "s/ServerDescription=\"\"/ServerDescription=\"$SERVER_DESC\"/g" $SETTINGS_FILE
    fi
    if [[ -n $ADMIN_PASSWORD ]]; then
        sed -i "s/AdminPassword=\"\"/AdminPassword=\"$ADMIN_PASSWORD\"/g" $SETTINGS_FILE
    fi
    if [[ -n $SERVER_PASSWORD ]]; then
        sed -i "s/ServerPassword=\"\"/ServerPassword=\"$SERVER_PASSWORD\"/g" $SETTINGS_FILE
    fi
    if [[ -n $RCON_ENABLED ]] && [[ $RCON_ENABLED == "true" ]]; then
        sed -i "s/RCONEnabled=False/RCONEnabled=True/g" $SETTINGS_FILE
    fi
    if [[ -n $RCON_PORT ]]; then
        sed -i "s/RCONPort=25575/RCONPort=$RCON_PORT/g" $SETTINGS_FILE
    fi
fi

START_OPTIONS="port=$GAME_PORT players=$MAX_PLAYERS"
if [[ $MULTITHREAD_ENABLE == "true" ]]; then
    START_OPTIONS="$START_OPTIONS -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
fi

if [[ $PUBLIC_ENABLE == "true" ]]; then
    START_OPTIONS="$START_OPTIONS EpicApp=PalServer"
    if [[ -n $PUBLIC_IP ]]; then
        START_OPTIONS="$START_OPTIONS -publicip=$PUBLIC_IP"
    fi
    if [[ -n $PUBLIC_PORT ]]; then
        START_OPTIONS="$START_OPTIONS -publicport=$PUBLIC_PORT"
    fi
fi

echo "Starting PalWorld"
$APP_DIR/PalServer.sh "$START_OPTIONS"
