#FROM phusion/baseimage:master-amd64
FROM phusion/baseimage:focal-1.2.0

# Environment variables used in container
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Oslo
ENV USER user
ENV PATH "/home/$USER/.local/bin:${PATH}"
ENV RESOURCES /opt/resources

# Install all required packages
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y \
    binutils \
    bison \
    build-essential \
    cargo \
    cmake \
    cpio \
    curl \
    file \
    g++-multilib \
    gawk \
    gcc \
    gdb \
    gdb-multiarch \
    gdbserver \
    git \
    iputils-ping \
    ipython3 \
    jq \
    lib32stdc++6 \
    libc6-dbg \
    libc6-dbg:i386 \
    libc6:i386 \
    libffi-dev \
    libglib2.0-dev \
    liblzma-dev \
    libmpc-dev \
    libssl-dev \
    locales \
    ltrace \
    nasm \
    net-tools \
    netcat \
    patchelf \
    pkg-config \
    python3-dev \
    python3-distutils \
    python3-pip \
    python3-setuptools \
    qemu \
    qemu-system \
    rlwrap \
    rpm2cpio \
    ruby \
    ruby-dev \
    socat \
    strace \
    sudo \
    tmux \
    vim \
    wget \
    zsh \
    zstd \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

# Fix time zone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Fix locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Install radare2
RUN version=$(curl -s https://api.github.com/repos/radareorg/radare2/releases/latest | grep -P '"tag_name": "(.*)"' -o| awk '{print $2}' | awk -F"\"" '{print $2}') && \
    wget https://github.com/radareorg/radare2/releases/download/${version}/radare2_${version}_amd64.deb && \
    dpkg -i radare2_${version}_amd64.deb && rm radare2_${version}_amd64.deb

# Install gdb 14.2
RUN apt-get install libreadline6-dev -y && \
    wget https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz && \
    tar -xvf gdb-14.2.tar.xz && \
    cd gdb-14.2 && \
    ./configure --prefix=/usr --with-system-readline --with-python=/usr/bin/python3 && \
    make && \
    make install && \
    cd .. && \
    rm -rf gdb-14.2 gdb-14.2.tar.xz

# Install one_gadget & seccomp-tools
RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

# Download prebuilt glibc versions for debugging by skysider
COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.25 /glibc/2.25/64 /glibc/2.25/64
#COPY --from=skysider/glibc_builder32:2.25 /glibc/2.25/32 /glibc/2.25/32

COPY --from=skysider/glibc_builder64:2.26 /glibc/2.26/64 /glibc/2.26/64
COPY --from=skysider/glibc_builder32:2.26 /glibc/2.26/32 /glibc/2.26/32

COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64
COPY --from=skysider/glibc_builder32:2.27 /glibc/2.27/32 /glibc/2.27/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

COPY --from=skysider/glibc_builder64:2.30 /glibc/2.30/64 /glibc/2.30/64
COPY --from=skysider/glibc_builder32:2.30 /glibc/2.30/32 /glibc/2.30/32

COPY --from=skysider/glibc_builder64:2.31 /glibc/2.31/64 /glibc/2.31/64
COPY --from=skysider/glibc_builder32:2.31 /glibc/2.31/32 /glibc/2.31/32

COPY --from=skysider/glibc_builder64:2.33 /glibc/2.33/64 /glibc/2.33/64
COPY --from=skysider/glibc_builder32:2.33 /glibc/2.33/32 /glibc/2.33/32

COPY --from=skysider/glibc_builder64:2.34 /glibc/2.34/64 /glibc/2.34/64
COPY --from=skysider/glibc_builder32:2.34 /glibc/2.34/32 /glibc/2.34/32

COPY --from=skysider/glibc_builder64:2.35 /glibc/2.35/64 /glibc/2.35/64
COPY --from=skysider/glibc_builder32:2.35 /glibc/2.35/32 /glibc/2.35/32

COPY --from=skysider/glibc_builder64:2.36 /glibc/2.36/64 /glibc/2.36/64
COPY --from=skysider/glibc_builder32:2.36 /glibc/2.36/32 /glibc/2.36/32

COPY resources/linux_server resources/linux_server64 $RESOURCES/
RUN chmod a+x $RESOURCES/linux_server $RESOURCES/linux_server64

# Add a new user that is not root, and install the rest as that user
RUN useradd -d /home/$USER/ -m -p $USER -s /bin/bash $USER
RUN echo "$USER:$USER" | chpasswd
RUN usermod -aG sudo $USER
RUN mkdir -p $RESOURCES && chown -R $USER:$USER $RESOURCES
USER $USER
WORKDIR /home/$USER

# Install Oh My zsh and add .zshrc
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY .zshrc /home/$USER/.zshrc

# Install nice-to-have tools with pip
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir --user \
    angr \
    apscheduler \
    binsync \
    capstone \
    cryptography \
    decomp2dbg \
    keystone-engine \
    pebble \
    pwntools \
    pycryptodome \
    requests \
    r2pipe \
    ropgadget \
    ropper \
    smmap2 \
    unicorn \
    z3-solver

# Install new Rust version
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install pwninit
#RUN wget https://github.com/io12/pwninit/releases/download/3.2.0/pwninit -P /home/$USER/.local/bin/ && \
#    chmod +x /home/$USER/.local/bin/pwninit
RUN cargo install pwninit


# Install useful plugins for gdb
RUN mkdir ~/.gdb-plugins && \
    git clone --depth 1 https://github.com/pwndbg/pwndbg.git .gdb-plugins/pwndbg && \
    git clone --depth 1 https://github.com/longld/peda.git .gdb-plugins/peda && \
    git clone --depth 1 https://github.com/nicolaipre/peda-heap.git .gdb-plugins/peda-heap && \
    git clone --depth 1 https://github.com/hugsy/gef.git .gdb-plugins/gef && \
    git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git .gdb-plugins/Pwngdb && \
    curl -O "https://gist.githubusercontent.com/nicolaipre/df88b22bb0658b6719a92a73175638a2/raw/1e61ad6d4d9fbc1a97fc48b1a74f3a0e511d505e/.gdbinit"
    # RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh

# Download statically compiled gdbserver binaries for different architectures.
# Copy a gdbserver to a remote host or container for remote debugging or just use qemu.
RUN git clone --depth 1 https://github.com/hugsy/gdb-static.git $RESOURCES/gdbservers

# Download magic gadget (gadget finder for x86/x86-64)
RUN git clone --depth 1 https://github.com/m1ghtym0/magic_gadget_finder.git $RESOURCES/magic_gadget_finder && \
    ln -s $RESOURCES/magic_gadget_finder/magic.py /home/$USER/.local/bin/magicgadget

# Download the libc database by niklasb
# TODO: Same stuff we get from skysiders glibc above?
# TODO: Figure out if we can just use https://libc.rip and https://libc.blukat.me instead...
RUN git clone --depth 1 https://github.com/niklasb/libc-database.git $RESOURCES/libc-database && \
    cd $RESOURCES/libc-database && \
    ./get ubuntu debian || echo "$RESOURCES/libc-database/" > ~/.libcdb_path && \
    rm -rf /tmp/*

# Install checksec.sh (for those who want this instead of pwntools checksec)
RUN wget https://github.com/slimm609/checksec.sh/archive/refs/tags/2.5.0.zip -P $RESOURCES && \
    unzip $RESOURCES/2.5.0.zip -d $RESOURCES && \
    mv $RESOURCES/checksec.sh-2.5.0/checksec /home/$USER/.local/bin/checksec.sh && \
    rm -rf $RESOURCES/checksec.sh-2.5.0 $RESOURCES/2.5.0.zip

RUN ln -s $RESOURCES ~/resources

ENTRYPOINT ["/bin/zsh"]
