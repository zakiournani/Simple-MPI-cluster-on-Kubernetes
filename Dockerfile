FROM ubuntu:18.04


RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN cd /root/.ssh && cp id_rsa.pub authorized_keys

RUN apt-get install -y python-pip gfortran

RUN cd /tmp && wget https://github.com/jplana/python-etcd/archive/0.4.1.tar.gz && \
    tar xvfz 0.4.1.tar.gz && cd python-etcd-0.4.1 && pip install .

RUN cd /tmp && wget http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz && \
    tar xvfz mpich-3.1.4.tar.gz && cd mpich-3.1.4 && ./configure --prefix=/tmp/mpich && \
    make && make VERBOSE=1 && make install

RUN apt-get install -y telnet curl

ENV PATH $PATH:/tmp/mpich/bin

ADD id_rsa /root/.ssh
RUN chmod  600 /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh
ADD authorized_keys /root/.ssh
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN mkdir -p /mpi 
WORKDIR /mpi
ADD hw.c /mpi
RUN mpicc -o /mpi/hw /mpi/hw.c

EXPOSE 22

ENTRYPOINT    ["/usr/sbin/sshd"]
CMD ["-D"]
