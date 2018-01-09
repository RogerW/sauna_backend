# FROM ruby:2.3-alpine

# # Set local timezone
# RUN apk add --update tzdata &&     cp /usr/share/zoneinfo/Europe/London /etc/localtime &&     echo "Europe/London" > /etc/timezone

# # Install your app's runtime dependencies in the container
# RUN apk add --update --virtual runit runtime-deps \
#             postgresql-client nodejs libffi-dev readline sqlite

# # Bundle into the temp directory
# WORKDIR /tmp
# ADD Gemfile* ./

# ENV CT_URL https://github.com/hashicorp/consul-template/archive/v0.19.0.tar.gz
# RUN wget $CT_URL | tar -C /usr/local/bin -zxf -

# RUN apk add --virtual build-deps build-base  \
#             openssl-dev postgresql-dev libc-dev linux-headers \
#             libxml2-dev libxslt-dev readline-dev

# # Copy the app's code into the container
# ENV APP_HOME /app
# COPY . $APP_HOME
# WORKDIR $APP_HOME

# ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
#   BUNDLE_JOBS=2 \
#   BUNDLE_PATH=/bundle

# RUN bundle install --jobs=20

# ONBUILD RUN bundle install --jobs=4 --retry=3

# # Configure production environment variables
# ENV RAILS_ENV=production     RACK_ENV=production

# # Expose port 3000 from the container
# EXPOSE 3000

# # Run puma server by default
# CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]                              


FROM ruby:latest
LABEL maintainer='Stanislav Vorobev <stsvorobev@gmail.com>'

RUN apt-get update && apt-get install -y build-essential \
                                        nodejs libpq-dev unzip \
                                        git \
                                        imagemagick webp\
                                        runit --no-install-recommends && \
                                        rm -rf /var/lib/apt/lists/*

# Install consul-template
# ENV CT_URL https://github.com/hashicorp/consul-template/archive/v0.19.0.tar.gz
# RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -


# ENV BUILD_PACKAGES  bash curl-dev ruby-dev build-base tzdata runtime-deps \
#                     build-deps build-base openssl openssl-dev wget\
#                     postgresql-dev libc-dev linux-headers libxml2-dev \ 
#                     libxslt-dev readline-dev \
#                     nodejs libffi-dev readline curl
# ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

# # Update and install all of the required packages.
# # At the end, remove the apk cache
# RUN apk update && \
#     apk upgrade && \
#     apk add --update --virtual $BUILD_PACKAGES && \
#     apk add --update --virtual $RUBY_PACKAGES && \
#     rm -rf /var/cache/apk/* \
#     cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
#     echo "Europe/London" > /etc/timezone

RUN mkdir /usr/app
WORKDIR /usr/app

# Copy the app's code into the container

COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/

ENV APP_HOME /app
COPY . $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

RUN bundle install --jobs=20

# Configure production environment variables
ENV RAILS_ENV=developmet RACK_ENV=development

# Expose port 3000 from the container
EXPOSE 3000

# Run puma server by default
CMD ["bundle", "exec", "thin", "-C", "config/thin.yml"]                              
