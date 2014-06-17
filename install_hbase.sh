#!/bin/bash

set -e
set -x

cd $HOME

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
apt-get install -y git openjdk-7-jdk
"


if [[ ! -e hbase-0.98.3-hadoop2 ]]; then
  sudo sed -i -e '/^127.0.1.1/d' /etc/hosts
  wget -N -c http://www.mirrorservice.org/sites/ftp.apache.org/hbase/hbase-0.98.3/hbase-0.98.3-hadoop2-bin.tar.gz
  tar xvzf hbase-0.98.3-hadoop2-bin.tar.gz
fi


function add_or_replace_line() {
  SEARCH=$1 
  REPLACE=$2 
  CFGFILE=$3

  grep -q "^$SEARCH" $CFGFILE && sed -i "s@^$SEARCH.*@$REPLACE@" $CFGFILE || echo "$REPLACE" >> $CFGFILE
}

add_or_replace_line \
   'export JAVA_HOME=' \
   'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/' \
   '/home/vagrant/.profile'

add_or_replace_line \
   'export HBASE_HOME=' \
   'export HBASE_HOME=/home/vagrant/hbase-0.98.3-hadoop2/' \
   '/home/vagrant/.profile'

add_or_replace_line \
   'export PATH=$PATH:$HBASE_HOME/bin' \
   'export PATH=$PATH:$HBASE_HOME/bin' \
   '/home/vagrant/.profile' \


source /home/vagrant/.profile

cat << EOF > $HBASE_HOME/conf/hbase-site.xml

EOF


# turn off abort on error as start-hbase.sh will
# return an error if hbase is already running
set +e

start-hbase.sh
