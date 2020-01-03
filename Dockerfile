FROM ubuntu:bionic

# Set environment
ENV MMONIT_VERSION 3.7.3
ENV MMONIT_USER monit
ENV MMONIT_ROOT /opt/mmonit
ENV MMONIT_BIN $MMONIT_ROOT/bin/mmonit

# Install prerequisites
RUN apt-get -y update && apt-get -y install \
  curl

# Add mmonit user
RUN useradd -m -d $MMONIT_ROOT $MMONIT_USER

# Switch user
USER $MMONIT_USER

# Set workdir to mmonit root
WORKDIR $MMONIT_ROOT

# Download and install mmonit
RUN curl -s https://mmonit.com/dist/mmonit-$MMONIT_VERSION-linux-x64.tar.gz | tar --strip-components=1 -xz -C $MMONIT_ROOT

# Forward logs to docker log collector
RUN ln -sf /dev/stdout $MMONIT_ROOT/logs/mmonit.log \
    && ln -sf /dev/stdout $MMONIT_ROOT/logs/access.log \
    && ln -sf /dev/stderr $MMONIT_ROOT/logs/error.log


# Run in foreground
EXPOSE 8080
ENTRYPOINT $MMONIT_BIN -i
