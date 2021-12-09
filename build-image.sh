#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop & spark image\n"
sudo docker build -t cluster_big-data:latest .

echo ""
