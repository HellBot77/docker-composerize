FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/composerize/composerize.git && \
    cd composerize && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node AS build

WORKDIR /composerize
COPY --from=base /git/composerize .
RUN cd packages/composerize-website && \
    yarn && \
    export NODE_ENV=production && \
    yarn build

FROM pierrezemb/gostatic

COPY --from=build /composerize/packages/composerize-website/build /srv/http
EXPOSE 8043
