FROM nvidia/cuda:11.6.1-devel-ubuntu20.04

# Set the timezone to UTC
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV PYTORCH_VERSION=1.13.1
ENV CUDNN_VERSION=8.2.4.15-1+cuda11.6
ENV NCCL_VERSION=2.9.9-1+cuda11.6

ARG python=3.10
ENV PYTHON_VERSION=${python}

RUN apt update && apt install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
    software-properties-common \
    build-essential \
    cmake \
    git \
    curl \
    vim \
    wget \
    mpich \
    libmpich-dev 


RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-dev

RUN ln -s /usr/bin/python3.10 /usr/bin/python

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install mpi4py
RUN pip install \
    mpi4py==3.1.5 \
    numpy==1.26.4 \
    pyyaml==6.0.1 \
    mkl==2024.0.0 \
    mkl-include==2024.0.0 \
    setuptools==69.2.0 \
    cmake==3.28.4 \
    cffi==1.16.0 \
    typing==3.7.4.3 \
    typing-extensions==4.10.0 \
    blobfile==2.1.1 \
    pillow==10.2.0 \
    torchvision==0.14.1

# Clone and install PyTorch
RUN git clone --branch v${PYTORCH_VERSION} --recursive https://github.com/pytorch/pytorch  && \
    cd pytorch && \
    python setup.py install
