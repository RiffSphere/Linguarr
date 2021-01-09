FROM alpine:latest
MAINTAINER RiffSphere

ENV OUTPUT=/config/results
ENV CLEAN=false

RUN \
        echo "* install packages *" && \
        apk add --no-cache bash file git ffmpeg && \
        echo "*clonse project *" && \
        git clone -b master https://github.com/RiffSphere/Linguarr /app

CMD bash /app/Linguarr.sh $OUTPUT $CLEAN

VOLUME /config
VOLUME /media

