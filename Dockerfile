FROM mcchae/sshd-x
MAINTAINER MoonChang Chae mcchae@gmail.com
LABEL Description="alpine miniconda3 with openssh server"

# # Install glibc and useful packages
# RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
#     && apk --update add \
#     bash \
#     git \
#     curl \
#     ca-certificates \
#     bzip2 \
#     unzip \
#     sudo \
#     libstdc++ \
#     glib \
#     libxext \
#     libxrender \
#     && curl "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" -o /etc/apk/keys/sgerrand.rsa.pub \
#     && curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk" -o glibc.apk \
#     && apk add glibc.apk \
#     && curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk" -o glibc-bin.apk \
#     && apk add glibc-bin.apk \
#     && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib \
#     && rm -rf glibc*apk /var/cache/apk/*


# # Configure environment
# ENV CONDA_DIR /opt/conda
# ENV PATH $CONDA_DIR/bin:$PATH
# ENV SHELL /bin/bash
# # ENV LC_ALL en_US.UTF-8
# # ENV LANG en_US.UTF-8
# # ENV LANGUAGE en_US.UTF-8

# # Configure Miniconda
# ENV MINICONDA_VER 4.3.21
# ENV MINICONDA Miniconda3-$MINICONDA_VER-Linux-x86_64.sh
# ENV MINICONDA_URL https://repo.continuum.io/miniconda/$MINICONDA
# ENV MINICONDA_MD5_SUM c1c15d3baba15bf50293ae963abef853

# # Install conda as jovyan
# # ENV LD_TRACE_LOADED_OBJECTS=1
# RUN cd /tmp \
#     && mkdir -p $CONDA_DIR \
#     && curl -L $MINICONDA_URL  -o miniconda.sh \
#     && echo "$MINICONDA_MD5_SUM  miniconda.sh" | md5sum -c - \
#     && /bin/bash miniconda.sh -f -b -p $CONDA_DIR \
#     && rm miniconda.sh \
#     && $CONDA_DIR/bin/conda install --yes conda==$MINICONDA_VER \
#     && sed -i -e "s|^export PATH=|export PATH=/opt/conda/bin:|g" /etc/profile

RUN apk --update  --repository http://dl-4.alpinelinux.org/alpine/edge/community add \
    bash \
    git \
    curl \
    ca-certificates \
    bzip2 \
    unzip \
    sudo \
    libstdc++ \
    glib \
    libxext \
    libxrender \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk" -o /tmp/glibc.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk" -o /tmp/glibc-bin.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk" -o /tmp/glibc-i18n.apk \
    && apk add --allow-untrusted /tmp/glibc*.apk \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    && /usr/glibc-compat/bin/localedef -i ko_KR -f UTF-8 ko_KR.UTF-8 \
    && rm -rf /tmp/glibc*apk /var/cache/apk/*

# Configure environment
ENV CONDA_DIR=/opt/conda CONDA_VER=4.3.14
ENV PATH=$CONDA_DIR/bin:$PATH SHELL=/bin/bash LANG=C.UTF-8

# Install conda
# ENV LD_TRACE_LOADED_OBJECTS=1
RUN mkdir -p $CONDA_DIR \
    && echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh \
    && curl https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-x86_64.sh  -o mconda.sh \
    && /bin/bash mconda.sh -f -b -p $CONDA_DIR \
    && rm mconda.sh \
    && $CONDA_DIR/bin/conda install --yes conda==${CONDA_VER} \
    && sed -i -e "s|^export PATH=|export PATH=/opt/conda/bin:|g" /etc/profile

# RUN apk del musl musl-utils \
#     && ln -s /usr/glibc-compat/sbin/ldconfig /sbin/ldconfig \
#     && ln -s /usr/glibc-compat/bin/iconv /usr/bin/iconv \
#     && ln -s /usr/glibc-compat/bin/ldd /usr/bin/ldd \
#     && ln -s /usr/glibc-compat/bin/getconf /usr/bin/getconf \
#     && ln -s /usr/glibc-compat/bin/getent /usr/bin/getent

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
