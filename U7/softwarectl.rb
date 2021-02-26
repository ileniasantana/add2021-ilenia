#!/usr/bin/env ruby

argument = ARGV[0]

filename = ARGV[1]



def comprobar(packages)
  comp = `whereis #{packages[0]} |grep bin |wc -l`.to_i
  if comp == 0
    puts "#{packages[0]} -> El programa #{packages[0]} no está instalado"
  else
    puts "#{packages[0]} -> El programa #{packages[0]} está instalado"
  end
end

def instalar(packages)
  comp = `whereis #{packages[0]} |grep bin |wc -l`.to_i
  process = "#{packages[1]}"

  if process == 'install'
    if comp == 0
      `zypper install #{packages[0]}`
      puts "#{packages[0]} Se ha instalado correctamente"
    else
      puts "#{packages[0]} ya está instalado"
    end

  elsif process == 'remove'
    if comp == 0
      puts "#{packages[0]} no está instalado"
    else
      `zypper remove #{packages[0]}`
      puts "#{packages[0]} ha sido eliminado"
    end
  end
end

# Aquí he definido que si no se pone ningún argumento, aparezca esta ventana para que utilices --help.

if argument == ()
  puts 'Usa el comando --help para ver las distintas opciones'


# Si el argumento es --help que se lea en pantalla estas opciones que podemos ejecutar.

elsif argument == '--help'
  puts "Debe usar:
          Softwarectl [OPCIONES] [FILENAME]
  Opciones:
          --help, mostrar esta ayuda.
          --version, mostrar información sobre el autor del script
                     y fecha de creacion.
          --status FILENAME, comprueba si puede instalar/desintalar.
          --run FILENAME, instala/desinstala el software indicado.
  Descripcion:
          Este script se encarga de instalar/desinstalar
          el software indicado en el fichero FILENAME.
          Ejemplo de FILENAME:

          vim:remove
	  tree:remove
          nmap:install"

# Si el argumento es --version, aparecerá el nombre de creadora y la fecha.

elsif argument == '--version'
  puts 'Script creado por Carmen Ilenia Santana Campos de 2ºASIR, 26/02/2021'

# Si el escript ejecuta la opción --status filename, lee el archivo filename y muestra en pantalla la situación de cada packages.

elsif argument == '--status' and filename != ()
  lines = `cat #{filename}`
  f_lines = lines.split("\n")
  f_lines.each do |a|
    packages = a.split(":")
    comprobar(packages) # Aquí defino una llamada a comprobar paquetes, definido arriba.
  end

# Si el argumento es --run filename, primero comprueba que seamos usuario 'root' y, sino lo somos no se ejecutará ni instalación  ni borrado, si lo somos, se ejecutará la instalación.

elsif argument == '--run' and filename != ()
  root = `id -u`.to_i
  if root == 0
    lines = `cat #{filename}`
    f_lines = lines.split("\n")
    f_lines.each do |a|
      packages = a.split(":")
      instalar(packages) # aquí defino una llamada a instalar paquetes, definido arriba.
    end
  else
    puts "No se puede ejecutar el script, debe ser usuario root"
    exit 1
  end

end
