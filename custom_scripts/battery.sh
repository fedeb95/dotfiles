upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage" | awk '/perc/{print $2}'
