FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV INSTALLDIR=/webui \
    DATA_DIR=/webui/data
WORKDIR $INSTALLDIR

# Install apt packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget git \
    libgl1 libglib2.0-0 \
    # necessary for extensions
    ffmpeg libglfw3-dev libgles2-mesa-dev pkg-config libcairo2 libcairo2-dev

COPY . .

RUN git submodule update --init --recursive

RUN pip install -U pip
RUN pip install -r requirements.txt

STOPSIGNAL SIGINT
# In order to pass variables along to Exec Form Bash, we need to copy them explicitly
ENTRYPOINT ["/bin/bash", "-c", "${INSTALLDIR}/entrypoint.sh \"$0\" \"$@\""]