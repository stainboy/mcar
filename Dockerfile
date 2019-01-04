FROM alpine
ENTRYPOINT [ "clawer" ]
WORKDIR /repo
VOLUME [ "/repo" ]
RUN \
  apk add --no-cache bash curl git openssh-client &&\
  echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
COPY clawer.sh /usr/local/bin/clawer
