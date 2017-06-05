FROM alpine:latest
MAINTAINER Carlos Nunez <dev@carlonunez.me>
COPY Jenkinsfile.args Jenkinsfile_args.json
RUN curl -X POST \
  http://jenkins-master:8080/job/infrastructure-carlosnunez.me/start/build \
  --data-urlencode json=$(cat Jenkinsfile_args.json)
