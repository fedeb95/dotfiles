#!/bin/bash
lum=$(xbacklight -get)
point100=${lum:3:1}
err=0
if [[ "$point100" ==  "." ]];
then zenity --error --title="Errore" --text="La luminosità è al massimo"
else(	
	point=${lum:1:1}
	if [[ "$point" == "." ]];
	then(
		lum=${lum::1}
		if [[ "$lum" -lt "95" ]];
		then let "lum += 9"
		xbacklight -set $lum
		else zenity --error --title="Errore" --text="La luminosità è al massimo"; err=1
		fi
	)
	else(
		lum=${lum::2}
		let "lum += 9"
		xbacklight -set $lum
	) 
	fi
)
fi
xbacklight -get
