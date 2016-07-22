FROM alpine:3.4
MAINTAINER James Grady jlgrady1@gmail.com

# Define the location of the hlld conf
ENV HLLD_CONFIG /etc/hlld/hlld.conf

# Install dependencies
RUN apk update && apk add build-base scons

# Copy required files
COPY LICENSE /LICENSE
COPY SConstruct /hlld/
COPY src/ /hlld/src
COPY deps /hlld/deps
COPY hlld.conf $HLLD_CONFIG

# Definte mountable data and config locations
VOLUME /data
VOLUME /etc/hlld

# Build hlld
RUN cd /hlld && scons
RUN mv /hlld/hlld /usr/local/bin/hlld
RUN rm -rf /hlld
RUN apk del build-base scons

# Define working directory
WORKDIR /data

# Exposed ports
EXPOSE 4553

# Default command
CMD /usr/local/bin/hlld -f $HLLD_CONFIG
