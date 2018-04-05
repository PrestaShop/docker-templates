FROM quetzacoalt/docker-internal-images:1.7

COPY import-dump-and-run.sh /tmp/
RUN chmod a+x /tmp/import-dump-and-run.sh

ENV PS_DOMAIN localhost
ENV DUMP_SQL_FOLDER /tmp/bdd

CMD ["/tmp/import-dump-and-run.sh"]
