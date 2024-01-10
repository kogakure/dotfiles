#!/bin/bash

sketchybar --add item calendar right --set calendar \
	icon="􀧞" \
	update_frequency=30 \
	script="$PLUGIN_DIR/calendar.sh"
