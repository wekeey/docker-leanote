FROM alpine:latest

LABEL maintainer="wekeey@gmail.com"
LABEL version="2.6.1"
LABEL description="docker images for leanote"

ENV TIMEZONE=Asia/Shanghai
ENV LEANOTE_VERSION=2.6.1

COPY . /home/leanote

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
    && apk add --no-cache supervisor mongodb mongodb-tools yaml-cpp=0.6.2-r2 tzdata \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && mkdir -p /data/leanote/public/upload /data/leanote/files /data/leanote/mongodb_backup /data/leanote/conf /data/mongodb /data/log/mongodb \
    && tar -zxf /home/leanote/src/leanote-linux-amd64-v2.6.1.bin.tar.gz -C /usr \
    && cp /home/leanote/scripts/initdb.sh /usr/bin/initdb.sh \
    && cp -R /home/leanote/conf/supervisor/* /etc \
    && cp -R /usr/leanote/mongodb_backup/leanote_install_data /data/leanote/mongodb_backup/leanote_install_data \
    && cp /usr/leanote/conf/* /data/leanote/conf \
    && rm -rf /usr/leanote/public/upload \
    && rm -rf /usr/leanote/files \
    && rm -rf /usr/leanote/conf \
    && rm -rf /usr/leanote/mongodb_backup \
    && ln -sf /data/leanote/public/upload /usr/leanote/public/upload \
    && ln -sf /data/leanote/files /usr/leanote/files \
    && ln -sf /data/leanote/mongodb_backup /usr/leanote/mongodb_backup \
    && ln -sf /data/leanote/conf /usr/leanote/conf \
    && chmod +x /usr/leanote/bin/run.sh \
    && chmod +x /usr/bin/initdb.sh \
    && apk del tzdata \
    && rm -rf /var/cache/apk/* \
    && rm -rf /home/leanote

RUN hash=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-64};echo;); \
    sed -i "s/app.secret=.*$/app.secret=$hash #/" /data/leanote/conf/app.conf; \
    sed -i "s/site.url=.*$/site.url=\${SITE_URL} /" /data/leanote/conf/app.conf; \
    sed -i "s/default_language=.*$/default_language=zh-cn /" /data/leanote/conf/app.conf; \
    sed -i "s/logfile=.*$/logfile=/data/log/supervisord.log /" /etc/supervisord.conf; \
    sed -i "s/;pidfile=/pidfile=/" /etc/supervisord.conf;

VOLUME /data

WORKDIR /data

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
