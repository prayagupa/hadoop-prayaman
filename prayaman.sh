#!/bin/sh

#
# Users and Groups
# it is best to run the various daemons with separate accounts
#

# User which will own the HDFS services.
HDFS_USER=hdfs

# User which will own the YARN services.
YARN_USER=yarn

# User which will own the MapReduce services.
MAPRED_USER=mapred

# A common group shared by services.
HADOOP_GROUP=hadoop

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
echo "[info] Create hdfs user home dir"
echo "#######################################################################"
sudo mkdir -p /home/hdfs
sudo chmod -R 700 /home/hdfs
sudo chown -R hdfs:hadoop /home/hdfs
cat << EOF | sudo -u hdfs ssh-keygen



EOF
sudo -u hdfs sh -c "cat /home/hdfs/.ssh/id_rsa.pub >> /home/hdfs/.ssh/authorized_keys"


echo
echo "#######################################################################"
echo "[info] Create user yarn"
echo "#######################################################################"
sudo useradd -G $HADOOP_GROUP $YARN_USER
echo
echo "#######################################################################"
echo "Create yarn user home dir"
echo "#######################################################################"
sudo mkdir -p /home/yarn
sudo chmod -R 700 /home/yarn
sudo chown -R yarn:hadoop /home/yarn
cat << EOF | sudo -u yarn ssh-keygen



EOF
sudo -u yarn sh -c "cat /home/yarn/.ssh/id_rsa.pub >> /home/yarn/.ssh/authorized_keys"


echo
echo "#######################################################################"
echo "[info] Create user mapred"
echo "#######################################################################"
sudo useradd -G $HADOOP_GROUP $MAPRED_USER
echo
echo "#######################################################################"
echo "Create mapred user home dir"
echo "#######################################################################"
sudo mkdir -p /home/mapred
sudo chmod -R 700 /home/mapred
sudo chown -R mapred:hadoop /home/mapred
cat << EOF | sudo -u mapred ssh-keygen



EOF
sudo -u mapred sh -c "cat /home/mapred/.ssh/id_rsa.pub >> /home/mapred/.ssh/authorized_keys"
}

prayamanJava(){
 # set same java home for all users
 JAVA_HOME="$JAVA_HOME" # get java home from current user's environment
 echo "[info] : Setting Java Home:> $JAVA_HOME"
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
hdfs dfs -chown mapred:hadoop /user/log/history

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
   #sudo apt-get install -y build-essential
   #sudo apt-get install g++ autoconf automake
   cd $HADOOP_HOME/src
   echo
   echo "#######################################################################"
   echo "[INFO] Packaging hadoop source"
   echo "#######################################################################"
   #mvn package -Pdist,native -Dskiptests -Dtar
   mvn package -Dmaven.javadoc.skip=true -Pdist,native -DskipTests -Dtar
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

prayaman(){
	installHadoop
	prayamanJava
	prayamanUsers
	prayamanDirectories
	configureProtoc
	configureHadoopLib
	#configureHDFSdirs
	#configureHadoop
}

prayaman
