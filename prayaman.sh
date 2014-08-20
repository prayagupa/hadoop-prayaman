#!/bin/sh

#
# Users and Groups
# it is best to run the various daemons with separate accounts
#

# User which will own the HDFS services.
HDFS_USER=$USER ##CHANGEME

# User which will own the YARN services.
YARN_USER=$USER  ##CHANGEME

# User which will own the MapReduce services.
MAPRED_USER=$USER  ##CHANGEME

# A common group shared by services.
HADOOP_GROUP=$USER

installHadoop(){
 wget http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.3.0-cdh5.0.1.tar.gz
 tar -zxvf hadoop-2.3.0-cdh5.0.1.tar.gz
 sudo mv hadoop-2.3.0-cdh5.0.1 /usr/local/
 
 ##ADD HADOOP_HOME to ~/.bash_profile
}

hadoopConfig(){
  cp -R etc/hadoop/* $HADOOP_HOME/etc/hadoop/
}

prayamanUsers(){
# For Ubuntu
echo
echo "#######################################################################"
echo "[info] Create group hadoop"
echo "#######################################################################"
sudo groupadd $HADOOP_GROUP

echo
echo "#######################################################################"
echo "[info] Create user hdfs"
echo "#######################################################################"
sudo useradd -G $HADOOP_GROUP $HDFS_USER
echo
echo "#######################################################################"
echo "[info] Create $HDFS_USER user home dir"
echo "#######################################################################"
sudo mkdir -p $HOME/$HDFS_USER
sudo chmod -R 700 $HOME/$HDFS_USER
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HOME/$HDFS_USER
cat << EOF | sudo -u $HDFS_USER ssh-keygen

EOF
sudo -u $HDFS_USER sh -c "cat /home/$HDFS_USER/.ssh/id_rsa.pub >> /home/$HDFS_USER/.ssh/authorized_keys"


echo
echo "#######################################################################"
echo "[info] Create user $YARN_USER"
echo "#######################################################################"
sudo useradd -G $HADOOP_GROUP $YARN_USER
echo
echo "#######################################################################"
echo "Create $YARN_USER user home dir"
echo "#######################################################################"
sudo mkdir -p $HOME/$YARN_USER
sudo chmod -R 700 $HOME/$YARN_USER
sudo chown -R $YARN_USER:$HADOOP_GROUP $HOME/$YARN_USER
cat << EOF | sudo -u $YARN_USER ssh-keygen



EOF
sudo -u $YARN_USER sh -c "cat /home/$YARN_USER/.ssh/id_rsa.pub >> /home/$YARN_USER/.ssh/authorized_keys"


echo
echo "#######################################################################"
echo "[info] Create user $MAPRED_USER"
echo "#######################################################################"
sudo useradd -G $HADOOP_GROUP $MAPRED_USER
echo
echo "#######################################################################"
echo "Create mapred user home dir"
echo "#######################################################################"
sudo mkdir -p $HOME/$MAPRED_USER
sudo chmod -R 700 $HOME/$MAPRED_USER
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $HOME/$MAPRED_USER
cat << EOF | sudo -u $MAPRED_USER ssh-keygen



EOF
sudo -u $MAPRED_USER sh -c "cat $HOME/$MAPRED_USER/.ssh/id_rsa.pub >> $HOME/$MAPRED_USER/.ssh/authorized_keys"
}

prayamanJava(){
 # set same java home for all users
 JAVA_HOME="$JAVA_HOME" # get java home from current user's environment
 echo "[INFO] : Setting JAVA HOME to '> $JAVA_HOME '"
 sudo sh -c "echo export JAVA_HOME=$JAVA_HOME > /etc/profile.d/java.sh"
 #To make sure JAVA_HOME is defined for this session, source the new script:
 source /etc/profile.d/java.sh 
}

prayamanDirectories(){

#
# Directories Script
#


#
# Hadoop Service - HDFS
#

# Space separated list of directories where NameNode will store file system image.
# For example, /grid/hadoop/hdfs/nn /grid1/hadoop/hdfs/nn
DFS_NAME_DIR=/hadoop/hdfs/nn

# Space separated list of directories where DataNodes will store the blocks.
# For example, /grid/hadoop/hdfs/dn /grid1/hadoop/hdfs/dn
DFS_DATA_DIR=/hadoop/hdfs/dn

# Directory to store the HDFS logs.
HDFS_LOG_DIR=/var/log/hadoop/hdfs

# Directory to store the HDFS process ID.
HDFS_PID_DIR=/var/pid/hadoop/hdfs

#
# Hadoop Service - YARN 
#

# Space separated list of directories where YARN will store temporary data.
# For example, /grid/hadoop/yarn/local /grid1/hadoop/yarn/local
YARN_LOCAL_DIR=/hadoop/yarn/local

# Directory to store the YARN logs.
YARN_LOG_DIR=/var/log/hadoop/yarn

# Space separated list of directories where YARN will store container log data.
# For example, /grid/hadoop/yarn/logs /grid1/hadoop/yarn/logs
YARN_LOCAL_LOG_DIR=/hadoop/yarn/logs

# Directory to store the YARN process ID.
YARN_PID_DIR=/var/pid/hadoop/yarn

#
# Hadoop Service - MAPREDUCE
#

# Directory to store the MapReduce daemon logs.
MAPRED_LOG_DIR=/var/log/hadoop/mapred

# Directory to store the mapreduce jobhistory process ID.
MAPRED_PID_DIR=/var/pid/hadoop/mapred

echo
echo "#######################################################################"
echo "Create namenode dir"
echo "#######################################################################"
sudo mkdir -p $DFS_NAME_DIR
sudo chmod -R 755 $DFS_NAME_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR

echo
echo "#######################################################################"
echo "Create datanode dir"
echo "#######################################################################"
sudo mkdir -p $DFS_DATA_DIR
sudo chmod -R 755 $DFS_DATA_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR

echo
echo "#######################################################################"
echo "Create hdfs log dir"
echo "#######################################################################"
sudo mkdir -p $HDFS_LOG_DIR
sudo chmod -R 755 $HDFS_LOG_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR

echo
echo "#######################################################################"
echo "Create hdfs pid dir"
echo "#######################################################################"
sudo mkdir -p $HDFS_PID_DIR
sudo chmod -R 777 $HDFS_PID_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR

echo
echo "#######################################################################"
echo "Create yarn local dir"
echo "#######################################################################"
sudo mkdir -p $YARN_LOCAL_DIR
sudo chmod -R 755 $YARN_LOCAL_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_DIR

echo
echo "#######################################################################"
echo "Create yarn local log dir"
echo "#######################################################################"
sudo mkdir -p $YARN_LOCAL_LOG_DIR
sudo chmod -R 755 $YARN_LOCAL_LOG_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_LOG_DIR

echo
echo "#######################################################################"
echo "Create yarn log dir"
echo "#######################################################################"
sudo mkdir -p $YARN_LOG_DIR
sudo chmod -R 755 $YARN_LOG_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOG_DIR

echo
echo "#######################################################################"
echo "Create yarn pid dir"
echo "#######################################################################"
sudo mkdir -p $YARN_PID_DIR
sudo chmod -R 777 $YARN_PID_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR

echo
echo "#######################################################################"
echo "Create mapreduce log dir"
echo "#######################################################################"
sudo mkdir -p $MAPRED_LOG_DIR
sudo chmod -R 755 $MAPRED_LOG_DIR
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR

echo
echo "#######################################################################"
echo "Create mapreduce pid dir"
echo "#######################################################################"
echo
sudo mkdir -p $MAPRED_PID_DIR
sudo chmod -R 777 $MAPRED_PID_DIR
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR
}


configureProtoc(){
	sudo apt-get install -y gcc g++ make maven cmake zlib zlib1g-dev libcurl4-openssl-dev
     	curl -# -O https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz
	gunzip protobuf-2.5.0.tar.gz 
	tar -xvf protobuf-2.5.0.tar 
	cd protobuf-2.5.0
	./configure --prefix=/usr
	make
	sudo make install
}

configureHadoopLib(){
   echo
   echo "#######################################################################"
   echo "[INFO] installing required libraries"
   echo "#######################################################################"

   sudo apt-get install -y build-essential
   sudo apt-get install -y g++ autoconf automake
   sudo apt-get install -y zlib1g-dev cmake pkg-config libssl-dev
   sudo apt-get install -y zlib1g-dev
   sudo apt-get install -y libssl-dev
   cd $HADOOP_HOME/src
   echo
   echo "#######################################################################"
   echo "[INFO] Packaging hadoop source"
   echo "#######################################################################"
   #mvn package -Pdist,native -Dskiptests -Dtar
   mvn -e package -Dmaven.javadoc.skip=true -Pdist,native -DskipTests -Dtar
   echo
   echo "#######################################################################"
   echo "[INFO] Packaging hadoop source - completed"
   echo "#######################################################################"

   cp $HADOOP_HOME/src/hadoop-dist/target/hadoop-2.3.0-cdh5.0.1/lib/native/*  $HADOOP_HOME/lib/native/
   #cat ~/.bash_profile > export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
   #cat ~/.bash_profile > export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
}

configureHadoop(){
 cp -R ../hadoop-install/etc/hadoop/* $HADOOP_HOME/etc/hadoop/
}

configureHDFSdirs(){
echo
echo "#######################################################################"
echo "[info] create dir history"
echo "#######################################################################"
hdfs dfs -mkdir -p /user/log/history
## sudo -u hdfs hdfs dfs -mkdir -p /user/log/history       

echo
echo "#######################################################################"
echo "[info] set permission to hostory"
echo "#######################################################################"
## sudo -u hdfs hdfs dfs -chmod -R 1777 /user/log/history  
hdfs dfs -chmod -R 1777 /user/log/history

echo 
echo "#######################################################################"
echo "[info] set permission to history (for mapred) "
echo "#######################################################################"
## sudo -u hdfs hdfs dfs -chown mapred:hadoop /user/log/history 
hdfs dfs -chown $MAPRED_USER:$HADOOP_GROUP /user/log/history

echo
echo "#######################################################################"
echo "[info] create /tmp"
echo "#######################################################################"
## sudo -u hdfs hadoop fs -mkdir /tmp 
hadoop fs -mkdir /tmp
echo 
echo "#######################################################################"
echo "[info] set permission to /tmp"
echo "#######################################################################"
##sudo -u hdfs hadoop fs -chmod -R 1777 /tmp 
hadoop fs -chmod -R 1777 /tmp
}

startHadoop(){
#Start all hadoop daemons
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
$HADOOP_HOME/sbin/yarn-daemon.sh start proxyserver

#Show started daemons
#$JAVA_HOME/bin/jps
}

prayaman(){
	#installHadoop
	prayamanJava
	prayamanUsers
	#prayamanDirectories
	#configureProtoc
	#configureHadoopLib
	#configureHDFSdirs
	#configureHadoop
	startHadoop
}

prayaman
