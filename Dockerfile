# Use the official Hugo image (extended version with Sass support)
FROM klakegg/hugo:ext-alpine

# Create a working directory inside the container
WORKDIR /src

# Copy the entire Hugo project into the container
COPY . .

# Expose the port that Hugo's dev server listens on
EXPOSE 1313

# Run the Hugo development server
#   -D   : also serve draft posts (optional)
#   -s   : site root (default is /src, so you can omit it)
CMD ["hugo", "server", "-D", "-p", "1313"]
