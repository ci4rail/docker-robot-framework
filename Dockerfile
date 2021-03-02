FROM alpine:3.13 AS get_sources
RUN apk update && apk upgrade && \
    apk add --no-cache git
ARG ROBOTFRAMEWORK_VERSION
ENV ROBOTFRAMEWORK_VERSION=${ROBOTFRAMEWORK_VERSION}
RUN mkdir -p /source && cd /source && \
    if [ -z "${ROBOTFRAMEWORK_VERSION}" ]; then \
        echo Cloning master branch; \
        git clone -b master --depth 1 https://github.com/robotframework/robotframework.git; \
    else \
        echo Cloning branch ${ROBOTFRAMEWORK_VERSION}; \
        git clone -b ${ROBOTFRAMEWORK_VERSION} --depth 1 https://github.com/robotframework/robotframework.git; \
    fi #redo

FROM python:3.9.2-alpine3.13
LABEL description="Robot Framework in an alpine based Python 3 docker image"
COPY --from=get_sources /source/robotframework /source/
RUN cd /source/ && python setup.py install && cd / && rm -rf /source

ENTRYPOINT [ "/usr/local/bin/robot" ]
CMD [ "--help" ]