# Motivación

Actualmente trabajo con un servidor que utiliza RoadRunner, PHP y gRPC. La ideaes ver como motar un proyecto desde cero.

## Primer paso: Servidor HTTP

He ido a la página de RoadRunner y he seguido la documentación para levantar un servidor PHP con RoadRunner. El uso de gRPC será más adelante, es un adicional, está en otra parte de la documentación.

Hago uso de _Docker compose_. No dice nada al respecto, pero suele ser lo habitual en los proyectos con los que trabajo. Tambien un archivo _Makefile_.

El archivo _psr-worker.php_ hace uso de librerías que no tengo. Supongo que la documentación sobreentiende que usarás Composer, así que creo un archivo composer.json con todo lo necesario.

Composer me ha dado problemas, entiendo que la imagen tendrá que tener las dependencias de cara a un despliegue, así que instalo Composer en Dockerfile e instalo las dependencias, pero al levantar el proyecto con _Docker compose_ la carpeta _/code/vendor_ desaparece, sobreescribe el directorio con el contenido del repositorio. Lo soluciono añadiendo a Makefile una instalación de Composer utilizando una imagen de Docker de Composer, justo antes de hacer _docker compose up_.

Tambien he tenido que instalar el comando _zip_ y la extensión _sockets_ de PHP. Todo en Dockerfile.

Por fin levanto el servidor, lo veo en _localhost:8080_, como indicaba _.rr.yaml_, cuyo puerto he tenido que poner tambien en _compose.yaml_.

## Segundo paso: Protocol Buffers

La documentación habla de ejecutar un comando para descargar un plugin de Protocol Buffers para PHP. Yo lo he movido a _/opt_ para que no se sobreescriba como pasaba con la carpeta _vendor_.

Cuando he ido a compilar el archivo _.proto_ me he dado cuenta de que no tengo instalado _protoc_, así que lo instalo directamente con APT.

He conseguido compilar el archivo _.proto_ y me ha creado los archivos de PHP.

## Tercer paso: Servidor gRPC

Siguiendo la documentación, creo el servicio que implementa la interfaz del servicio, esta interfaz se ha creado al compilar el archivo _.proto_.

Ya no utilizaremos psr-worker.php, ahora utilizaremos grpc-worker.php. Este cambio implica modificar el archivo .rr.yaml y el archivo compose.yaml, gRPC utiliza el puerto 9001.

Levanto de nuevo el servidor, veo que esta corriendo en el puerto 9001.

He conseguido hacer peticiones usando _grpc-client-cli_, el cliente que viene en la documentación de RoadRunner.

```terminal
root@app:/code# grpc-client-cli --proto /code/proto/ localhost:9001

? Choose a service: Greeter.Greeter

? Choose a method: SayHello

Message json (type ? to see defaults): {"name": "Eliecer"}
{
  "message": "Hello Eliecer!"
}
```

He intentado usar Postman para hacer peticiones al servidor, pero no lo he conseguido.

## Cuarto paso: Cliente gRPC

Ahora quiero lanzar peticiones al servidor gRPC utilizando un cliente, como lo haría en otro proyecto PHP. La documentación de RoadRunner no dice nada al respecto.

Leyendo en grpc.io, se deduce que la compilación debería crear un cliente gRPC. Descubro que hay que instalar otro plugin más, el que genera el cliente gRPC.

La cosa se complica porque hay que descargar su código fuente (https://github.com/grpc/grpc) y compilarlo.

Conclusión:
* Ambos plugin son capaces de generar la petición y la respuesta.
* El plugin de _protoc-gen-php-grpc_ generar la interfaz que usará el servicio.
* El plugin de _protoc-gen-grpc_ generar el cliente gRPC.
