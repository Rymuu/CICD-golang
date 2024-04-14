# Étape de construction
FROM golang:alpine AS builder

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
FROM scratch

# Copier le binaire compilé depuis l'étape de construction
COPY --from=builder /app/main .

# Définir la commande pour exécuter l'exécutable
CMD ["./main"]
