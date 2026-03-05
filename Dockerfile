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

# Clone the repository (main branch with Ubuntu 20.04 compatibility)
RUN git clone --branch main https://github.com/Pakcoin-project/pakcoin.git /pakcoin

# Set working directory
WORKDIR /pakcoin

# Build the project with LDFLAGS to disable PIE (needed for LevelDB compatibility)
RUN cd src && make -f makefile.unix clean && LDFLAGS="-no-pie" make -f makefile.unix

# Expose default ports (mainnet: 7867, testnet: 24070, RPC: 7866)
EXPOSE 7867 24070 7866

# Set the entrypoint
CMD ["/pakcoin/src/pakcoind"]
