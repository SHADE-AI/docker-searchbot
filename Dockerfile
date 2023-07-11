FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel

# setup needed for some packages
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

# Apt installs
# Download the specified A4B469963BF863CC from keyserver.ubuntu.com and add it to the trusted keyring
# Download and update the PGP corresponding to the cuda apt source
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN apt-get update
RUN apt-get install -y   tar
RUN apt-get install -y   wget
RUN apt-get install -y   bzip2
RUN apt-get install -y   ca-certificates
RUN apt-get install -y   curl
RUN apt-get install -y   git
RUN apt-get install -y   build-essential
RUN apt-get install -y   clang-format-8
RUN apt-get install -y   cmake
RUN apt-get install -y   autoconf
RUN apt-get install -y   libtool
RUN apt-get install -y   pkg-config
RUN apt-get install -y   libgoogle-glog-dev
RUN apt-get install -y   protobuf-compiler
RUN apt-get install -y   llvm

# get the Diplomacy searchbot version iclr21
WORKDIR /
RUN git clone https://github.com/facebookresearch/diplomacy_searchbot.git
WORKDIR /diplomacy_searchbot
RUN git checkout iclr21

#patches to make the code run
COPY fp1p_agent.py /diplomacy_searchbot/fairdiplomacy/agents/fp1p_agent.py 
COPY searchbot.prototxt /diplomacy_searchbot/conf/common/agents/searchbot.prototxt
COPY __init__.py /diplomacy_searchbot/fairdiplomacy/agents/__init__.py
COPY run.py /diplomacy_searchbot/heyhi/run.py
COPY random_agent.py /diplomacy_searchbot/fairdiplomacy/agents/random_agent.py

# installing the needed packages
RUN conda install --yes torchvision cudatoolkit=11.0 -c pytorch
RUN conda install --yes pybind11 -c pytorch
RUN conda install --yes go protobuf


# use conda to do the installs of the packages it can do
COPY condareq.txt /root/
RUN conda install --yes --file /root/condareq.txt

# install the internal searchbot
RUN pip install -r ./requirements.txt
RUN pip install -e ./thirdparty/github/fairinternal/postman/nest/
RUN pip install -e ./thirdparty/github/fairinternal/postman/postman/
RUN make 
RUN mkdir /diplomacy_searchbot/experiments
RUN cp /diplomacy_searchbot/conf/c02_sup_train/sl_20200901.prototxt /diplomacy_searchbot/conf/c02_sup_train/sl.prototxt
RUN wget https://github.com/facebookresearch/diplomacy_searchbot/releases/download/1.0/blueprint.pt
RUN pip install -e . -vv

# for singularity we need the adhoc dir to be writeable so linked to /tmp
RUN ln -s /tmp /diplomacy_searchbot/experiments/adhoc
