BRIGHTNESS=`cat $HOME/custom_scripts/cur_bright`
if [ $BRIGHTNESS != "1.0" ]; then
    BRIGHTNESS=`echo "$BRIGHTNESS+0.1"|bc`;
    echo $BRIGHTNESS > $HOME/custom_scripts/cur_bright
    xrandr --output eDP-1 --brightness $BRIGHTNESS;
fi

    
