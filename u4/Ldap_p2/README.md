# Cliente para autenticación LDAP

Con autenticacion LDAP prentendemos usar la máquina servidor LDAP, como repositorio centralizado de la información de grupos, usuarios, claves, etc. Desde otras máquinas conseguiremos autenticarnos (entrar al sistema) con los usuarios definidos no en la máquina local, sino en la máquina remota con LDAP. Una especie de *Domain Controller*.

En esta actividad, vamos a configurar otra MV (GNU/Linux OpenSUSE) para que podamos hacer autenticación en ella, pero usando los usuarios y grupos definidos en el servidor de directorios LDAP de la MV1.

# 1. Preparativos

* Supondremos que tenemos una MV1 (serverXX) con DS-389 instalado, y con varios usuarios dentro del DS.
* Necesitamos MV2 con SO OpenSUSE ([Configuración MV](../../global/configuracion/opensuse.md))

Comprobamos el acceso al LDAP desde el cliente:
* Ir a MV cliente.
* `nmap -Pn IP-LDAP-SERVERXX | grep -P '389|636'`, para comprobar que el servidor LDAP es accesible desde la MV2 cliente.


![](./images/2.png)






* `ldapsearch -H ldap://IP-LDAP-SERVERXX:389 -W -D "cn=Directory Manager" -b "dc=ldapXX,dc=curso2021" "(uid=*)" | grep dn`, comprobamos que los usuarios del LDAP remoto son visibles en el cliente.


![](./images/3.png)







# 2. Configurar autenticación LDAP

## 2.1 Crear conexión con servidor

Vamos a configurar de la conexión del cliente con el servidor LDAP.

* Ir a la MV cliente.
* No aseguramos de tener bien el nombre del equipo y nombre de dominio (`/etc/hostname`, `/etc/hosts`)

* Ir a `Yast -> Cliente LDAP y Kerberos`.
* Configurar como la imagen de ejemplo:
    * BaseDN: `dc=ldapXX,dc=curso2021`
    * DN de usuario: `cn=Directory Manager`
    * Contraseña: CLAVE del usuario cn=Directory Manager

![](./images/4.png)

* Al final usar la opción de `Probar conexión`


![](./images/5.png)


## 2.2 Comprobar con comandos

* Vamos a la consola con usuario root, y probamos lo siguiente:

id mazinger


![](./images/8.png)


su -l mazinger   # Entramos con el usuario definido en LDAP


![](./images/9.png)



getent passwd mazinger          # Comprobamos los datos del usuario



![](./images/10.png)



cat /etc/passwd | grep mazinger # El usuario NO es local

Como vemos el usuario mazinger no se encuentra de manera local en el equipo.

![](./images/6.png)






![](./images/7.png)
