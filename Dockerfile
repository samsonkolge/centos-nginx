FROM centos:latest

MAINTAINER Cameron Waldron <cameron.waldron@gmail.com>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install nginx git && \
    yum clean all && \
    mkdir /root/scripts && \
    echo $'#!/bin/bash\n\
function clone {\n\
  git clone $1 /root/app\n\
}\n\
if (( $# != 1 ))\n\
then\n\
  echo "Usage: get [GIT REPO PATH]"\n\
  exit 1\n\
fi\n\
if clone $1; then\n\
  /root/app/scripts/publish.sh\n\
fi'\
>> /root/scripts/get && \
    echo $'#!/bin/bash\n\
function pull {\n\
  cd /root/app\n\
  git pull\n\
}\n\
if pull; then\n\
  /root/app/scripts/publish.sh\n\
fi'\
>> /root/scripts/update && \
    chmod u+x /root/scripts/update && \
    chmod u+x /root/scripts/get
ENV PATH /root/scripts:$PATH
EXPOSE 80 443
CMD ["nginx","-g","daemon off;"]
