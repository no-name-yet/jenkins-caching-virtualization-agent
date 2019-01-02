FROM quay.io/pod_utils/systemd-libvirt:1.0.1

ARG username="jenkins"
ARG openjdk_version="1.8.0"
ARG agent_jar_version="3.27"

RUN \
    yum install -y git sed bash procps-ng createrepo python-paramiko \
        PyYAML python2-pyxdg python-jinja2 python-py python34-PyYAML \
        docker firewalld daemonize sudo \
        java-${openjdk_version}-openjdk-headless which
COPY sbin/lock_on_slot.sh /usr/sbin/lock_on_slot
RUN chmod +x /usr/sbin/lock_on_slot
COPY sbin/agent_daemon.sh /agent_daemon
COPY systemd/* /etc/systemd/system/
COPY etc/* /etc/
RUN curl https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${agent_jar_version}/remoting-${agent_jar_version}.jar \
    -o /agent.jar
RUN systemctl enable \
        home-jenkins.mount jenkins-jnlp-agent.service lock-on-slot.service \
        mk-shared-slot.service prep-jenkins-agent-runtime.service \
        var-lib-docker.mount var-lib-sharedslt.mount

WORKDIR /home/$username
