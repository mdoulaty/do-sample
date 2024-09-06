# This is a standard Dockerfile for building a .net core app.
# It is a multi-stage build: the first stage compiles the source into a binary, and
# the second stage copies only the published package into a dotnet runtime image.

# -- Stage 1 -- #
# Compile the app.
FROM mcr.microsoft.com/dotnet/sdk:8.0 as builder
WORKDIR /app
# The build context is set to the directory where the repo is cloned.
# This will copy all files in the repo to /app inside the container.
# If your app requires the build context to be set to a subdirectory inside the repo, you
#   can use the source_dir app spec option, see: https://www.digitalocean.com/docs/app-platform/references/app-specification-reference/
COPY . .

RUN dotnet publish HelloWorld

# -- Stage 2 -- #
# Create the final environment with the compiled package.
FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /root/
# Copy the published package from the builder stage and set it as the default command.
COPY --from=builder /app/HelloWorld/bin/Release/net8.0/publish/ /app
CMD ["/app/HelloWorld"]