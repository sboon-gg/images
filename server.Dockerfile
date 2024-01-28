FROM debian:10-slim as game

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y --no-install-recommends wget libncurses5 libpython2.7

WORKDIR /pr
COPY application/ .

RUN chmod +x bin/amd-64/prbf2_l64ded.PRMSProxy
RUN chmod +x bin/amd-64/prbf2_l64ded
RUN chmod +x start_pr.sh

RUN rm -r pb && cp -r pb_amd-64 pb

# Install missing library
RUN wget http://launchpadlibrarian.net/362321144/libcrypto1.0.0-udeb_1.0.2n-1ubuntu5_amd64.udeb
RUN mkdir _tmp && dpkg -x libcrypto1.0.0-udeb_1.0.2n-1ubuntu5_amd64.udeb _tmp/
RUN cp _tmp/usr/lib/libcrypto.so.1.0.0 bin/amd-64/ && rm -r _tmp

# game port
EXPOSE 16567/udp
# stats port
EXPOSE 27900/udp
# gamespy
EXPOSE 29900/udp
# remote console
EXPOSE 4711/tcp
# prism
EXPOSE 4712/tcp

ENV LD_LIBRARY_PATH="/pr/bin/amd-64"
ENTRYPOINT ["./start_pr.sh"]
CMD ["+noStatusMonitor", "1", "+multi", "1", "+dedicated", "1"]


FROM game as game-with-svctl
ARG SVCTL_VER="0.0.2"

# Install svctl
RUN wget --no-check-certificate https://github.com/sboon-gg/svctl/releases/download/v${SVCTL_VER}/svctl_${SVCTL_VER}_linux_x86_64 -O svctl
RUN chmod +x svctl

COPY scripts/svctl-server.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
