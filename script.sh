# Autores: Facundo San Andreas, Ignacio Dalla Rizza, Stefano Terzaghi

# Crea un archivo con usuarios y contraseñas
cat > users.txt << EOF
admin:admin
user:1234
EOF

LETRA_INICIAL=""
LETRA_FINAL=""
LETRA_CONTENIDA=""
VOCAL=""
USUARIO_LOGUEADO=""

echo "######################################"
echo "#                                    #"
echo "#    IIIIII  SSSSSS   FFFFFFFF       #"
echo "#      II    SS        FF            #"
echo "#      II     SSSS     FFFFF         #"
echo "#      II        SS    FF            #"
echo "#    IIIIII  SSSSSS    FF            #"
echo "#                                    #"
echo "######################################"
echo "#    Innovative Script Framework     #"
echo "######################################"
echo
echo "¡Bienvenido al Script ISF!"
echo "Su solución confiable para scripting eficiente."
echo "--------------------------------------------"

# Función para mostrar el menú
menu() {
  while true; do
    # Menú de inicio
    echo "Menú de inicio"
    echo "1. Listar usuarios"
    echo "2. Crear usuario"
    echo "3. Configurar letra inicio"
    echo "4. Configurar letra final"
    echo "5. Configurar letra contenida"
    echo "6. Consultar diccionario"
    echo "7. Ingresar vocal"
    echo "8. Listar palabras con solo esa vocal"
    echo "9. Algoritmo 1"
    echo "10. Algoritmo 2"
    echo "11. Salir"
    
    echo "Seleccione una opción:"
    read opcion
    
    case $opcion in
      1)
        listarUsuarios
        ;;
      2)
        crearUsuario
        ;;
      3)
        configurarLetraInicio
        ;;
      4)
        configurarLetraFinal
        ;;
      5)
        configurarLetraContenida
        ;;
      6)
        consultarDiccionario
        ;;
      7)
        ingresarVocal
        ;;
      8)
        # TODO - listarPalabrasConVocal
        ;;
      9)
        algoritmo1
        ;;
      10)
        # TODO - algoritmo2
        ;;
      11)
        echo "Saliendo del programa..."
        break
        ;;
      *)
        echo "Opción no válida, intente nuevamente"
        ;;
    esac
  done
}

ingresarVocal() {
  echo "Ingresar vocal"
  echo "Ingrese vocal:"
  read vocal
  VOCAL=$vocal
}

configurarLetraInicio() {
  echo "Configurar letra de inicio"
  echo "Ingrese letra:"
  read letra
  LETRA_INICIAL=$letra
}

configurarLetraFinal() {
  echo "Configurar letra de fin"
  echo "Ingrese letra:"
  read letra
  LETRA_FINAL=$letra
}

configurarLetraContenida() {
  echo "Configurar letra contenida"
  echo "Ingrese letra:"
  read letra
  LETRA_CONTENIDA=$letra
}

consultarDiccionario() {
  if [ "$LETRA_INICIAL" == "" ] && [ "$LETRA_FINAL" == "" ] && [ "$LETRA_CONTENIDA" == "" ]; then
    echo "Primero debe configurar las letras (con las opciones 3, 4 y 5)"
    return 1
  fi

  echo "Consultar diccionario"
  echo "Fecha: `date`"
  echo "Cantidad de palabras totales: `cat diccionario.txt | wc -l`"
  echo "Cantidad de palabras de todo el diccionario: `cat diccionario.txt | wc -l`"
  
  # Filtra las palabras que cumplen con las condiciones
  result="`cat diccionario.txt | grep "^$LETRA_INICIAL.*$LETRA_CONTENIDA.*$LETRA_FINAL$"`"
  
  echo "Cantidad de palabras que cumplen con las condiciones: `echo "$result" | wc -l`"

  # wc -l cuenta la cantidad de líneas
  total="`cat diccionario.txt | wc -l`"
  cumplen="`echo "$result" | wc -l`"

  porcentaje=`echo "scale=3; $cumplen / $total * 100" | bc`

  # Agregar un cero inicial si el porcentaje empieza con un punto decimal
  if [[ $porcentaje == .* ]]; then
    porcentaje="0$porcentaje"
  fi
  
  echo "Porcentaje de palabras del diccionario que cumplen lo pedido: $porcentaje %"
  
  echo "Usuario: $USUARIO_LOGUEADO" >> result.txt
  echo "$result" >> result.txt
}

listarUsuarios() {
  echo "Usuarios:"
  # cut -d: -f1 corta el archivo por el delimitador ":" y muestra la primera columna (f1)
  cat users.txt | cut -d: -f1
}

algoritmo1() {
  echo "Ingrese la cantidad de datos:"
  read cantidad
  
  suma=0
  menor=0
  mayor=0
  
  # Itera la cantidad de veces ingresada
  for ((i=0; i<$cantidad; i++)); do
    echo "Ingrese dato $i:"
    read dato
    
    suma=$((suma + dato))
    
    # -eq significa igual (equal)
    if [ $i -eq 0 ]; then
      menor=$dato
      mayor=$dato
    fi

    # -lt significa menor que (less than)
    if [ $dato -lt $menor ]; then
      menor=$dato
    fi
    
    # -gt significa mayor que (greater than)
    if [ $dato -gt $mayor ]; then
      mayor=$dato
    fi
  done

  # bc es una calculadora de precisión arbitraria - scale=3 significa que redondea a 3 decimales
  promedio=`echo "scale=3; $suma / $cantidad" | bc`
  
  echo "Promedio: $promedio"
  echo "Menor: $menor"
  echo "Mayor: $mayor"
}

crearUsuario() {
  echo "Nuevo usuario"
  echo "Ingrese nombre de usuario"
  read user
  echo "Ingrese contraseña"

  # Oculta la contraseña usando el flag -s
  read -s password

  if [ "$user" == "" ] || [ "$password" == "" ]; then
    echo "Usuario y contraseña no pueden estar vacíos"
    return 1
  fi

  result="`grep "$user:" users.txt`"

  if [ "$result" != "" ];then
    echo "Usuario ya existe"
    return 1
  fi

  echo "$user:$password" >> users.txt
  echo "Usuario creado"
}

logueo() {
  echo ""
  echo "Welcome!"
  echo "Ingrese usuario:"
  read user
  echo "Ingrese contraseña:"
  read password

  if [ "$user" == "" ] || [ "$password" == "" ]; then
    echo "Usuario y contraseña no pueden estar vacíos"
    return 1
  fi

  # Verifica si el usuario y contraseña son correctos
  result="`grep "$user:$password" users.txt`"
  
  if [ "$result" == "" ];then
    # En caso de no existir lo crea
    echo "Usuario no existe"
    return 1
  else
    echo "Logueado"
    USUARIO_LOGUEADO=$user
    return 0
  fi
}

if logueo; then
  menu
else
  echo "Autenticación fallida. Saliendo..."
fi
