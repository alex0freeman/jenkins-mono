FROM ubuntu:15.04

# update apt-get, install wget, git, mono, nuget, nant
RUN apt-get update \
 && apt-get install -y wget git mono-complete nuget nant \
 && rm -rf /var/lib/apt/lists/*

# install jenkins
ADD https://jenkins-ci.org/debian/jenkins-ci.org.key /root/jenkins-ci.org.key
RUN apt-key add - < /root/jenkins-ci.org.key \
 && sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' \
 && apt-get update \
 && apt-get install -y jenkins \
 && rm -rf /var/lib/apt/lists/*

# install jenkins plugins 
COPY ./InstallPlugins.sh /root/ 
RUN sh /root/InstallPlugins.sh

# msbuild.exe
RUN ln -s /usr/bin/xbuild /usr/bin/msbuild.exe

# jenkins port
EXPOSE 8080

# jenkins home
# VOLUME /var/lib/jenkins
# VOLUME /var/log/jenkins

# start jenkins
ENTRYPOINT touch /var/log/jenkins/jenkins.log | chown jenkins:jenkins /var/log/jenkins/jenkins.log | service jenkins start | tail -f /var/log/jenkins/jenkins.log
