FROM quay.io/pod_utils/systemd-libvirt:1.0.3

ARG username="jenkins"
ARG openjdk_version="1.8.0"
ARG agent_jar_version="3.27"

ADD https://download.docker.com/linux/centos/docker-ce.repo /etc/yum.repos.d/docker-ce.repo

RUN \
    yum install -y git sed bash procps-ng createrepo python-paramiko \
        PyYAML python2-pyxdg python-jinja2 python-py python34-PyYAML \
        docker-ce firewalld daemonize sudo \
        java-${openjdk_version}-openjdk-headless which
COPY sbin/lock_on_slot.sh /usr/sbin/lock_on_slot
RUN chmod +x /usr/sbin/lock_on_slot
COPY sbin/jnlp_launcher.sh /usr/sbin/jnlp_launcher
RUN chmod +x /usr/sbin/jnlp_launcher
COPY systemd/* /etc/systemd/system/
COPY etc/* /etc/
RUN curl https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${agent_jar_version}/remoting-${agent_jar_version}.jar \
    -o /agent.jar
RUN systemctl enable \
        home-jenkins.mount jenkins-jnlp-agent.service lock-on-slot.service \
        mk-shared-slot.service prep-jenkins-agent-runtime.service \
        var-lib-docker.mount var-lib-sharedslt.mount docker.service

WORKDIR /home/$username
