FROM registry.access.redhat.com/ubi9/nodejs-20 AS Builder

# Create app directory
WORKDIR /tmp

USER root
# Copy package files
COPY src/package*.json ./

# Update dependencies
RUN npm update

# Audit and fix vulnerabilities without forcing major updates
RUN npm audit fix || true

# Install dependencies
RUN npm install

# If you are building for production, use ci
RUN npm ci --only=production

FROM registry.access.redhat.com/ubi9/nodejs-20-minimal

WORKDIR /batman

# Bundle app source
COPY --from=Builder --chown=:0 /tmp .

COPY src .

ENV PORT=8080

CMD [ "node", "app.js" ]