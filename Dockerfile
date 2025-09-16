# Usamos una imagen de alpine linux que hace que sea realmente ligero el cargar node, elugar de hacer node:22 (que se trae desde debian) por ejemplo
FROM node:22-alpine

# Definimos el working directory
WORKDIR /src/app

# Copiamos package.json y package-lock.json al working directory
COPY package*.json ./

# Instala las dependencias necesarias
RUN npm install --production

# Copia lo que ya tiene
COPY . .

# Exponemos el puerto 3000
EXPOSE 3000

# Define the command to run your app
CMD ["node", "index.js"]
