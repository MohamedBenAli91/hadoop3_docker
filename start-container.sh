#!/bin/bash

sudo docker network create --driver=bridge hadoop

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
		-p 7077:7077 \
		-p 16010:16010 \
      		-p 8888:8888 \
		-p 3306:3306 \
		-p 50030:50030 \
		-v /home/storage_lin/data_tweets_collection:/home/storage_lin/data_tweets_collection \
                --name hadoop-master \
                --hostname hadoop-master \
                cluster_big-data:latest &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	port=$(( 8040 + $i ))
	sudo docker run -itd \
			-p $port:8042 \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                cluster_big-data:latest &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
