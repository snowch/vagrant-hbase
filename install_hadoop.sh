#!/bin/bash

# based on: http://bigdatahandler.com/hadoop-hdfs/installing-single-node-hadoop-2-2-0-on-ubuntu/

set -e
set -x

cd $HOME

if [[ ! -e hadoop-2.2.0.tar.gz ]]; then
  wget -N -c http://mirrors.ukfast.co.uk/sites/ftp.apache.org/hadoop/common/stable/hadoop-2.2.0.tar.gz
fi

# TODO - get confirmation before destroying

rm -rf $HOME/hadoop-2.2.0
tar xzf hadoop-2.2.0.tar.gz

sudo sed -i -e '/^127.0.1.1/d' /etc/hosts
sudo sed -i -e '/^127.0.0.1/d' /etc/hosts

function add_or_replace_line() {
  SEARCH=$1 
  REPLACE=$2 
  CFGFILE=$3

  grep -q "^$SEARCH" $CFGFILE && sudo sed -i "s@^$SEARCH.*@$REPLACE@" $CFGFILE || sudo sh -c "echo '$REPLACE' >> $CFGFILE"
}

# update profile

add_or_replace_line \
   'export JAVA_HOME=' \
   'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/' \
   '/home/vagrant/.profile'

cat << EOF > $HOME/.profile_hadoop
export HADOOP_PREFIX=/home/vagrant/hadoop-2.2.0
export HADOOP_HOME=/home/vagrant/hadoop-2.2.0
export HADOOP_MAPRED_HOME=\${HADOOP_HOME}
export HADOOP_COMMON_HOME=\${HADOOP_HOME}
export HADOOP_HDFS_HOME=\${HADOOP_HOME}
export YARN_HOME=\${HADOOP_HOME}
export HADOOP_CONF_DIR=\${HADOOP_HOME}/etc/hadoop
# Native Path
export HADOOP_COMMON_LIB_NATIVE_DIR=\${HADOOP_PREFIX}/lib/native
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_PREFIX/lib"
# Add Hadoop bin/ directory to PATH
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
EOF

# update /etc/hosts

add_or_replace_line \
   '192.168.50.4 trusty64 localhost' \
   '192.168.50.4 trusty64 localhost' \
   '/etc/hosts' \

# update profile

add_or_replace_line \
   'source $HOME/.profile_hadoop' \
   'source $HOME/.profile_hadoop' \
   '/home/vagrant/.profile' \

source /home/vagrant/.profile

# update sysctl

add_or_replace_line \
   'net.ipv6.conf.all.disable_ipv6' \
   'net.ipv6.conf.all.disable_ipv6 = 1' \
   '/etc/sysctl.conf'

add_or_replace_line \
   'net.ipv6.conf.default.disable_ipv6' \
   'net.ipv6.conf.default.disable_ipv6 = 1' \
   '/etc/sysctl.conf'

add_or_replace_line \
   'net.ipv6.conf.lo.disable_ipv6' \
   'net.ipv6.conf.lo.disable_ipv6 = 1' \
   '/etc/sysctl.conf'

sudo sysctl -p /etc/sysctl.conf

# update config files

cat << EOF > $HADOOP_HOME/etc/hadoop/yarn-site.xml
<configuration>
<!-- Site specific YARN configuration properties -->
<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>
<property>
<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
<value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>
</configuration>
EOF

cat << EOF > $HADOOP_HOME/etc/hadoop/core-site.xml
<configuration>
<property>
<name>fs.default.name</name>
<value>hdfs://trusty64:9000</value>
</property>
</configuration>
EOF

cat << EOF > $HADOOP_HOME/etc/hadoop/mapred-site.xml
<configuration>
<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>
</configuration>
EOF

cat << EOF > $HADOOP_HOME/etc/hadoop/hdfs-site.xml
<configuration>
<property>
<name>dfs.replication</name>
<value>1</value>
</property>
<property>
<name>dfs.namenode.name.dir</name>
<value>file:$HADOOP_HOME/yarn_data/hdfs/namenode</value>
</property>
<property>
<name>dfs.datanode.data.dir</name>
<value>file:$HADOOP_HOME/yarn_data/hdfs/datanode</value>
</property>
</configuration>
EOF

mkdir -p $HADOOP_HOME/yarn_data/hdfs/namenode
sudo mkdir -p $HADOOP_HOME/yarn_data/hdfs/namenode
mkdir -p $HADOOP_HOME/yarn_data/hdfs/datanode

# prepare namenode

hadoop namenode -format

# start services

hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager
mr-jobhistory-daemon.sh start historyserver

# create the home folder and make sure we can list the root folder

hadoop fs -mkdir -p $HOME

hadoop fs -ls /

