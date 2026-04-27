FROM lcr.loongnix.cn/library/debian:unstable

RUN apt update && apt install -y git \
    golang \
    make \
    libseccomp-dev

ENV PODMAN_VERSION=''

CMD ["sh", "-c","/workspace/process_version.sh $PODMAN_VERSION"]
