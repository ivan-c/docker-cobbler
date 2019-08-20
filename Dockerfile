FROM centos:7 as cobbler_base

RUN \
    yum --quiet --assumeyes update && \
    yum --quiet --assumeyes install epel-release file && \
    yum --assumeyes install cobbler xorriso && \
    yum clean all

COPY sample.seed /var/lib/cobbler/kickstarts/sample.seed

ENTRYPOINT ["cobblerd"]
CMD ["--no-daemonize"]

#---
FROM cobbler_base as syslinux_dump
ADD https://rpmfind.net/linux/centos/7.6.1810/os/x86_64/Packages/syslinux-4.05-15.el7.x86_64.rpm /tmp/

RUN cd /tmp && \
    rpm2cpio syslinux-4.05-15.el7.x86_64.rpm | cpio -idmv

#---
FROM cobbler_base as cobbler_aarch64

COPY --from=syslinux_dump /tmp/usr/share/syslinux/ /usr/lib/syslinux/

#---
FROM debian:buster as dnsmasq

ENV DEBIAN_FRONTEND=noninteractive

# Install tools for reading build dependencies; see `Build-Depends`
# Squelch superfluous output; apt-get has poor verbosity control
RUN \
    apt-get update --quiet > /dev/null && \
    apt-get install --quiet --quiet --no-install-recommends \
        dnsmasq
ENTRYPOINT dnsmasq
