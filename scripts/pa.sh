#!/bin/bash

#MIC="alsa_input.usb-Focusrite_Scarlett_2i2_USB-00.analog-stereo"
SPEAKERS="alsa_output.usb-Focusrite_Scarlett_2i2_USB-00.analog-stereo"

# Create the null sinks
# virtual1 gets your audio source (mplayer ...) only
# virtual2 gets virtual1 + micro
pactl load-module module-null-sink sink_name=sink1 sink_properties=device.description="Main"
pactl load-module module-null-sink sink_name=sink2 sink_properties=device.description="Voice"
pactl load-module module-null-sink sink_name=sink3 sink_properties=device.description="Music"

# Now create the loopback devices, all arguments are optional and can be configured with pavucontrol
pactl load-module module-loopback source=sink1.monitor sink=$SPEAKERS
pactl load-module module-loopback source=sink2.monitor sink=$SPEAKERS
pactl load-module module-loopback source=sink3.monitor sink=$SPEAKERS
