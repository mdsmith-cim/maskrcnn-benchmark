ARG CUDA="10.0"
ARG CUDNN="7"

FROM pytorch/pytorch:nightly-devel-cuda${CUDA}-cudnn${CUDNN}

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install basics
RUN apt-get update -y \
 && apt-get install -y apt-utils git curl ca-certificates bzip2 cmake tree htop bmon iotop g++ cifs-utils \
 && apt-get install -y libglib2.0-0 libsm6 libxext6 libxrender-dev openssh-server tmux

# Create a Python 3.6 environment
RUN conda install -y conda-build \
 && conda create -y --name py36 python=3.6 \
 && conda clean -ya

ENV CONDA_DEFAULT_ENV=py36
ENV CONDA_PREFIX=/opt/conda/envs/$CONDA_DEFAULT_ENV
ENV PATH=$CONDA_PREFIX/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA=false

RUN conda install -y ipython
RUN pip install ninja yacs cython matplotlib opencv-python tqdm

# Install PyTorch 1.0 Nightly
#ARG CUDA
#RUN conda install pytorch-nightly cudatoolkit=${CUDA} -c pytorch \
 #&& conda clean -ya

# Install TorchVision master
RUN git clone https://github.com/pytorch/vision.git \
 && cd vision \
 && python setup.py install

# install pycocotools
RUN git clone https://github.com/cocodataset/cocoapi.git \
 && cd cocoapi/PythonAPI \
 && python setup.py build_ext install

# install apex
RUN git clone https://github.com/NVIDIA/apex.git \
 && cd apex \
 && python setup.py install --cuda_ext --cpp_ext

COPY fstab /etc/fstab

COPY docker_ssh.pub /root/.ssh/authorized_keys

RUN service ssh start

RUN mkdir /APL

ARG FORCE_CUDA="1"
ENV FORCE_CUDA=${FORCE_CUDA}

WORKDIR /maskrcnn-benchmark

# Run SSH server for dev work
CMD ["/usr/sbin/sshd", "-D"]

## install PyTorch Detection
#RUN git clone https://github.com/facebookresearch/maskrcnn-benchmark.git \
# && cd maskrcnn-benchmark \
# && python setup.py build develop
#

