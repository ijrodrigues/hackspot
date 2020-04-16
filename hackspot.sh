#!/bin/bash

echo "Verificando processos do spotify em execução..."

spotify_ids_as_string=$(pidof "spotify")
set -f
spotify_ids=(${spotify_ids_as_string// / })

echo "${#spotify_ids[@]} processos do spotify encontrados: $spotify_ids_as_string"

for i in "${!spotify_ids[@]}"
do
    spotify_id=${spotify_ids[i]}
    index=$(pacmd list-sink-inputs | awk -v pid=$spotify_id '
                $1 == "index:" {idx = $2} 
                $1 == "application.process.id" && $3 == "\"" pid "\"" {print idx; exit}')

    printf "Verificando se o processo ${spotify_ids[i]} está disponível para controle: "

      output=$(pacmd set-sink-input-mute $index 0)
      output_error="You need to specify a mute switch setting (0/1)."

      if [ "$output" = "$output_error" ]; then
          echo "Não. Tentando o próximo."
      else
          printf "Sim. Ignorando notificações "

            while [ true ]
            do
              output=$(pacmd set-sink-input-mute $index 0)
              output_error="You need to specify a mute switch setting (0/1)."
              printf "."
              sleep 1
            done
      fi
done







