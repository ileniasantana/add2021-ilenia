# Acceso remoto SSH

# 1. Preparativos

Vamos a necesitar las siguientes MVs:

| Función | Sistema Operativo     | IP        | Hostname |
| ------- |--------------------- | --------- | --------- |
| Un servidor SSH| GNU/Linux OpenSUSE (Sin entorno gráfico)| 192.168.1.25 | server16g |
| Un cliente SSH | GNU/Linux OpenSUSE | 192.168.1.30 y 172.19.99.220 | client16g |
| Un servidor SSH | Windows Server| 172.19.99.100 | server16g |
| Un cliente SSH | Windows | 192.168.1.31 y 172.19.99.200 | cliente16w |

## 1.1 Servidor SSH

* Añadir en `/etc/hosts` los equipos `client16g2` y `clientXXw` (Donde XX es el puesto del alumno).

Archivo de configuración del servidor.
![](./images/archivoconfiguración.png)


Se han realizado todas las comprobaciones y, vemos que todo funciona correctamente.

Crear los siguientes usuarios en `server16g`:
* santana1
* santana2
* santana3
* santana4

## 1.2 Cliente GNU/Linux

* Configurar el cliente1 GNU/Linux con los siguientes valores:
    * SO OpenSUSE
    * [Configuración de las MV's](../global/configuracion/opensuse.md)
    * Nombre de equipo: `client16g2`
* Añadir en `/etc/hosts` los equipos serverXXg, y clientXXw.
* Comprobar haciendo ping a ambos equipos.

Archivo de configuración cliente OpenSUSE.

![](./images/1-5.png)


## 1.3 Cliente Windows

* Instalar software cliente SSH en Windows. Para este ejemplo usaremos [PuTTY](http://www.putty.org/).

* Vamos a configurar el cliente2 Windows con los siguientes valores:
    * SO Windows
    * Nombre de equipo: `cliente16w`
* Añadir en `C:\Windows\System32\drivers\etc\hosts` los equipos server16 y cliente16g1.
* se ha realizado ping a ambas máquinas server16 y cliente opensuse con éxito.

Archivo de configuración de Windows cliente.
![](./images/13-2.png)



# 2 Instalación del servicio SSH

* Instalar el servicio SSH en la máquina server16g. Por comandos o entorno gráfico.

![](./images/2-1.png)



## 2.1 Comprobación

* Desde el propio servidor, verificar que el servicio está en ejecución.
    * `systemctl status sshd`, esta es la forma habitual de comprobar los servicios.
    * `ps -ef|grep sshd`, esta es otra forma de comprobarlo mirando los procesos del sistema.
    * `sudo lsof -i:22`, comprobar que el servicio está escuchando por el puerto 22.


  ![](./images/2-1-2.png)




## 2.2 Primera conexión SSH desde cliente GNU/Linux

* Ir al cliente `client16g2`.
* `ping server16g`, comprobar la conectividad con el servidor.
* `nmap -Pn serverXXg`, comprobar los puertos abiertos en el servidor (SSH debe estar open). Debe mostrarnos que el puerto 22 está abierto. Debe aparecer una línea como  "22/tcp open ssh". Si esto falla, debemos comprobar en el servidor la configuración del cortafuegos.

![](./images/2-2.png)

Vamos a comprobar el funcionamiento de la conexión SSH desde cada cliente usando el usuario *santana1*.
* Desde el cliente GNU/Linux nos conectamos mediante `ssh santana1@192.168.1.25`. Capturar imagen del intercambio de claves que se produce en el primer proceso de conexión SSH.

![](./images/2-2-1.png)









* Comprobar contenido del fichero `$HOME/.ssh/known_hosts` en el equipo cliente. OJO el prompt nos indica en qué equipo estamos.

![](./images/2-2-2-2.png)


* Es la clave de identificación de la máquina del servidor.
* A partir de ahora cuando nos conectamos sólo nos pide la contraseña:
* Una vez llegados a este punto deben de funcionar correctamente las conexiones SSH desde el cliente. Comprobarlo.

![](./images/2-2-2.png)

## 2.3 Primera conexión SSH desde cliente Windows

* Desde el cliente Windows nos conectamos usando `PuTTY`.
    * Capturar imagen del intercambio de claves que se produce en el primer proceso de conexión SSH.
    * Guardar la identificación del servidor.
* ¿Te suena la clave que aparece? Es la clave de identificación de la máquina del servidor.
* Una vez llegados a este punto deben de funcionar correctamente las conexiones SSH desde el cliente. Comprobarlo.
* La siguiente vez que volvamos a usar PuTTY ya no debe aparecer el mensaje de advertencia porque hemos memorizado la identificación del servidor SSH. Comprobarlo.

---
# 3. Cambiamos la identidad del servidor

¿Qué pasaría si cambiamos la identidad del servidor?
Esto es, ¿Y si cambiamos las claves del servidor? ¿Qué pasa?

* Los ficheros `ssh_host*key` y `ssh_host*key.pub`, son ficheros de clave pública/privada
que identifican a nuestro servidor frente a nuestros clientes. Confirmar que existen
el en `/etc/ssh`,:


* Modificar el fichero de configuración SSH (`/etc/ssh/sshd_config`) para dejar una única línea: `HostKey /etc/ssh/ssh_host_rsa_key`. Comentar el resto de líneas con configuración HostKey.
Este parámetro define los ficheros de clave publica/privada que van a identificar a nuestro servidor. Con este cambio decimos que sólo se van a utilizar las claves del tipo RSA.

## 3.1 Regenerar certificados

Vamos a cambiar o volver a generar nuevas claves públicas/privadas que identifican nuestro servidor.
* Ir al servidor.
* Como usuario root ejecutamos: `ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key`. ¡OJO! No poner password al certificado.

![](./images/2-2-3.png)



* Reiniciar el servicio SSH: `systemctl restart sshd`.
* Comprobar que el servicio está en ejecución correctamente: `systemctl status sshd`

![](./images/3-1-2.png)

## 3.2 Comprobamos

* Comprobar qué sucede al volver a conectarnos desde los dos clientes, usando los  usuarios `santana2` y `santana1`. ¿Qué sucede?

cliente opensuse cliente a servidor.


![](./images/3-2-1.png)


Intentamos acceder con santana1 y santana2 desde cliente windows y, nos parece un mensaje de advertencia de que no está el registro del host guardado, por lo que ya tenemos que estar alerta pero, sin embargo si damos a SI, que queremos continuar nos deja acceder.


![](./images/2-3-2.png)


Nos avisa, pero nos deja conectarnos, por tanto no dispone de tanta seguridad como en el caso anterior.


![](./images/2-3-3.png)


* Para solucionarlo lo único que debemos hacer es entrar al fichero known_hosts y volver a dejarlo como estaba anteriormente.
---
# 4. Personalización del prompt Bash

* Por ejemplo, podemos añadir las siguientes líneas al fichero de configuración del `santana1` en la máquina servidor (Fichero `/home/1er-apellido-alumno1/.bashrc`)

```
# Se cambia el prompt al conectarse vía SSH

if [ -n "$SSH_CLIENT" ]; then
   PS1="AccesoRemoto_\e[32m\u@\h:\e[0m \w\a\$ "
else
   PS1="\[$(pwd)\]\u@\h:\w>"
fi
```


![](./images/4-1.png)



* Además, crear el fichero el fichero `/home/santana1/.alias`,
donde pondremos el siguiente contenido:

```
alias c='clear'
alias g='geany'
alias p='ping'
alias v='vdir -cFl'
alias s='ssh'
```


![](./images/4-2.png)


* Comprobar funcionamiento de la conexión SSH desde cada cliente.

Comprobación desde cliente OpenSUSE


![](./images/4-3.png)


Comprobación desde cliente Windows



![](./images/4-3-1-1.png)



---
# 5. Autenticación mediante claves públicas

**Explicación:**

El objetivo de este apartado es el de configurar SSH para poder acceder desde el `client16g2g` sin necesidad de escribir la clave. Usaremos un par de claves pública/privada.

Para ello, vamos a configurar la autenticación mediante clave pública para acceder con nuestro usuario personal desde el equipo cliente al servidor con el usuario `1er-apellido-alumno4`. Vamos a verlo.

**Práctica**

Capturar imágenes de los siguientes pasos:
* Vamos a la máquina `client16g2g`.
* **¡OJO! No usar el usuario root**.
* Iniciamos sesión con nuestro el usuario **nombre-alumno** de la máquina `client16g2g`.
* `ssh-keygen -t rsa` para generar un nuevo par de claves para el usuario en:
    * `/home/santana16g2/.ssh/id_rsa`
    * `/home/santana16g2/.ssh/id_rsa.pub`

![](./images/5-1.png)






* Ahora vamos a copiar la clave pública (`id_rsa.pub`), al fichero "authorized_keys" del usuario remoto *1er-apellido-alumno4* que está definido en el servidor.
    * Hay varias formas de hacerlo.
    * El modo recomendado es usando el comando `ssh-copy-id`. Ejemplo para copiar la clave pública del usuario actual al usuario remoto en la máquina remota: `ssh-copy-id santana4@server16g`.

![](./images/5-2.png)








* Comprobar que ahora al acceder remotamente vía SSH
    * Desde `client16g2`, NO se pide password.
    * Desde `cliente16w1`, SI se pide el password.

Desde el cliente opensuse accedemos y, no nos solicita clave.

![](./images/5-3-3.png)






Desde el cliente windows si que nos solicita la clave.

![](./images/5-3-4.png)


---
# 6. Uso de SSH como túnel para X


* Instalar en el servidor una aplicación de entorno gráfico (APP1) que no esté en los clientes. Por ejemplo Geany. Si estuviera en el cliente entonces buscar otra aplicación o desinstalarla en el cliente.

Vamos a instalar en el servidor la aplicación Geany, vamos a comprobar que no está instalada en la máquina cliente opensuse.

Como se observa en la imagen no está instalada la aplicación geany en el cliente OpenSUSE.


![](./images/6-1.png)




* Modificar servidor SSH para permitir la ejecución de aplicaciones gráficas, desde los clientes. Consultar fichero de configuración `/etc/ssh/sshd_config` (Opción `X11Forwarding yes`)
* Reiniciar el servicio SSH para que se lean los cambios de configuración.


![](./images/6-3.png)


![](./images/6-4.png)




Vamos a clientXXg.
* `zypper se APP1`,comprobar que no está instalado el programa APP1.

![](./images/6-5.png)




* Vamos a comprobar desde clientXXg, que funciona APP1(del servidor).
    * `ssh -X santana1@serverXXg`, nos conectamos de forma remota al servidor, y ahora ejecutamos APP1 de forma remota.
    * **¡OJO!** El parámetro es `-X` en mayúsculas, no minúsculas.



![](./images/6-6.png)





Cómo se puede ver se abre Geany gráficamente desde el servidor, ya que en nuestro equipo no está instalado.

![](./images/6-7.png)




---
# 7. Aplicaciones Windows nativas

Podemos tener aplicaciones Windows nativas instaladas en ssh-server mediante el emulador WINE.
* Instalar emulador Wine en el `serverXXg`.
* Ahora podríamos instalar alguna aplicación (APP2) de Windows en el servidor SSH usando el emulador Wine. O podemos usar el Block de Notas que viene con Wine: wine notepad.
* Comprobar el funcionamiento de APP2 en serverXXg.
* Comprobar funcionamiento de APP2, accediendo desde clientXXg.

> En este caso hemos conseguido implementar una solución similar a RemoteApps usando SSH.

---
# 8. Restricciones de uso

Vamos a modificar los usuarios del servidor SSH para añadir algunas restricciones de uso del servicio.

## 8.1 Restricción sobre un usuario

Vamos a crear una restricción de uso del SSH para un usuario:

* En el servidor tenemos el usuario `santana2`. Desde local en el servidor podemos usar sin problemas el usuario.
* Vamos a modificar SSH de modo que al usar el usuario por SSH desde los clientes tendremos permiso denegado.

Capturar imagen de los siguientes pasos:
* Consultar/modificar fichero de configuración del servidor SSH (`/etc/ssh/sshd_config`) para restringir el acceso a determinados usuarios. Consultar las opciones `AllowUsers`, `DenyUsers` (Más información en: `man sshd_config`)

En el fichero vamos a denegar la entrada al usuario santana2.

![](./images/8-2.png)





* `/usr/sbin/sshd -t; echo $?`, comprobar si la sintaxis del fichero de configuración del servicio SSH es correcta (Respuesta 0 => OK, 1 => ERROR).



![](./images/8-2-2-2-2.png)



* Comprobarlo la restricción al acceder desde los clientes.

Pruebo a entrar con el usuario denegado y, como se observa al poner el password, no me sale error alguno, simlemente entra en buche y no me acepta el password y, no podemos entrar con el usuario santana2.





![](./images/8-2-2.png)




Al intentar acceder desde el cliente windows desde Putty si que nos aparece el acceso como denegado para el usuario santana2.


![](./images/8-2-2-2.png)


## 8.2 Restricción sobre una aplicación

Vamos a crear una restricción de permisos sobre determinadas aplicaciones.

* Crear grupo `remoteapps`
* Incluir al usuario `1er-apellido-alumno4` en el grupo `remoteapps`.
* Localizar el programa APP1. Posiblemente tenga permisos 755.
* Poner al programa APP1 el grupo propietario a remoteapps.
* Poner los permisos del ejecutable de APP1 a 750. Para impedir que los usuarios que no pertenezcan al grupo puedan ejecutar el programa.
* Comprobamos el funcionamiento en el servidor en local.
* Comprobamos el funcionamiento desde el cliente en remoto (Recordar `ssh -X ...`).

---
# 9. Servidor SSH en Windows

* Voy a configurar el Windows server 16 con el servicio OpenSSH, para ello primero voy a añadir en `C:\Windows\System32\drivers\etc\hosts` el equipo client16g2 y client16w.



![](./images/9-1.png)


Descargamos el archivo OpenSSH-Win64.zip desde la página web y, debemos descomprimirlo sobre la siguiente ruta: C:\archivos de programa\OpenSSH



![](./images/9-2.png)



Abrimos un terminal power shell como administrador y, vamos a la ruta anterior C:\archivos de programa\OpenSSH para ejecutar la configuración e instalación del servicio.


Cambiamos las políticas de ejecución de los scripts para poder instalarlo.

![](./images/9-3.png)



Nos movemos dentro de la carpeta donde está el archivo sshd.ps1 y, procedemos a la instalación mediante el comando .\install-sshd.ps1 y se procede a su instalación.
Con el comando Get-Service encendemos el servicio de ssh.

Luego pedimos que nos genere claves para ssh con ssh-keygen.exe

![](./images/9-5.png)





Añadimos una nueva regla para el SSH
![](./images/9-6.png)




Añadimos los servicios sshd y ssh-agent para que se inicien de forma automçatica cuando inicie el equipo.
Y luego activamos el servicio Start-Service sshd.

![](./images/9-7.png)



Voy a configurar el intérprete de comandos (Shell) que se ejecutará cuando nos conectemos de forma remota al servidor SSH en Windows.


![](./images/9-8.png)





* Comprobar acceso SSH desde los clientes Windows y GNU/Linux al servidor SSH Windows.




Accedemos con la ip del servidor windows desde el cliente Opensuse y, vemos que se conecta sin problemas.

ssh Administrador@172.19.99.100

![](./images/9-10.png)





* `netstat -n` en Windows.

Observamos cómo hay una conexión activa entre el servidor 172.19.99.100 y el cliente OpenSUSE 172.19.99.200.

![](./images/opensuse1.png)






Aquí hago la conexión de entre el cliente windows con ip 172.19.99.220 y el servidor 172.19.99.100 y, vemos que se realiza la conexión sin problemas.

![](./images/9-9.png)






Se observan ambas Ip's la del cliente 172.19.99.220 y la 172.19.99.100 del servidor.
![](./images/9-10.png)
