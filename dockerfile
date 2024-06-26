# https://gitlab.com/remyj38/dockerfiles/-/blob/ariang/nginx16-alpine/Dockerfile

FROM alpine as downloader

LABEL MAINTAINER="Rémy Jacquin <remy@remyj.fr>"

RUN \
    apk add --no-cache --virtual=build-dependencies \
    unzip \
    jq \
    curl && \
    apk add --no-cache \
    && \
    ANVERSION=$(curl -sX GET "https://api.github.com/repos/seiry/AriaNg/releases/latest" \
    | jq -r .tag_name ) && \
    curl -o \
    /tmp/AriaNg.zip -L \
    "https://github.com/seiry/AriaNg/releases/download/${ANVERSION}/AriaNg-${ANVERSION}.zip" && \
    unzip /tmp/AriaNg.zip -d /ariang && \
    apk del --purge \
    build-dependencies && \
    rm -rf \
    /tmp/*


FROM nginx:1.24-alpine as final

COPY --from=downloader /ariang /usr/share/nginx/html
COPY init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 80

ENTRYPOINT [ "/init.sh" ]
