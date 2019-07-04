FROM centos:7

RUN \
    yum --quiet --assumeyes update && \
    yum --quiet --assumeyes install epel-release file && \
    yum --assumeyes install cobbler && \
    yum clean all

ENTRYPOINT ["cobblerd"]
CMD ["--no-daemonize"]
