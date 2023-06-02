LABEL org.opencontainers.image.source=https://github.com/okfn-brasil/minutas
# -----------------------------------------------------------------------------+
# Compile the assets in a layer with node, different from the final container.
# This will allow for reduced image size because we don't need node in
# production.
# -----------------------------------------------------------------------------+
FROM docker.io/ruby:3.0.2-buster as assets_precompile

# Absolute first step here is to have the correct version of node installed
ENV NODE_VERSION 16.19.0
RUN curl https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz -o /tmp/node.tar.gz && \
  tar -xzf /tmp/node.tar.gz -C /tmp && \
  cp -R /tmp/node-v$NODE_VERSION-linux-x64/bin/* /usr/local/bin/ && \
  cp -R /tmp/node-v$NODE_VERSION-linux-x64/include/* /usr/local/include/ && \
  cp -R /tmp/node-v$NODE_VERSION-linux-x64/lib/* /usr/local/lib/ && \
  cp -R /tmp/node-v$NODE_VERSION-linux-x64/share/* /usr/local/share/ && \
  node --version

RUN mkdir /app
WORKDIR /app

# Ensure correct version of bundler
RUN gem install -N bundler:2.3.20

# First copy bundle-related files so we can install dependencies and reuse this
# cache layer
COPY .ruby-version /app/
COPY Gemfile /app/
COPY Gemfile.lock /app/

# Now install dependencies
ENV BUNDLE_WITHOUT=development:test
RUN bundle install

# Copy the node manifest and its lock file and install node dependencies.
COPY package.json /app/
COPY yarn.lock /app/
RUN npm install -g yarn
RUN yarn install

# Copy the parts of the app relevant to the compilation of the frontend
COPY app/ /app/app/
COPY lib/ /app/lib/
COPY bin/ /app/bin/
COPY config/ /app/config/
COPY Rakefile /app/
COPY ./postcss.config.js /app/

# Finally build the static assets for production
ENV RAILS_ENV production
ENV NODE_ENV production
# the variable bellow is not strictly necessary except that from decidim 0.27.3
# the assets:precompile step fails without this
ENV SECRET_KEY_BASE asdf
RUN bundle exec rake assets:precompile

# -----------------------------------------------------------------------------+
# Build the actual container
# -----------------------------------------------------------------------------+
FROM docker.io/ruby:3.0.2-buster

# necessary packages
RUN apt-get update \
    && apt-get install -y --fix-missing --no-install-recommends \
        libpq-dev \
        libicu-dev \
        imagemagick \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# workdir
RUN mkdir /app
WORKDIR /app

# bundler version
RUN gem install -N bundler:2.3.20

# install dependencies in an initial step so this cache is used during the
# development cycle: changes to the code without changes in the dependencies
# don't trigger a bundle install.
COPY .ruby-version /app/
COPY Gemfile /app/
COPY Gemfile.lock /app/

ENV BUNDLE_WITHOUT=development:test
RUN bundle install

# Copy pre-built static assets
COPY --from=assets_precompile /app/public/decidim-packs /app/public/decidim-packs
COPY --from=assets_precompile /app/public/sw.js /app/public/
COPY --from=assets_precompile /app/public/sw.js.br /app/public/
COPY --from=assets_precompile /app/public/sw.js.gz /app/public/
COPY --from=assets_precompile /app/public/sw.js.map /app/public/
COPY --from=assets_precompile /app/public/sw.js.map.br /app/public/
COPY --from=assets_precompile /app/public/sw.js.map.gz /app/public/

ENV RAILS_ENV production
ENV PORT 3000
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY --chmod=755 scripts/containers/entrypoint.sh /app/scripts/
COPY lib/ /app/lib/
COPY bin/ /app/bin/
COPY config/ /app/config/
COPY ./config.ru /app/
COPY Rakefile /app/
COPY db/ /app/db/
COPY app/ /app/app/

ENTRYPOINT ["./scripts/entrypoint.sh"]
