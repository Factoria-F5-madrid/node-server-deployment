# Usa una imagen oficial de Node.js como imagen base
FROM node:22-alpine

# Establece el directorio de trabajo en el contenedor
WORKDIR /src/app

# Copia package.json y package-lock.json al directorio de trabajo
COPY package*.json ./

# Instala las dependencias de producción
RUN npm install --production

# Copia el resto del código fuente de la aplicación
COPY . .

# Expone el puerto 5000 para que sea accesible desde fuera del contenedor
EXPOSE 3000

# Define el comando para ejecutar la aplicación
CMD ["node", "index.js"]