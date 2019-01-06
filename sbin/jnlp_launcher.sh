#!/bin/bash -xe

source /etc/ci-container.environment

if [ -n "$JENKINS_TUNNEL" ]; then
    TUNNEL="-tunnel $JENKINS_TUNNEL"
fi

exec /usr/bin/java -cp "${JENKINS_AGENT_WORKDIR}/agent.jar" \
    hudson.remoting.jnlp.Main \
    -headless \
    -url "${JENKINS_URL}" \
    $TUNNEL \
    -workDir "${JENKINS_AGENT_WORKDIR}" \
    "${JENKINS_SECRET}" "${JENKINS_AGENT_NAME}"
