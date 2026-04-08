FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  curl \
  wget \
  git \
  build-essential \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  ruby \
  ruby-dev \
  ruby-bundler \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && \
  rm go1.21.5.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

ARG HUGO_VERSION=0.159.1
RUN ARCH=$(dpkg --print-architecture) && \
  wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${ARCH}.deb && \
  dpkg -i hugo_extended_${HUGO_VERSION}_linux-${ARCH}.deb && \
  rm hugo_extended_${HUGO_VERSION}_linux-${ARCH}.deb

WORKDIR /app

COPY go.mod go.sum ./
COPY hugo.yaml ./

RUN go mod download

COPY . .

RUN ./scripts/generate_index.rb

RUN hugo

EXPOSE 1313

CMD ["hugo", "server", "--logLevel", "debug", "--disableFastRender", "-p", "1313", "--bind", "0.0.0.0"]
