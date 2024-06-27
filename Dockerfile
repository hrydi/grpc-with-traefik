FROM python:alpine AS base

ARG username="app"
ARG workdir=/home/${username}/api
ARG host="0.0.0.0"
ARG port="3000"

ENV TZ=Asia/Jakarta
ENV WORKDIR=${workdir}
ENV HOME=/home/${username}
ENV HOST=${host}
ENV PORT=${port}

# username is required
RUN [ ! "${username}" == "" ]

RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
RUN apk add --no-cache --update \
    tzdata \
    git \
    curl \
    icu-libs \
    unzip \
    zlib-dev \
    musl \
    nss \
    libaio \
    libnsl
RUN rm -rf /var/cache/apk/* /tmp/*

FROM base AS base-non-root
ENV PATH=$PATH:/home/${username}/.local/bin
RUN mkdir -p ${WORKDIR}
RUN addgroup -g 1000 -S ${username} \
    && adduser --home ${HOME} -u 1000 -S ${username} -G ${username} \
    && chown -R ${username}:${username} ${WORKDIR}
USER ${username}
WORKDIR ${WORKDIR}
COPY backend/requirements.txt requirements.txt
RUN pip install -r requirements.txt
