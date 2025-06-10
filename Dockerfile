FROM alpine:latest

# Install git, nodejs, and npm
RUN apk update && apk add --no-cache git nodejs npm python3 py3-pip py3-virtualenv sed bash \
    && virtualenv /venv \
    && /venv/bin/pip install --upgrade pip requests colorama

ENV PATH="/venv/bin:$PATH"

RUN pip install --upgrade pip && pip install requests

# Clone the repository, install npm dependencies, and create dlc directory
RUN git clone https://github.com/TappedOutReborn/GameServer-Reborn.git server \
    && cd server \
    && rm -rf *.git \
    && npm install

RUN git clone https://github.com/TappedOutReborn/DLC-Downloader.git \
    && cd DLC-Downloader \
    && python3 downloadDlcs.py \
    && mv dlc .. \
    && cd .. \
    && rm -rf DLC-Downloader \

RUN sed -i 's/"ip": "0.0.0.0",/"ip": "127.0.0.1",/' config.json

# Set working directory to the cloned repo
WORKDIR /server

EXPOSE 4242

# Default command\
CMD ["npm", "start"]
