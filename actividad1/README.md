@@ -1,70 +1,71 @@
# 0. Introducción VNC
Entrega a determinar por el profesor:
* (a) Correccción remota con TEUTON.
* (b) Entrega informe por GIT.
> En el caso de la entrega por GIT:
> * URL con la ruta al archivo del informe dentro del repositorio del alumno.
> * URl commit del repositorio con la versión entregada.
> * Etiquetaremos la entrega en el repositorio Git con `vnc`.
> * Capturar imágenes de la instalación y configuración VNC para poder acceder a una máquina remota.
## 0.1 Propuesta de rúbrica
| Sección | Bien(2) | Regular(1) | Poco adecuado(0) |
| ------- | ------- | ---------- | ---------------- |
| (2.1) Comprobaciones ||||
| (4.1) Comprobaciones ||| |
## 0.2 Configuraciones
Conexiones remotas con VNC:
| MV | OS       | IP           | Rol        | Detalles              |
| -- | -------- | ------------ | ---------- | --------------------- |
|  1 | Windows  | 172.AA.XX.11 | Slave VNC  | Instalar servidor VNC |
|  2 | Windows  | 172.AA.XX.12 | Master VNC | Instalar cliente VNC  |
|  3 | OpenSUSE | 172.AA.XX.31 | Slave VNC  | Instalar servidor VNC |
|  4 | OpenSUSE | 172.AA.XX.32 | Master VNC | Instalar cliente VNC  |
---
# 1. Windows: Slave VNC
* Configurar las máquinas virtuales según este [documento](../../global/configuracion/).
* Descargar `TightVNC`. Esta es una herramienta libre disponible para Windows.
* En el servidor VNC instalaremos `TightVNC -> Custom -> Server`. Esto es el servicio.
* Revisar la configuración del cortafuegos del servidor VNC Windows para permitir VNC.
## 1.2 Ir a una máquina con GNU/Linux
* Ejecutar `nmap -Pn IP-VNC-SERVER`, desde la máquina real GNU/Linux para comprobar
que los servicios son visibles desde fuera de la máquina VNC-SERVER. Deben verse los puertos 580X, 590X, etc.
---
# 2 Windows: Master VNC
* En el cliente Windows instalar `TightVNC -> Custom -> Viewer`.
* Usaremos `TightVNC Viewer`. Esto es el cliente VNC.
> **NOTA**
>
> * Si usamos un servidor VNC "Marca-ACME", usar también el cliente "Marca-ACME".
> * Para esta práctica usaremos conexiones SIN cifrar.
> * Leer la documentación sobre conexiones VNC.
> **Problemas de conexión**
>
> * Refrescar las MAC de la MV.
> * Revisar en la configuración del servidor VNC Windows las opciones de "Access Control".
## 2.1 Comprobaciones finales

Para verificar que se han establecido las conexiones remotas:
* Conectar Window Master y GNU/Linux Mastar al Windows Slave.
* Conectar desde Window Master hacia el Windows Slave.
* Conectar desde GNU/Linux Master hacia el Windows Slave.
* Ir al servidor VNC y usar el comando `netstat -n` para ver las conexiones VNC con el cliente.
