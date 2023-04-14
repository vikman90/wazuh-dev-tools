FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y \
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

RUN wget https://github.com/danmar/cppcheck/archive/refs/tags/2.8.tar.gz && \
    tar xfz 2.8.tar.gz && \
    cmake -S cppcheck-2.8/ -B cppcheck-2.8/build && \
    cmake --build cppcheck-2.8/build -j$(nproc) && \
    cmake --install cppcheck-2.8/build

# Add MongoDB
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor | tee /usr/share/keyrings/mongodb.gpg > /dev/null
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt-get update && \
    apt-get install -y \
    mongodb-org \
    rm -rf /var/lib/apt/lists/*

