# Step : base
FROM docker:cli

# Step : Install zsh
RUN apk update && \
  apk add \
    bash \
    zsh

## Setting container startup
ENTRYPOINT ["/bin/zsh"]
