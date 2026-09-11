#!/bin/bash
set -e

USER_NAME=$(basename "$HHHOME")
USER_ID=$(stat -c '%u' "$HHHOME")
GROUP_ID=$(stat -c '%g' "$HHHOME")

EXISTING_GROUP=$(getent group "$GROUP_ID" | cut -d: -f1 || true)
if [ -n "$EXISTING_GROUP" ]; then
  groupmod -n "$USER_NAME" "$EXISTING_GROUP"
else
  groupadd -g "$GROUP_ID" "$USER_NAME"
fi

EXISTING_USER=$(getent passwd "$USER_ID" | cut -d: -f1 || true)
if [ -n "$EXISTING_USER" ]; then
  usermod -l "$USER_NAME" -g "$GROUP_ID" -d "/home/$USER_NAME" "$EXISTING_USER"
else
  useradd --shell /bin/bash --uid "$USER_ID" --gid "$GROUP_ID" "$USER_NAME"
fi

su "$USER_NAME" -c "/usr/bin/qgis"
