#!/bin/bash

set -e
set -x

sudo /bin/bash -c "
if [[ ! "$LANG"="en_US.UTF-8" ]]; then
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  locale-gen en_US.UTF-8
  dpkg-reconfigure locales
fi

apt-get update
apt-get upgrade -y
apt-get install -y xubuntu-desktop 
apt-get install -y git eclipse maven openjdk-6-jdk gnome-terminal firefox
"

echo 'mode: off' > ~/.xscreensaver
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

cd $HOME

if [[ ! -e X11RDP-o-Matic ]]; then
   git clone https://github.com/scarygliders/X11RDP-o-Matic.git
   cd X11RDP-o-Matic
   sudo ./X11rdp-o-matic.sh --justdoit
   echo xfce4-session >~/.xsession
   echo :color desert >  ~/.vimrc
fi

# import project into eclipse

cd /vagrant/samples/client/hbase

mvn -q clean install eclipse:eclipse

# import projects
echo "Downloading eclipse import util"
sudo wget -N -nv -P /usr/share/eclipse/dropins/ \
    https://github.com/snowch/test.myapp/raw/master/test.myapp_1.0.0.jar

if [ -e ${HOME}/workspace ]
then
  IMPORTS='' # importing fails if workspace already has imported projects 
else
  IMPORTS=$(find /vagrant/samples/ -type f -name .project)
fi

# import all the eclipse projects that were found
for item in ${IMPORTS[*]}; do

  IMPORT="$(dirname $item)/"

  # perform the import 
  eclipse -nosplash \
     -application test.myapp.App \
     -data ${HOME}/workspace \
     -import $IMPORT

  if [ $? != 0 ]
  then
    IMPORT_ERRORS="${IMPORT_ERRORS}\n${IMPORT}"
  fi
done

mvn -Declipse.workspace=${HOME}/workspace/ eclipse:configure-workspace


