FROM debian:10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y --no-install-recommends xmlstarlet 

COPY scripts/update.sh /update.sh
RUN chmod +x /update.sh

ENTRYPOINT ["./update.sh"]
CMD ["/pr"]
