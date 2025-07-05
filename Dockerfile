FROM eclipse-temurin:17-jdk AS build-env
SHELL ["/bin/bash", "--login", "-i", "-c"]

# Install node + NVM (optional, if you also need Node/Tailwind)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN . $HOME/.nvm/nvm.sh
RUN nvm install 22

WORKDIR /usr/app

# Copy Maven wrapper and pom
COPY .mvn .mvn
COPY mvnw pom.xml ./

# Copy Node package files
COPY package.json package-lock.json ./

# Install Node dependencies
RUN npm install

# Resolve Maven dependencies
RUN ./mvnw dependency:resolve

# Copy the rest of your source code
COPY . .

# Build the WAR
RUN --mount=type=cache,target=/root/.m2 ./mvnw clean package

# ===== Final stage (GlassFish) =====
FROM ghcr.io/eclipse-ee4j/glassfish
# Optionally copy the WAR here if you want the WAR baked into the image:
COPY --from=build-env /usr/app/target/*.war /opt/glassfish7/
