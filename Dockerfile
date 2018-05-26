FROM alpine
RUN apk --no-cache add openvpn
ADD entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
VOLUME ["/etc/openvpn/"]
CMD ["openvpn", "--config", "/etc/openvpn/server.cfg"]
