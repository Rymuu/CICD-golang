# Étape de construction
FROM golang:alpine AS builder

# Installer git, nécessaire pour les dépendances de modules Go
RUN apk add --no-cache git

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers go.mod et go.sum et télécharger les dépendances
COPY go.mod go.sum ./
RUN go mod download

# Copier le code source
COPY . .

# Compiler l'application sans CGo pour créer un binaire statique
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Étape d'exécution
FROM alpine

# Installer bash
RUN apk add --no-cache bash

# Copier le binaire compilé depuis l'étape de construction
COPY --from=builder /app/main .

# Définir la commande pour exécuter l'exécutable
CMD ["./main","-port=$PORT"]
