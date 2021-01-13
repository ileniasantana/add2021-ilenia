# Vagrant con VirtualBox


# 1. Introducción

Según *Wikipedia*:

Vagrant es una herramienta para la creación
y configuración de entornos de desarrollo virtualizados.

Originalmente se desarrolló para VirtualBox y sistemas de configuración
tales como Chef, Salt y Puppet. Sin embargo desde la versión 1.1 Vagrant es capaz de trabajar con múltiples proveedores, como VMware, Amazon EC2, LXC, DigitalOcean, etc.2

Aunque Vagrant se ha desarrollado en Ruby se puede usar en multitud de
proyectos escritos en otros lenguajes.

> NOTA: Para desarrollar esta actividad se ha utilizado principalmente
la información del enlace anterior publicado por Jonathan Wiesel, el 16/07/2013.

---
# 2. Instalar Vagrant

> Enlaces de interés:
> * [Introducción a Vagrant](https://code.tutsplus.com/es/tutorials/introduction-to-vagrant--cms-25917)
> * [Cómo instalar y configurar Vagrant](http://codehero.co/como-instalar-y-configurar-vagrant/)
> * [Instalar vagrant en OpenSUSE 13.2](http://gattaca.es/post/running-vagrant-on-opensuse/)
> * [Descargar y actualizar vagrant](https://www.vagrantup.com/downloads.html)

* Instalar Vagrant. La instalación vamos a hacerla en una máquina real.
* Hay que comprobar que las versiones de Vagrant y VirtualBox son compatibles entre sí.
    * `vagrant version`, para comprobar la versión actual de Vagrant.

![](./images/2-1-1.png)


    * `VBoxManage -v`, para comprobar la versión actual de VirtualBox.



# 3. Proyecto Celtics

## 3.1 Imagen, caja o box

Existen muchos repositorios desde donde podemos descargar la cajas de Vagrant (Imágenes o boxes). Incluso podemos descargarnos cajas de otros sistemas oprativos desde [VagrantCloud Box List](https://app.vagrantup.com/boxes/search?provider=virtualbox)

> OJO: Sustituir **BOXNAME** por `ubuntu/bionic64`

* `vagrant box add BOXNAME`, descargar la caja que necesitamos a través de vagrant.




* `vagrant box list`, lista las cajas/imágenes disponibles actualmente en nuestra máquina.

![](./images/3-2-1.png)


## 3.2 Directorio

* Crear un directorio para nuestro proyecto. Donde XX es el número de cada alumno:

```
mkdir vagrant16-celtics
cd vagrant16-celtics
```

![](./images/3-2-2.png)


A partir de ahora vamos a trabajar dentro de esta carpeta.
* Crear el fichero `Vagrantfile` de la siguiente forma:
```
Vagrant.configure("2") do |config|
  config.vm.box = "BOXNAME"
  config.vm.hostname = "nombre-alumnoXX-celtics"
  config.vm.provider "virtualbox"
end
```

![](./images/3-2-5.png)


> NOTA: Con `vagrant init` se crea un fichero `Vagrantfile` con las opciones por defecto.

## 3.3 Comprobar

Vamos a crear una MV nueva y la vamos a iniciar usando Vagrant:
* Debemos estar dentro de `vagrant16-celtics`.

* `vagrant up`, para iniciar una nueva instancia de la máquina.


![](./images/3-3-2.png)


* `vagrant ssh`: Conectar/entrar en nuestra máquina virtual usando SSH.


![](./images/3-3-3.png)



![](./images/3-2-6.png)

> **Otros comandos últiles de Vagrant son**:
> * `vagrant suspend`: Suspender la máquina virtual. Tener en cuenta que la MV en modo **suspendido** consume más espacio en disco debido a que el estado de la máquina virtual que suele almacenarse en la RAM se pasa a disco.
> * `vagrant resume` : Volver a despertar la máquina virtual.
> * `vagrant halt`: Apagarla la máquina virtual.
> * `vagrant status`: Estado actual de la máquina virtual.
> * `vagrant destroy`: Para eliminar la máquina virtual (No los ficheros de configuración).

---
# 4. TEORÍA

`NO ES NECESARIO hacer este apartado. Sólo es información.`

A continuación se muestran ejemplos de configuración Vagrantfile que NO ES NECESARIO hacer. Sólo es información.

> Enlace de interés [Tutorial Vagrant. ¿Qué es y cómo usarlo?](https://geekytheory.com/tutorial-vagrant-1-que-es-y-como-usarlo)

**Carpetas compartidas**

La carpeta del proyecto que contiene el `Vagrantfile` es visible
para el sistema el virtualizado, esto nos permite compartir archivos fácilmente entre los dos entornos.

Ejemplos para configurar las carpetas compartidas:
* `config.vm.synced_folder ".", "/vagrant"`: La carpeta del proyecto es accesible desde /vagrant de la MV.
* `config.vm.synced_folder "html", "/var/www/html"`. La carpeta htdocs del proyecto es accesible desde /var/www/html de la MV.

**Redireccionamiento de los puertos**

Cuando trabajamos con máquinas virtuales, es frecuente usarlas para proyectos enfocados a la web, y para acceder a las páginas es necesario configurar el enrutamiento de puertos.

* `config.vm.network "private_network", ip: "192.168.33.10"`: Ejemplo para configurar la red.

**Conexión SSH**: Ejemplo para personalizar la conexión SSH a nuestra máquina virtual:

```
config.ssh.username = 'root'
config.ssh.password = 'vagrant'
config.ssh.insert_key = 'true'
```

Ejemplo para configurar la ejecución remota de aplicaciones gráficas instaladas en la máquina virtual, mediante SSH:
```
config.ssh.forward_agent = true
config.ssh.forward_x11 = true
```

> ¿Cómo podríamos crear una MV Windows usando vagrant en GNU/Linux?

---
# 5. Proyecto Hawks

Ahora vamos a hacer otro proyecto añadiendo redirección de puertos.

## 5.1 Creamos proyecto Hawks

* Crear carpeta `vagrant16-hawks`. Entrar en el directorio.

![](./images/5-1-1.png)

* Crear proyecto Vagrant.
* Configurar Vagrantfile para usar nuestra caja BOXNAME y hostname = "ilenia16-hawks".

* Modificar el fichero `Vagrantfile`, de modo que el puerto 4567 del sistema anfitrión sea enrutado al puerto 80 del ambiente virtualizado.


![](./images/5-2-3.png)



  * `config.vm.network :forwarded_port, host: 4567, guest: 80`

![](./images/5-2-4.png)


* `vagrant ssh`, entramos en la MV


* Instalamos apache2.



![](./images/5-2-6.png)

> NOTA: Cuando la MV está iniciada y queremos recargar el fichero de configuración si ha cambiado hacemos `vagrant reload`.

## 5.2 Comprobar

Para confirmar que hay un servicio a la escucha en 4567, desde la máquina real
podemos ejecutar los siguientes comandos:
* En el HOST-CON-VAGRANT (Máquina real). Comprobaremos que el puerto 4567 está a la escucha.
    * `vagrant port` para ver la redirección de puertos de la máquina Vagrant.


![](./images/5-2-1.png)




* En HOST-CON-VAGRANT, abrimos el navegador web con el URL `http://127.0.0.1:4567`. En realidad estamos accediendo al puerto 80 de nuestro sistema virtualizado.


![](./images/5-2-2.png)

---
# 6. Suministro

Una de los mejores aspectos de Vagrant es el uso de herramientas de suministro. Esto es, ejecutar *"una receta"* o una serie de scripts durante el proceso de arranque del entorno virtual para instalar, configurar y personalizar un sin fin de aspectos del SO del sistema anfitrión.

* `vagrant halt`, apagamos la MV.
* `vagrant destroy` y la destruimos para volver a empezar.

## 6.1 Proyecto Lakers (Suministro mediante shell script)

Ahora vamos a suministrar a la MV un pequeño script para instalar Apache.
* Crear directorio `vagrant16-lakers` para nuestro proyecto.

![](./images/6-1-1.png)

* Entrar en dicha carpeta.

* Crear la carpeta `html` y crear fichero `html/index.html` con el siguiente contenido:


![](./images/6-1-2.png)


* Crear el script `install_apache.sh`, dentro del proyecto con el siguiente
contenido:

#!/usr/bin/env bash

apt-get update
apt-get install -y apache2

![](./images/6-1-3.png)




Incluir en el fichero de configuración `Vagrantfile` lo siguiente:
* `config.vm.hostname = "nombre-alumnoXX-lakers"`
* `config.vm.provision :shell, :path => "install_apache.sh"`, para indicar a Vagrant que debe ejecutar el script `install_apache.sh` dentro del entorno virtual.
* `config.vm.synced_folder "html", "/var/www/html"`, para sincronizar la carpeta exterior `html` con la carpeta interior. De esta forma el fichero "index.html" será visible dentro de la MV.
* `vagrant up`, para crear la MV.

![](./images/6-1-4.png)


    * Podremos notar, al iniciar la máquina, que en los mensajes de salida se muestran mensajes que indican cómo se va instalando el paquete de Apache que indicamos.
* Para verificar que efectivamente el servidor Apache ha sido instalado e iniciado, abrimos navegador en la máquina real con URL `http://127.0.0.1:4567`.


![](./images/6-1-5.png)



## 6.2 Proyecto Raptors (Suministro mediante Puppet)


Se pide hacer lo siguiente.
* Crear directorio `vagrant16-raptors` como nuevo proyecto Vagrant.


![](./images/6-2-1.png)



* Modificar el archivo `Vagrantfile`:


![](./images/6-2-2.png)



> Cuando usamos `config.vm.provision "shell", inline: '"echo "Hola"'`, se ejecuta directamente el comando especificado en la MV. Es lo que llamaremos provisión inline.

* Crear la carpeta `manifests`. OJO: un error muy típico es olvidarnos de la "s" final.
* Crear el fichero `manifests/nombre-del-alumno16.pp`, con las órdenes/instrucciones Puppet necesarias para instalar el software que elijamos (Cambiar `PACKAGENAME` por el paquete que queramos).


![](./images/6-3-4.png)


![](./images/6-2-5.png)


![](./images/6-2-6.png)


> NOTA:
> * El Puppet es un gestor de infraestructura que veremos en profundidad otra actividad.
> * Podemos hacer el suministro con otros gestores de infraestructura como Salt-stack. Consultar enlace  [Salt Provisioner](https://www.vagrantup.com/docs/provisioning/salt.html).

Para que se apliquen los cambios de configuración tenemos 2 caminos:
* **Con la MV encendida**
    1. `vagrant reload`, recargar la configuración.
    2. `vagrant provision`, volver a ejecutar la provisión.
* **Con la MV apagada**:
    1. `vagrant destroy`, destruir la MV.
    2. `vagrant up` volver a crearla.


---
# 7. Proyecto Bulls (Nuestra caja)

En los apartados anteriores hemos descargado una caja/box de un repositorio de Internet, y la hemos personalizado. En este apartado vamos a crear nuestra propia caja/box a partir de una MV de VirtualBox que tengamos.

## 7.1 Preparar la MV VirtualBox

> Enlace de interés:
> * Indicaciones de [¿Cómo crear una Base Box en Vagrant a partir de una máquina virtual](http://www.dbigcloud.com/virtualizacion/146-como-crear-un-vase-box-en-vagrant-a-partir-de-una-maquina-virtual.html) para preparar la MV de VirtualBox.

**Elegir una máquina virtual**

Lo primero que tenemos que hacer es preparar nuestra máquina virtual con una determinada configuración para poder publicar nuestro Box.

* Crear una MV VirtualBox nueva o usar una que ya tengamos.
* Configurar la red en modo automático o dinámico (DHCP).
* Instalar OpenSSH Server en la MV.

**Crear usuario con aceso SSH**

Vamos a crear el usuario `vagrant`. Esto lo hacemos para poder acceder a la máquina virtual por SSH desde fuera con este usuario. Y luego, a este usuario le agregamos una clave pública para autorizar el acceso sin clave desde Vagrant. Veamos cómo:

* Ir a la MV de VirtualBox.
* Crear el usuario `vagrant`en la MV.
    * `su`
    * `useradd -m vagrant`


![](./images/7-1-1.png)



* Poner clave "vagrant" al usuario vagrant.

* Poner clave "vagrant" al usuario root.


![](./images/7-1-4.png)



* Configuramos acceso por clave pública al usuario `vagrant`:
* `mkdir -pm 700 /home/vagrant/.ssh`, creamos la carpeta de configuración SSH.

* `wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys`, descargamos la clave pública.


![](./images/7-1-5.png)



    * `chmod 0600 /home/vagrant/.ssh/authorized_keys`, modificamos los permisos de la carpeta.
    * `chown -R vagrant /home/vagrant/.ssh`, modificamos el propietario de la carpeta.

![](./images/7-1-7.png)


> NOTA:
> * Podemos cambiar los parámetros de configuración del acceso SSH. Mira la teoría...
> * Ejecuta `vagrant ssh-config`, para averiguar donde está la llave privada para cada máquina.

**Sudoers**

Tenemos que conceder permisos al usuario `vagrant` para que pueda hacer tareas privilegiadas como configurar la red, instalar software, montar carpetas compartidas, etc. Para ello debemos configurar el fichero `/etc/sudoers` (Podemos usar el comando `visudo`) para que no nos solicite la password de root, cuando realicemos estas operaciones con el usuario `vagrant`.

* Añadir `vagrant ALL=(ALL) NOPASSWD: ALL` al fichero de configuración `/etc/sudoers`. Comprobar que no existe una linea indicando requiretty si existe la comentamos.


![](./images/7-1-8.png)



**Añadir las VirtualBox Guest Additions**

* Debemos asegurarnos que tenemos instalado las VirtualBox Guest Additions con una versión compatible con el host anfitrión. Comprobamos:
```
root@hostname:~# modinfo vboxguest |grep version
version:        6.0.24
```
* Apagamos la MV.

## 7.2 Crear caja Vagrant

Una vez hemos preparado la máquina virtual ya podemos crear el box.

* Vamos a crear una nueva carpeta `vagrant16-bulls`, para este nuevo proyecto vagrant.


![](./images/7-2-8.png)


* `VBoxManage list vms`, comando de VirtualBox que muestra los nombres de nuestras MVs. Elegir una de las máquinas (VMNAME).

![](./images/7-2-1.png)


* Nos aseguramos que la MV de VirtualBox VMNAME está apagada.
* `vagrant package --base VMNAME --output nombre-alumno16.box`, parar crear nuestra propia caja.


![](./images/7-2-2.png)




* Comprobamos que se ha creado el fichero `nombre-alumnoXX.box` en el directorio donde hemos ejecutado el comando.



![](./images/7-2-4.png)


* `vagrant box add nombre-alumno/bulls nombre-alumno16.box`, añadimos la nueva caja creada por nosotros, al repositorio local de cajas vagrant de nuestra máquina.


![](./images/7-2-2.png)


* `vagrant box list`, consultar ahora la lista de cajas Vagrant disponibles.


![](./images/7-2-10.png)


## 7.3 Usar la nueva caja

* Crear un nuevo fichero Vagrantfile para usar nuestra caja.
* Levantamos una nueva MV a partir del Vagranfile.
* Nos debemos conectar sin problemas (`vagant ssh`).

Cuando terminemos la práctica, ya no nos harán falta las cajas (boxes) que tenemos cargadas en nuestro repositorio local.
Por tanto, podemos borrarlas para liberar espacio en disco:

* `vagrant box list`, para consultar las cajas disponibles.
* `vagrant box remove BOXNAME`, para eliminar una caja BOXNAME de nuestro repositorio local.
