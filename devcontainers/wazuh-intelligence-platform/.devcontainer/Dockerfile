FROM ubuntu:jammy

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \

    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    acl \
    apt-utils \
    clang-format \
    clang-tools \
    cmake \
    curl \
    debconf-utils \
    doxygen \
    dpkg-dev \
    file \
    gcc \
    g++ \
    git \
    gnupg \
    graphviz \
    jq \
    lcov \
    mysql-server \
    ninja-build \
    patchelf \
    plantuml \
    python3 \
    valgrind \
    wget && \
    rm -rf /var/lib/apt/lists/*

# # Add MongoDB
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor | tee /usr/share/keyrings/mongodb.gpg > /dev/null
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mongodb-org && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/danmar/cppcheck/archive/refs/tags/2.8.tar.gz && \
    tar xfz 2.8.tar.gz && \
    cmake -S cppcheck-2.8/ -B cppcheck-2.8/build && \
    cmake --build cppcheck-2.8/build -j$(nproc) && \
    cmake --install cppcheck-2.8/build

# [Optional] Set the default user
USER $USERNAME
