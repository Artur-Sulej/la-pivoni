#!/bin/bash

# These steps only need to be done once.
echo "Preparing ui"
cd ui
mix deps.get
npm install --prefix assets

# Still in ui directory from the prior step.
# These steps need to be repeated when you change JS or CSS files.
npm install --prefix assets --production
npm run deploy --prefix assets
mix phx.digest

echo "Preparing firmware"
cd ../firmware

export MIX_TARGET=rpi2
# If you're using WiFi:
# export NERVES_NETWORK_SSID=your_wifi_name
# export NERVES_NETWORK_PSK=your_wifi_password

mix deps.get
mix firmware
mix firmware.burn --device image
