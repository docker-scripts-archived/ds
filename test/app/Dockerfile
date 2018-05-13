FROM ubuntu:18.04

### install systemd
RUN apt update && \
    apt -y upgrade && \
    apt -y install systemd && \
    systemctl set-default multi-user.target

CMD ["/sbin/init"]
WORKDIR /host

### install Docker
RUN apt -y install \
        apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge"
RUN apt update && apt -y install docker-ce

### install other packages
RUN apt install -y build-essential
