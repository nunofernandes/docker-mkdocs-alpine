FROM alpine

RUN apk add --no-cache python py2-pip perl curl git

## Install the mkdocs system                       
RUN pip install mkdocs                                                            \
    mkdocs-alabaster mkdocs-bootstrap mkdocs-cinder mkdocs-material mkdocs-nature \
    mkdocs-safe-text-plugin

## Define our Entrypoint script
COPY cmds.pl /cmds
RUN chmod 555 /cmds
ENTRYPOINT ["/cmds"]

## The default command for the entrypoint script, show the help message
CMD ["help"]