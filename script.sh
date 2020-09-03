#!/bin/bash
if (($# != 7));
then
	echo "Formato script.sh user _estado dato agente modulo fecha pie_mensaje
  _estado : normal
            critico
            advertencia
            desconocido"
else
  TOKEN="10*****588:AA****eFCm*******Bfxvuiu****bA"
  userPandoraDB="root"
  passPandoraDB="*************"
  BaseDatos="pandora"
  MysqlConsulta="mysql -u $userPandoraDB -p$passPandoraDB -D $BaseDatos -e"

  USERS=`echo ${1} | sed 's/,/\n/g'`
  $MysqlConsulta "select id_user, phone  from tusuario;" | sed 's/&#x20;/ /g'| sed "s/\t/\",\"/g;s/\"//g" | sed '1d' | awk  -F"," '{print $1","$2}' > /tmp/list_number.csv

  NUMBER_OF_USER=`for user in ${USERS}; do cat /tmp/list_number.csv | grep $user | awk -F"," '{print $2}' ;done`


  MESSAGE1="Sistema de Alerta Pandora FMS
========================="
  while :
  do  
    case $2 in
      
      normal)
      MESSAGE2=`echo -e "
Tenemos buenas noticias para usted. Algún módulo ahora se encuentra en estado 
"'\U0001F7E9''\U0001F7E9'NORMAL!'\U0001F7E9''\U0001F7E9'`
      break
      ;;
      
      critico)
      MESSAGE2=`echo -e "
Tenemos malas noticias para usted. Algún módulo se encuentra en estado 
"'\U0001F7E5''\U0001F7E5'CRÍTICO!'\U0001F7E5''\U0001F7E5'`
      break
      ;;
      
      advertencia)
      MESSAGE2=`echo -e "
Tenemos una noticia para usted. Algún módulo se encuentra en estado de 
"'\U0001F7E8''\U0001F7E8'ADVERTENCIA!'\U0001F7E8''\U0001F7E8'`
      break
      ;;
      
      desconocido)
      MESSAGE2=`echo -e "
Tenemos malas noticias para usted. Algún módulo se encuentra en estado 
"'\U0002B1C''\U0002B1C' DESCONOCIDO!'\U0002B1C''\U0002B1C'`
      break
      ;;
      
    esac
  done

  MESSAGE3="

Detalles de la alerta
=================

Dato: "

  MESSAGE4="
Agente: "

  MESSAGE5="
Módulo: "

  MESSAGE6="
Fecha: "

  URL="https://api.telegram.org/bot$TOKEN/sendMessage"

  for TelegramID in ${NUMBER_OF_USER}
  do
  curl -s -X POST $URL -d chat_id=$TelegramID -d text="${MESSAGE1}${MESSAGE2}${MESSAGE3}${3}${MESSAGE4}${4}${MESSAGE5}${5}${MESSAGE6}${6}
  
${7}"
  done
  
fi
