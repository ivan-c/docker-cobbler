FROM centos:7

RUN \
    yum --quiet --assumeyes update && \
    yum --quiet --assumeyes install epel-release file dnsmasq && \
    yum --assumeyes install cobbler xorriso && \
    yum clean all

ENTRYPOINT ["cobblerd"]
CMD ["--no-daemonize"]
