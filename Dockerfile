FROM java:8
MAINTAINER kunitaya

# install mysql-client
RUN apt-get update
RUN apt-get -y install mysql-client
RUN apt-get clean all

# download JobScheduler Master
ADD https://download.sos-berlin.com/JobScheduler.1.11/jobscheduler_linux-x64.1.11.3.tar.gz /usr/local/src/
RUN ln -s /usr/local/src/jobscheduler.1.11.3 /usr/local/src/jobscheduler
COPY jobscheduler_install.xml /usr/local/src/jobscheduler/install.xml

COPY init.sh /usr/local/bin/init_scheduler.sh
RUN chmod +x /usr/local/bin/init_scheduler.sh

EXPOSE 4444 40444

CMD [bash, /usr/local/bin/init_scheduler.sh]
