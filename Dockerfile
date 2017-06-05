# Env vars needed to perform the deployment are automatically created
# by ./deploy.

FROM jenkinsci/jenkins:lts
MAINTAINER Carlos Nunez <dev@carlosnunez.me>
USER jenkins
ENTRYPOINT 'java -jar jenkins-cli.jar -s http://localhost:8000 build infrastructure'
