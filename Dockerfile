ARG  BASE_IMAGE=ruby:3.0.3-alpine3.15
FROM ${BASE_IMAGE}

ENV VIPSVER 8.12.2
RUN apk update && apk upgrade &&\
    apk add --update --no-cache build-base glib-dev libexif-dev expat-dev tiff-dev jpeg-dev libgsf-dev git rsync lftp openssh &&\
    rm -rf /var/cache/apk/*

RUN wget -O ./vips-$VIPSVER.tar.gz https://github.com/libvips/libvips/releases/download/v$VIPSVER/vips-$VIPSVER.tar.gz

RUN tar -xvzf ./vips-$VIPSVER.tar.gz && cd vips-$VIPSVER && ./configure && make && make install

COPY ./ /photo-stream 

WORKDIR /photo-stream

RUN ruby -v && gem install bundler jekyll &&\
    bundle config --local build.sassc --disable-march-tune-native &&\
    bundle install

EXPOSE 4000

ENTRYPOINT bundle exec jekyll serve --host 0.0.0.0
