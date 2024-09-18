#!/bin/bash

export DATA_DIR_PATH="$1"
export LOGS_DIR_PATH="$2"
export LOG_FILE_PATH="$3"

theport="$4"
thestartdir="$5"
howtoopen="$6"
thenameofhtmlfile="$7"
thetypetomonitor="$8"
thecurversion="$9"
thevisionid="${10}"

export PEM_DIR_PATH="${11}"
export TERRAFORM_DIR_PATH="${12}"
export VISION_FILE_PATH="${13}"
export logfilepathshort="${14}"
thevision_id="${15}"
export VIS1ION_FILE_PATH="${16}"
therqval1="${17}"
therqval2="${18}"
therqval3="${19}"
therqval4="${20}"
MonitorIP="${21}"

sudo rm -f $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sudo cp $thestartdir/pages/widgets2.html $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html

if [ "$therqval1" == "Y" ] ; then
	sed -i -e s~"THEPATH1"~"$therqval4"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
	sed -i -e s~"THEPATH3"~"/Output/Vision/$thevision_id/ONPREMVVB"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
	export rqval1_FILE_PATH="$therqval2"
	export rqval2_FILE_PATH="$therqval3"
fi
if [ "$therqval1" == "N" ] ; then
	sed -i -e s~"THEPATH1"~"Nothing To Do..."~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
	sed -i -e s~"THEPATH3"~"Nothing To Do..."~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
	export rqval1_FILE_PATH="$thestartdir/ntd"
	export rqval2_FILE_PATH="$thestartdir/ntd"
fi

sed -i -e s~"THECURRENT_VISION"~"$thevision_id"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sed -i -e s~"THECURRENTVISION"~"$thevisionid"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sed -i -e s~"THEPATH4"~"$logfilepathshort"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sed -i -e s~"THEPATH5"~"$LOG_FILE_PATH"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sed -i -e s~"THEMHEADER"~"$thetypetomonitor-$thenameofhtmlfile"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sed -i -e s~"THEGLOBALPATHOFFILES"~"/"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
sed -i -e s~"THECURRENTVERSIONOFSANATANIMPL"~"$thecurversion"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
if [ "$thetypetomonitor" == "MATSYA" ] ; then
	sed -i -e s~"THEIMAGETOSHOW"~"<img src=\"/images/matsya.png\" style=\"width: 32px; height: 32px;\" class=\"user-image\" alt=\"M.A.T.S.Y.A\" title=\"M.A.T.S.Y.A\">"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
fi
if [ "$thetypetomonitor" == "VAMANA" ] ; then
	sed -i -e s~"THEIMAGETOSHOW"~"<img src=\"/images/vamana.png\" style=\"width: 32px; height: 32px;\" class=\"user-image\" alt=\"V.A.M.A.N.A\" title=\"V.A.M.A.N.A\">"~g $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html
fi

sudo chmod 777 $thestartdir/$thetypetomonitor-$thenameofhtmlfile.html

python3 -m http.server $theport --cgi --directory $thestartdir &
sleep 2
$howtoopen "http://$MonitorIP:$theport/$thetypetomonitor-$thenameofhtmlfile.html" &

