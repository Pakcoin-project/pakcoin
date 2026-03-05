FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libdb++-dev \
    libboost-all-dev \
    libqrencode-dev \
    libminiupnpc-dev \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /pakcoin

# Copy source code
COPY . /pakcoin/

# Build the project with LDFLAGS to disable PIE (needed for LevelDB compatibility)
RUN cd src && make -f makefile.unix clean && LDFLAGS="-no-pie" make -f makefile.unix

# Set the entrypoint
CMD ["/pakcoin/src/pakcoind"]
