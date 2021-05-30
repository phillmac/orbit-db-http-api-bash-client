FROM bash:latest

RUN apk add curl bats jq file coreutils git \
 && git clone https://github.com/docopt/docopts.git \
 && cd docopts \
 && ./get_docopts.sh \
 && cp docopts docopts.sh /usr/local/bin \
 && apk del file coreutils git \
 && cd .. && rm -rf ./docopts

COPY ./tests /tests
COPY ./src /src

RUN ln -s /src/scripts/load_functions.sh /usr/local/bin/lf
