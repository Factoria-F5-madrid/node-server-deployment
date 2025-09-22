# Cómo crear una imagen de Docker para esta aplicación

## ¿Qué es un Dockerfile?

Un `Dockerfile` es un archivo de texto que contiene todas las instrucciones necesarias para construir una imagen de Docker. Piensa en ello como una receta para crear el entorno y la configuración de tu aplicación.

## Contenido del Dockerfile

Aquí está el desglose de cada comando en el `Dockerfile` que hemos creado:

```dockerfile
# Usa una imagen oficial de Node.js como imagen base
FROM node:22-alpine

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

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
```

### Explicación de los comandos:

1.  **`FROM node:22-alpine`**: Comienza con una imagen base oficial de Node.js. La etiqueta `:22-alpine` se refiere a una versión específica de Node (versión 18) que es ligera (`alpine`), lo que hace que la imagen final sea más pequeña.

2.  **`WORKDIR /usr/src/app`**: Establece el directorio de trabajo dentro del contenedor. Todos los comandos siguientes se ejecutarán en este directorio.

3.  **`COPY package*.json ./`**: Copia los archivos `package.json` y `package-lock.json` al directorio de trabajo (`/usr/src/app`). Se copian primero para aprovechar el sistema de caché de Docker. Si estos archivos no cambian, Docker no volverá a instalar las dependencias en futuras construcciones.

4.  **`RUN npm install --production`**: Ejecuta el comando `npm install` para descargar e instalar las dependencias necesarias para la aplicación. El flag `--production` asegura que solo se instalen las dependencias de producción y no las de desarrollo.

5.  **`COPY . .`**: Copia todos los archivos restantes del proyecto al directorio de trabajo en el contenedor.

6.  **`EXPOSE 5000`**: Informa a Docker que el contenedor escuchará en el puerto 5000 en tiempo de ejecución. Este es el puerto en el que se ejecuta la aplicación Node.js.

7.  **`CMD ["npm", "start"]`**: Especifica el comando que se ejecutará cuando se inicie el contenedor. En este caso, inicia la aplicación ejecutando `node index.js`.

## Cómo construir y ejecutar la imagen de Docker

Para construir la imagen, abre una terminal en el directorio del proyecto (donde se encuentra el `Dockerfile`) y ejecuta:

```sh
docker build -t todo-server-app .
```

Para ejecutar la imagen en un contenedor:

```sh
docker run -p 3000:3000 todo-server-app
```

Ahora, tu aplicación debería estar corriendo y accesible en `http://localhost:3000`.

## Gestión de la aplicación con Docker Compose

Para simplificar la gestión de la aplicación y la base de datos, hemos añadido un archivo `docker-compose.yml`. Este archivo permite definir y ejecutar aplicaciones multi-contenedor con un solo comando.

### Contenido del `docker-compose.yml`

El archivo define dos servicios:

1.  **`app`**:
    *   Construye la imagen de Docker a partir del `Dockerfile` en el directorio actual.
    *   Mapea el puerto `3000` del contenedor al puerto `3000` de tu máquina.
    *   Establece las variables de entorno necesarias, incluyendo la cadena de conexión a la base de datos MongoDB, que apunta al servicio `mongo`.
    *   Depende del servicio `mongo`, lo que asegura que el contenedor de la base de datos se inicie antes que el de la aplicación.

2.  **`mongo`**:
    *   Utiliza la imagen oficial de `mongo` de Docker Hub.
    *   Crea un volumen llamado `mongo-data` para persistir los datos de la base de datos, de modo que no se pierdan si el contenedor se detiene o se reinicia.

### Cómo usar Docker Compose

Con Docker Compose, puedes levantar todo el entorno de desarrollo con un único comando.

**Para iniciar la aplicación y la base de datos:**

Abre una terminal en el directorio del proyecto y ejecuta:

```sh
docker-compose up
```

Docker Compose construirá la imagen de la aplicación (si no ha sido construida antes) y luego iniciará los contenedores para la `app` y `mongo`. Tu aplicación estará disponible en `http://localhost:3000`.

Para ejecutar los contenedores en segundo plano (detached mode), puedes usar:

```sh
docker-compose up -d
```
o

```sh
docker-compose up --build
```

**Para detener la aplicación y la base de datos:**

Para detener y eliminar los contenedores, redes y volúmenes creados, ejecuta:

```sh
docker-compose down
```

Esto detendrá los contenedores de la aplicación y la base de datos. Si quieres eliminar también el volumen de datos de la base de datos (¡cuidado, esto borrará tus datos!), puedes usar:

