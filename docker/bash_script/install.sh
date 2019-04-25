#!/bin/bash

apt-get update -y
apt-get install -y nano htop wget cifs-utils tmux libxrender-dev git build-essential libsm6 tree

wget https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh -O ~/anaconda3.sh \
 && bash ~/anaconda3.sh -b -p /anaconda3 \
 && rm ~/anaconda3.sh

export PATH=/anaconda3/bin:$PATH

pip install numpy torchvision_nightly \
 && pip install torch_nightly -f https://download.pytorch.org/whl/nightly/cu100/torch_nightly.html \
 && pip install yacs matplotlib opencv-python

cd ~

git clone https://github.com/cocodataset/cocoapi.git \
 && cd cocoapi/PythonAPI \
 && python setup.py build_ext install \
 && cd ~

git clone https://github.com/ptrblck/apex.git \
 && cd apex \
 && git checkout scalar_type \
 && python setup.py install --cuda_ext --cpp_ext \
 && cd ~

echo "//apl/APL         /APL    cifs    rw,user,username=msmith,noauto,vers=3.02        0       0" >> /etc/fstab

mkdir /APL

conda init

echo "Please restart the docker to use Anaconda"