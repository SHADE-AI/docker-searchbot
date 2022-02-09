FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel
#FROM nvidia/cuda:11.4.0-cudnn8-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

# Apt installs
RUN apt-get update && apt-get install -y 
RUN apt-get install -y   tar 
RUN apt-get install -y   wget 
RUN apt-get install -y   bzip2 
RUN apt-get install -y   ca-certificates 
RUN apt-get install -y   curl 
RUN apt-get install -y   git 
RUN apt-get install -y   build-essential 
RUN apt-get install -y clang-format-8 
RUN apt-get install -y cmake 
RUN apt-get install -y autoconf 
RUN apt-get install -y libtool 
RUN apt-get install -y   pkg-config 
RUN apt-get install -y   libgoogle-glog-dev
RUN apt-get install -y protobuf-compiler
#RUN apt-get install -y llvm-11
RUN apt-get install -y llvm
RUN apt-get install -y hwinfo lsw
RUN apt-get install -y libomp-dev
ENV CUDA_PATH=/usr

# Install conda
#RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh -O miniconda.sh
#RUN mkdir -p /usr/local
#RUN chmod 755 /miniconda.sh 
#RUN /miniconda.sh -p /usr/local/miniconda3 -b
#RUN rm /miniconda.sh 
#ENV PATH=/usr/lib/llvm-11/bin:$PATH

WORKDIR /
RUN git clone https://github.com/facebookresearch/diplomacy_searchbot.git
WORKDIR /diplomacy_searchbot
RUN git checkout iclr21

COPY fp1p_agent.py /diplomacy_searchbot/fairdiplomacy/agents/fp1p_agent.py 
COPY searchbot.prototxt /diplomacy_searchbot/conf/common/agents/searchbot.prototxt
COPY __init__.py /diplomacy_searchbot/fairdiplomacy/agents/__init__.py
COPY run.py /diplomacy_searchbot/heyhi/run.py
COPY random_agent.py /diplomacy_searchbot/fairdiplomacy/agents/random_agent.py

# Create conda env
#RUN conda install --yes pytorch=1.7.1 torchvision cudatoolkit=11.0 -c pytorch
RUN conda install --yes torchvision cudatoolkit=11.0 -c pytorch
RUN conda install --yes pybind11 -c pytorch
RUN conda install --yes go protobuf



COPY condareq.txt /root/
RUN conda install --yes --file /root/condareq.txt

RUN pip install -r ./requirements.txt
RUN pip install -e ./thirdparty/github/fairinternal/postman/nest/
RUN pip install -e ./thirdparty/github/fairinternal/postman/postman/
RUN make 
RUN mkdir /diplomacy_searchbot/experiments
RUN cp /diplomacy_searchbot/conf/c02_sup_train/sl_20200901.prototxt /diplomacy_searchbot/conf/c02_sup_train/sl.prototxt
RUN wget https://github.com/facebookresearch/diplomacy_searchbot/releases/download/1.0/blueprint.pt
#RUN mv blueprint.pt /diplomacy_searchbot/blueprint.pt
RUN pip install -e . -vv
RUN mkdir /tmp/adhoc
RUN ln -s /tmp/adhoc /diplomacy_searchbot/experiments/adhoc
COPY run_parallel.py /diplomacy_searchbot
