# Motivación

Actualmente trabajo con un servidor que utiliza RoadRunner, PHP y gRPC. La idea es ver como motar un proyecto desde cero.

## Primer paso: Servidor HTTP

He ido a la página de RoadRunner y he seguido la documentación para levantar un servidor PHP con RoadRunner. El uso de gRPC será más adelante, es un adicional, está en otra parte de la documentación.

Hago uso de _Docker compose_. No dice nada al respecto, pero suele ser lo habitual en los proyectos con los que trabajo. Tambien un archivo _Makefile_.

El archivo _psr-worker.php_ hace uso de librerías que no tengo. Supongo que la documentación sobreentiende que usarás Composer, así que creo un archivo composer.json con todo lo necesario.

Composer me ha dado problemas, entiendo que la imagen tendrá que tener las dependencias de cara a un despliegue, así que instalo Composer en Dockerfile e instalo las dependencias, pero al levantar el proyecto con _Docker compose_ la carpeta _/code/vendor_ desaparece, sobreescribe el directorio con el contenido del repositorio. Lo soluciono añadiendo a Makefile una instalación de Composer utilizando una imagen de Docker de Composer, justo antes de hacer _docker compose up_.

Tambien he tenido que instalar el comando _zip_ y la extensión _sockets_ de PHP. Todo en Dockerfile.

Por fin levanto el servidor, lo veo en _localhost:8080_, como indicaba _.rr.yaml_, cuyo puerto he tenido que poner tambien en _compose.yaml_.