```sh
docker-compose down -v
```

## Cómo subir la imagen a Docker Hub

Una vez que hayas construido tu imagen de Docker, puedes subirla a [Docker Hub](https://hub.docker.com/) para compartirla con otros o para desplegarla en diferentes entornos como render.

### Paso 1: Crear una cuenta en Docker Hub

Si aún no tienes una cuenta en Docker Hub, deberás crear una:

1.  Ve a [https://hub.docker.com/signup](https://hub.docker.com/signup).
2.  Elige un nombre de usuario (Docker ID), proporciona una dirección de correo electrónico y una contraseña.
3.  Completa el registro y verifica tu dirección de correo electrónico.

Tu **Docker ID** será tu espacio de nombres en Docker Hub, donde se almacenarán tus imágenes.

### Paso 2: Iniciar sesión en Docker Hub desde la terminal

Abre tu terminal y ejecuta el siguiente comando para iniciar sesión con tu cuenta de Docker Hub. Se te pedirá tu nombre de usuario y contraseña.

```sh
docker login
```

### Paso 3: Re-etiquetar (tag) la imagen de Docker

Antes de poder subir la imagen, necesitas etiquetarla con tu nombre de usuario de Docker Hub. Esto se hace para que Docker sepa a qué repositorio debe subir la imagen.

Usa el comando `docker tag` para darle un nuevo nombre a tu imagen. Reemplaza `<tu-usuario-de-dockerhub>` con tu Docker ID.

```sh
docker tag todo-server-app <tu-usuario-de-dockerhub>/todo-server-app:latest
```

- `todo-server-app`: Es el nombre actual de la imagen que construiste.
- `<tu-usuario-de-dockerhub>/todo-server-app:latest`: Es el nuevo nombre, que incluye tu usuario y la etiqueta de la versión (`latest`).

### Paso 4: Subir la imagen a Docker Hub

Ahora que la imagen está correctamente etiquetada, puedes subirla a tu repositorio en Docker Hub con el comando `docker push`.

```sh
docker push <tu-usuario-de-dockerhub>/todo-server-app:latest
```

Una vez que el comando termine, tu imagen estará disponible en tu perfil de Docker Hub, en `https://hub.docker.com/r/<tu-usuario-de-dockerhub>/todo-server-app`.

### Subir imagen a Render
1. Creamos un servicio en Render

<img width="1462" height="810" alt="image" src="https://github.com/user-attachments/assets/9338e4af-83ae-4897-8d00-24b8e324359b" />


2. Agregaos la imagen de nuestro dockerhub

<img width="1327" height="684" alt="image" src="https://github.com/user-attachments/assets/ae425511-112f-4983-b7d3-8e422f509082" />


Ve a tu hub en docker hub, para eso, primero en cuentra la imágen con la letra de tu nombre o username, navega a tu perfil y allí verás esta vista:

<img width="1891" height="803" alt="image" src="https://github.com/user-attachments/assets/9423d218-1749-4a06-86f8-b6588b8319f9" />

entramos a nuestra imagen:

<img width="1883" height="718" alt="image" src="https://github.com/user-attachments/assets/5c2aa70c-e98c-4fff-96bb-db82b489be19" />


Buscamos la vista pública:

<img width="1928" height="768" alt="image" src="https://github.com/user-attachments/assets/bc54f59f-d9ff-4ac0-9e2d-adcb7dd1d947" />

copiamos la url:

<img width="1677" height="892" alt="image" src="https://github.com/user-attachments/assets/ffc76304-34b2-4b4b-bd9b-7ba5b42bc8bb" />

Agregamos nuestra imagen:

<img width="1898" height="861" alt="image" src="https://github.com/user-attachments/assets/2c813a8b-2124-4217-821b-7cf418a7d35b" />

3. configuramos render:

Mantenemos las configuraciones, pero si quieres puedes cambiar el combre:

<img width="1872" height="857" alt="image" src="https://github.com/user-attachments/assets/0fb63772-fc83-4f35-9669-9be923846048" />

Bajamos un poco más, y seleccionamos el plan gratuito:

<img width="1712" height="800" alt="image" src="https://github.com/user-attachments/assets/10d7d962-3ae1-41dc-b2c7-e876d8ac9081" />

Agregamos nuestras variables de entorno:

<img width="1823" height="484" alt="image" src="https://github.com/user-attachments/assets/b3c73a82-4fef-4180-bf3f-304f37c0668d" />
