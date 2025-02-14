#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl + C
trap ctrl_c INT

function helpPanel() {
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour}${grayColour} Técnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
}

function martingala() {
  # Mostrar el dinero del cliente
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}'$'$money"${endColour} | tr -d "''"

  # Preguntar la cantidad a apostar
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet

  # Preguntar si se apuesta a par o impar
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  backup_bet=$initial_bet  # Copia de la apuesta inicial
  play_counter=1           # Contador de jugadas
  jugadas_malas=""         # Lista de jugadas malas

  tput civis # Ocultar el cursor
  while true; do
    money=$(($money - $initial_bet)) # Restar lo apostado al dinero total
    random_number=$(($RANDOM % 37))  # Generar un número aleatorio

    if [ ! "$money" -lt 0 ]; then # Si el dinero es 0 o mayor
      if [ "$par_impar" == "par" ]; then
        # Toda esta definicion es para cuando apostamos por numeros pares
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
            initial_bet=$(($initial_bet * 2))
            jugadas_malas+="$random_number "
          else
            reward=$(($initial_bet * 2))
            money=$(($money + $reward))
            initial_bet=$backup_bet
            jugadas_malas=""
          fi
        else
          initial_bet=$(($initial_bet * 2))
          jugadas_malas+="$random_number "
        fi

      elif [ "$par_impar" == "impar" ]; then
        # Toda esta definicion es para cuando apostamos por numeros impares
        if [ "$(($random_number % 2))" -eq 1 ]; then
          reward=$(($initial_bet * 2))
          money=$(($money + $reward))
          initial_bet=$backup_bet
          jugadas_malas=""
        else
          initial_bet=$(($initial_bet * 2))
          jugadas_malas+="$random_number "
        fi
      
      else
        # Casos en los que no se introduzca ni 'par' ni 'impar'
        echo -e "\n${redColour}[!] Has introducido una opcion no valida${endColour}\n"
        tput cnorm
        exit 0
      fi
    
    else
      # Sin dinero
      echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de ${endColour}${yellowColour}$(($play_counter - 1))${endColour}${grayColour} jugadas${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Malas jugadas consecutivas:${endColour}\n"
      echo -e "${blueColour}[ $jugadas_malas]${endColour}"
      tput cnorm
      exit 0
    fi
    let play_counter+=1
  done

  tput cnorm # Mostrar el cursor de nuevo
}



# EDITAR AQUI
function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}'$'$money"${endColour} | tr -d "''"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  declare -a my_sequence=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"

  bet=$((${my_sequence[0]} + ${my_sequence[-1]})) # Inicialmente se apuesta la suma del primer y ultimo numero de la secuencia

  jugadas_totales=0
  bet_to_renew=$(($money+50)) # Dinero el cual una vez alcanzado hara que renovemos nuestra secuencia a [1 2 3 4]

  echo -e "${yellowColour}[+]${endColour}${grayColour} El tope a renovar la secuencia esta establecido por encima de los ${endColour}${yellowColour}'$'$bet_to_renew${endColour}" | tr -d "''" 

  tput civis
  while true; do
    let jugadas_totales+=1
    random_number=$(($RANDOM % 37))
    money=$(($money-$bet)) # Restar la apuesta inicial del dinero total
    if [ ! "$money" -lt 0 ]; then # Si el dinero es 0 o mayor
      echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos ${endColour}${yellowColour}'$'$bet${endColour}" | tr -d "''"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} '$'$money${endColour}" | tr -d "''"
      
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero ${endColour}${blueColour}$random_number${endColour}"
        

        if [ "$par_impar" == "par" ]; then
          if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
            echo -e "${yellowColour}[+]${endColour}${greenColour} El numero es par, ¡ganas!${endColour}"
            reward=$(($bet*2))
            let money+=$reward
            echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}'$'$money${endColour}" | tr -d "''"
            
            if [ "$money" -gt $bet_to_renew ]; then
              echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de ${endColour}${yellowColor}'$'$bet_to_renew${endColour}${grayColour} establecidos para renovar nuestra secuencia${endColour}" | tr -d "''"
              bet_to_renew=$(($bet_to_renew + 50))
              echo -e "${yellowColour}[+]${endColour}${grayColour} El tope se ha establecido en ${endColour}${yellowColour}'$'$bet_to_renew${endColour}" | tr -d "''"
              my_sequence=(1 2 3 4)
              bet=$((${my_sequence[0]} + ${my_sequence[-1]})) 
              echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
          else
              my_sequence+=($bet) # En caso de ganar, se agrega el numero apostado a la secuencia
              my_sequence=(${my_sequence[@]})

              echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva secuencia es ${endColour}${greenColour}[${my_sequence[@]}${endColour}]"
              if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]})) # Se actualiza la apuesta con los valores de la secuencia actualizada
              elif [ "${#my_sequence[@]}" -eq 1 ]; then
                bet=${my_sequence[0]}
              else
                  echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                  my_sequence=(1 2 3 4)
                  echo -e "${yellowColour}[!]${endColour}${greenColour} Restablecemos la secuencia a [${my_sequence[@]}]${endColour}"
                  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              fi
            fi
            elif [ "$((random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
              if [ "$((random_number % 2))" -eq 1 ]; then
                echo -e "${redColour}[!] El numero es impar, ¡pierdes!${endColour}"
              else
                echo -e "${redColour}[!] Ha salido el numero 0, pierdes!${endColour}"
              fi
              if [ $money -lt $(($bet_to_renew-100)) ]; then
                echo -e "${yellowColour}[+]${endColour}${grayColour} Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
                bet_to_renew=$(($bet_to_renew - 50))
                echo -e "${yellowColour}[+]${endColour}${grayColour} El tope ha sido renovado a:${endColour}${yellowColour} '$'$bet_to_renew${endColour}" | tr -d "''"
                #my_sequence+=($bet) 
                #my_sequence=(${my_sequence[@]})
                unset my_sequence[0]
                unset my_sequence[-1] 2>/dev/null

                my_sequence=(${my_sequence[@]})

                echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva secuencia es ${endColour}${greenColour}[${my_sequence[@]}${endColour}]"
                if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
                  bet=$((${my_sequence[0]} + ${my_sequence[-1]})) 
                elif [ "${#my_sequence[@]}" -eq 1 ]; then
                  bet=${my_sequence[0]}
                else
                    echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                    my_sequence=(1 2 3 4)
                    echo -e "${yellowColour}[!]${endColour}${greenColour} Restablecemos la secuencia a [${my_sequence[@]}]${endColour}"
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                fi
              else
                unset my_sequence[0]
                unset my_sequence[-1] 2>/dev/null

                my_sequence=(${my_sequence[@]})
                
                echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se nos queda de la siguiente forma:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                
                if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]})) 
                elif [ "${#my_sequence[@]}" -eq 1 ]; then
                    bet=${my_sequence[0]}
                else
                  echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                  my_sequence=(1 2 3 4)
                  echo -e "${yellowColour}[+]${endColour}${greenColour} Restablecemos la secuencia a [${my_sequence[@]}${endColour}]"
                  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                fi
              fi
            fi
          fi
      else
        echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
        echo -e "${yellowColour}[+]${endColour}${grayColour} En total han habido ${endColour}${yellowColour}$jugadas_totales${endColour}${grayColour} jugadas totales${endColour}\n"
        tput cnorm; exit 1
      fi
  done
  tput cnorm

}

while getopts "m:t:h" args; do
  case $args in
    m) money=$OPTARG ;;
    t) technique=$OPTARG ;;
    h) helpPanel ;;
  esac
done

if [ "$money" ] && [ "$technique" ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
