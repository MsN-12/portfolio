FROM klakegg/hugo:ext-alpine

# Working directory inside the container
WORKDIR /src

# Copy the entire Hugo project into the container
COPY . .

# Expose the port that Hugo will listen on
EXPOSE 80

# Run the Hugo dev server with the exact flags you want
CMD ["hugo", "server", "--buildDrafts", "--bind", "0.0.0.0", "--port", "8080"]
