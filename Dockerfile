ARG     FLUENTD_VERSION=1.18.0-1.0
ARG     IPERF3_VERSION=3.18

FROM    ghcr.io/dockerapp/iperf3:${IPERF3_VERSION} AS iperf3

FROM    fluentd:v${FLUENTD_VERSION}

ENV     VLOGS_URL=http://127.0.0.1:9428
ENV     IPERF_RUN_INTERVAL=5s

COPY    fluentd.conf /etc/fluentd.conf

COPY    --from=iperf3 /iperf3 /usr/bin/iperf3

USER    root

RUN     gem install fluent-plugin-rewrite-tag-filter

USER    fluent

ENTRYPOINT [ "/usr/bin/fluentd", "-c", "/etc/fluentd.conf", "-vv" ]
