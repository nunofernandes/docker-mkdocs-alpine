FROM alpine
RUN apk --no-cache upgrade
RUN apk add --no-cache               \
      curl wget make git jq rsync    \
      python2 py3-pip python3        \
      nodejs yarn python3-dev        \
      nginx gcc musl-dev             \
      perl perl-path-tiny            \
      perl-yaml-libyaml perl-getopt-long

## Add the MermaidJS utility
RUN yarn add mermaid

## Add cpanminus and install perl deps
RUN curl -L https://cpanmin.us | perl - App::cpanminus  \
 && cpanm -q -n Pod::Markdown JSON::MaybeXS MIME::Types \
 && rm -rf "$HOME/.cpanm"

## Install the mkdocs system
RUN pip3 install mkdocs pygments                                                  \
    mkdocs-alabaster mkdocs-bootstrap mkdocs-cinder mkdocs-material mkdocs-nature \
    mkdocs-rtd-dropdown                                                           \
    mkdocs-safe-text-plugin                                                       \
    mkdocs-exclude                                                                \
 && rm -rf "$HOME/.cache"

## Install template fixes
## This mostly deal with hidding navigation elements if they start with a _
## See https://github.com/mkdocs/mkdocs/issues/699#issuecomment-157691209
## for details
COPY fixes/material-nav.html /usr/lib/python2.7/site-packages/material/partials/nav.html

## Copy our scripts and make sure they are executable
COPY cmds/ /usr/local/bin/
COPY cmds/cmds.pl /cmds
RUN chmod 555 /cmds /usr/local/bin/*

## Generate a sample wiki
COPY test_site/ /test/
RUN cd /test                                       \
 && mv nginx.conf /etc/nginx/                      \
 && doku /test /test                               \
 && mkdocs build --site-dir /usr/share/nginx/html

## Define our Entrypoint script
ENTRYPOINT ["/cmds"]

## The default command for the entrypoint script, show the help message
CMD ["help"]
