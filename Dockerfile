# Use a lightweight Debian base image
FROM debian:bullseye-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

# Add /usr/games to PATH (for cowsay & fortune)
ENV PATH="/usr/games:${PATH}"

# Set working directory
WORKDIR /app

# Copy the script into the container
COPY wisecow.sh /app/wisecow.sh

# Make it executable
RUN chmod +x /app/wisecow.sh

# Expose the service port
EXPOSE 4499

# Run the script
CMD ["/app/wisecow.sh"]
