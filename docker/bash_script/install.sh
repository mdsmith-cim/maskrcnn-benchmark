#!/bin/bash

START_DIR=$(pwd)

apt-get update -y
apt-get install -y nano htop wget cifs-utils tmux libxrender-dev git build-essential libsm6 tree openssh-server libglib2.0-0 libsm6 libxext6 tree iotop g++ cmake curl ca-certificates bzip2 apt-utils

wget https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh -O ~/anaconda3.sh \
 && bash ~/anaconda3.sh -b -p /anaconda3 \
 && rm ~/anaconda3.sh

export PATH=/anaconda3/bin:$PATH

pip install requests ninja yacs cython matplotlib opencv-python tqdm

conda install pytorch-nightly -c pytorch -y

cd ~

git clone https://github.com/pytorch/vision.git \
 && cd vision \
 && python setup.py install \
 && cd ~

git clone https://github.com/cocodataset/cocoapi.git \
 && cd cocoapi/PythonAPI \
 && python setup.py build_ext install \
 && cd ~

git clone https://github.com/NVIDIA/apex.git \
 && cd apex \
 && python setup.py install --cuda_ext --cpp_ext \
 && cd ~

cd $START_DIR

cp fstab /etc/fstab
mkdir ~/.ssh
cp docker_ssh.pub ~/.ssh/authorized_keys

mkdir /APL
mkdir /var/run/sshd

conda init

echo "Please restart the docker to use Anaconda"

# Meant to be used with
# docker create --name maskrcnn-devel-mike --runtime=nvidia --mount type=bind,source=/usr/local/data/msmith,target=/usr/local/data/msmith --mount type=bind,source=/home/vision/msmith,target=/home/vision/msmith --mount type=bind,source=/usr/local/data2/msmith,target=/usr/local/data2/msmith --privileged --ipc=host -p 8850:8850 -p 16722:22 -it nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04 bash