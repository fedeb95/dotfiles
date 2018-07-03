#!/bin/bash
lum=$(xbacklight -get)
point100=${lum:3:1}
if [[ "$point100" == "." ]];
then xbacklight -set 95
else(
	point=${lum:1:1}
	if [[ "$point" == "." ]];
	then(
		lum=${lum::1}
		if [[ "$lum" -gt "9" ]];
		then let "lum -= 9"
		xbacklight -set $lum
		else zenity --error --title="Errore" --text="La luminosità è al minimo"
		fi
	)
	else(
		lum=${lum::2}
		let "lum -= 9"
		xbacklight -set $lum
	) 
	fi
)
fi
xbacklight -get
