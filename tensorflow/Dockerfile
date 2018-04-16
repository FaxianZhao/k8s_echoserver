FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

MAINTAINER lu.ye <lu.ye@qunar.com>

# Pick up some TF dependencies
COPY sources.list /etc/apt/sources.list
RUN rm /etc/apt/sources.list.d/cuda.list
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        libxslt1-dev \
        libffi-dev \
        libevent-dev \
        python-gpgme \
        libattr1-dev \
        liblzma-dev \
        libgpgme11-dev \
        automake \
        autoconf \
        libtool \
        subversion \
        libatlas3-base \
        vim \
	wget \
	git \
        gcc \
        openssh-client \
        language-pack-zh-han* \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# zh_CN
RUN echo "export LANG=zh_CN.UTF-8\nexport LANGUAGE=zh_CN" >> /root/.bashrc

# anaconda3
RUN mkdir /notebooks && \
    echo 'export PATH=/notebooks/anaconda3/bin:$PATH ' > /etc/profile && \
    curl ftp://l-qesaasftp.ops.cn2/pub/Anaconda3-5.0.1-Linux-x86_64.sh -o /Anaconda3.sh && \
    /bin/bash /Anaconda3.sh -b -p /notebooks/anaconda3 && \
    rm -rf /Anaconda3.sh && \
    /notebooks/anaconda3/bin/conda install -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ jupyter_contrib_nbextensions jupyter_nbextensions_configurator -y && \
    /notebooks/anaconda3/bin/conda install -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ nb_conda_kernels -y && \
    /notebooks/anaconda3/bin/conda create -n py27 python=2.7 ipykernel && \
    /notebooks/anaconda3/bin/conda create -n py36 python=3.6 ipykernel && \
    mv /notebooks /notebooks.bak

# cudnn 6
RUN curl https://owncloud.corp.qunar.com/index.php/s/nfVLAYKwXhVSgA3/download -o /cudnn.tar.gz && \
    tar -zxf /cudnn.tar.gz && \
    cp -P /cuda/include/cudnn.h /usr/local/cuda-8.0/include && \
    cp -P /cuda/lib64/libcudnn* /usr/local/cuda-8.0/lib64/ && \
    chmod a+r /usr/local/cuda-8.0/lib64/libcudnn* && \
    rm -rf /cudnn.tar.gz
    
# setup pip conf to repo
RUN mkdir /root/.pip
COPY pip.conf /root/.pip/

# --- ~ DO NOT EDIT OR DELETE BETWEEN THE LINES --- #

# RUN ln -s /usr/bin/python3 /usr/bin/python#

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
# COPY notebooks /notebooks
ENV PATH /notebooks/anaconda3/bin:$PATH

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh"]

