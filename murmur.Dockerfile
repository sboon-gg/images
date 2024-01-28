FROM debian:10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y --no-install-recommends \
        python \
        libcap2 \
        libqt4-dbus \
        libqt4-sql \
        libqt4-sql-sqlite \
        libqt4-network \
        unzip \
        wget;

# RUN rm -rf /var/lib/apt/lists/*;

WORKDIR /murmur

COPY application/mods/pr/bin/PRMurmur .

RUN wget --no-check-certificate https://github.com/ClundXIII/pr-mumble-fix/archive/refs/heads/master.zip -O mumble_fix.zip
RUN unzip mumble_fix.zip
RUN cp -r pr-mumble-fix-master/** .
RUN dpkg -i ice34-slice_3.4.2-8.2_all.deb

RUN wget http://snapshot.debian.org/archive/debian/20150709T214436Z/pool/main/o/openssl/libssl1.0.0_1.0.2d-1_amd64.deb
RUN dpkg -i libssl1.0.0_1.0.2d-1_amd64.deb

COPY scripts/murmur-setup.sh setup.sh
COPY scripts/murmur.sh entrypoint.sh

RUN chmod +x setup.sh; \
    chmod +x entrypoint.sh; \
    chmod +x initialsetup.sh; \
    chmod +x createchannel.sh; \
    chmod +x prmurmurd.x64;

EXPOSE 64740/tcp
EXPOSE 64740/udp

ENV LD_LIBRARY_PATH="/murmur/libs"
ENV PYTHONPATH="/murmur/python/Ice/"

ENTRYPOINT ["./entrypoint.sh"]
