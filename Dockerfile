FROM ubuntu:bionic
RUN apt-get update -qq && apt-get install -y -qq apt-utils make gcc autotools-dev git autoconf gperf bison flex texinfo wget help2man gawk libtool-bin xz-utils libncurses5-dev python-dev unzip sudo python-pip g++

RUN  pip install esptool

RUN cd /opt && git clone --recursive -b xtensa-1.22.x https://github.com/JDRobotter/crosstool-NG && cd crosstool-NG && ./bootstrap && mkdir ./local && ./configure --prefix=$PWD/local && make install

RUN adduser --disabled-password --shell /bin/bash --gecos "User" crosstoolng && chown -R crosstoolng:crosstoolng /opt/crosstool-NG


RUN cd /opt/crosstool-NG && sudo -u crosstoolng ./ct-ng clean && sudo -u crosstoolng ./ct-ng xtensa-lx106-elf && sudo -u crosstoolng ./ct-ng build
RUN chmod -R u+w /opt/crosstool-NG/builds/xtensa-lx106-elf

ENV PATH ${PATH}:/opt/crosstool-NG/builds/xtensa-lx106-elf/bin/
RUN cd /opt && git clone --recursive https://github.com/tommie/lx106-hal.git && cd lx106-hal && autoreconf -i && ./configure --host=xtensa-lx106-elf --prefix=/opt/crosstool-NG/builds/xtensa-lx106-elf/xtensa-lx106-elf/sysroot/usr/ &&  make -j4 install
