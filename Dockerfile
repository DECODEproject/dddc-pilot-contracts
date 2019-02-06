FROM decodeproject/zenroom

COPY src /src
COPY test /test

ENTRYPOINT ["sh", "/test/run.sh"]
