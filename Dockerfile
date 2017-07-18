FROM python:3.6-alpine
MAINTAINER MoonChang Chae mcchae@gmail.com
LABEL Description="alpine python 3.6 openssh server"

RUN apk --update add tzdata openssh bash netcat-openbsd sudo && \
    cp -f /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    date && \
    mkdir -p ~root/.ssh && chmod 700 ~root/.ssh/ && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

RUN addgroup toor \
    && adduser  -G toor -s /bin/sh -D toor \
    && echo "toor:r" | /usr/sbin/chpasswd \
    && echo "toor    ALL=(ALL) ALL" >> /etc/sudoers

ADD chroot /

ENTRYPOINT ["/usr/local/bin/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
