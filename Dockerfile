FROM decodeproject/zenroom:latest

COPY src /src
COPY test /test

ENTRYPOINT ["sh", "/test/run.sh"]
