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

# Create data directory and default config
RUN mkdir -p /root/.pakcoin && \
    echo "rpcuser=pakcoinrpc" > /root/.pakcoin/pakcoin.conf && \
    echo "rpcpassword=3RjUdeJZ5n2KPQ8bqNwXAFAawVddViNct3myNwLdmNwc" >> /root/.pakcoin/pakcoin.conf && \
    echo "rpcallowip=127.0.0.1" >> /root/.pakcoin/pakcoin.conf && \
    echo "printtoconsole=1" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=161.97.124.118" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=168.119.175.57" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=176.101.7.44" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=185.68.67.39" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=27.138.155.95" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=38.242.235.208" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=84.17.54.17" >> /root/.pakcoin/pakcoin.conf && \
    echo "addnode=93.207.232.197" >> /root/.pakcoin/pakcoin.conf && \
    chmod 600 /root/.pakcoin/pakcoin.conf

# Set the entrypoint - printtoconsole ensures logs go to stdout
CMD ["/pakcoin/src/pakcoind", "-printtoconsole=1"]