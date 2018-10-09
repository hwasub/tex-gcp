FROM alpine:3.8

ENV PATH /usr/local/texlive/2018/bin/x86_64-linuxmusl:/google-cloud-sdk/bin:$PATH
ENV CLOUD_SDK_VERSION 219.0.1

# get required packages
RUN apk add --no-cache cairo icu-libs libgcc libpaper libpng libstdc++ \
    libx11 musl pixman poppler zlib perl wget xz tar git ca-certificates \
    gzip curl python2 openssh-client py-crcmod && \
    update-ca-certificates

# get google cloud cli
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

# get TeX live
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar xfz install-tl-unx.tar.gz && \
    mv install-tl-20* inst && \
    cd inst && \
    echo "selected_scheme scheme-full" > profile && \
    ./install-tl -profile profile && \
    cd .. && \
    rm -rf ./inst && \
    rm install-tl-unx.tar.gz && \
    tlmgr --version

WORKDIR /home
VOLUME ["/root/.config"]

CMD ["/bin/sh"]