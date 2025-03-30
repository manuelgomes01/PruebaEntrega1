busco_csv_2 () {
    busco_resultado_1=$(find ~/Documents/FIUBA/software/TP1 -type f -name "resultado.txt")
    busco_pokemon_csv=$(find ~/Documents/FIUBA/software/TP1 -type f -name "pokemon.csv")
    busco_pokemon_abilities=$(find ~/Documents/FIUBA/software/TP1 -type f -name "pokemon_abilities.csv")
    busco_ability_name=$(find ~/Documents/FIUBA/software/TP1 -type f -name "ability_names.csv")
}

mostrar_datos_pokemon_padron () {
    > output.txt
    echo "---------------------" >> output.txt
    while IFS= read -r nombre_pokemon; do
        id_pokemon_2=$(grep -m 1 "$nombre_pokemon" "$busco_pokemon_csv" | sed -E "s/(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*)/\1/g")
        altura_pokemon=$(grep -m 1 "$nombre_pokemon" "$busco_pokemon_csv" | sed -E "s/(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*)/\4/g")
        peso_pokemon=$(grep -m 1 "$nombre_pokemon" "$busco_pokemon_csv" | sed -E "s/(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*)/\5/g")
        altura_en_cm=$(( altura_pokemon * 10 ))
        peso_en_kg=$(( peso_pokemon / 10 ))
        id_habilidades=()
        while IFS=, read -r id_pokemon_ability ability_id is_hidden slot; do
            if [[ "$id_pokemon_ability" == "$id_pokemon_2" ]]; then
                id_habilidades+=("$ability_id")
            fi
        done < "$busco_pokemon_abilities"
        nombre_habilidades=()
        while IFS=, read -r id_nombre_habilidad idioma nombre_habilidad; do
            for habilidad in "${id_habilidades[@]}"; do
                if [[ "$id_nombre_habilidad" == "$habilidad" ]] && [[ "$idioma" == 7 ]]; then
                     nombre_habilidades+=("$nombre_habilidad")
                fi
            done
        done < "$busco_ability_name"
        echo "Pokemon: $nombre_pokemon \nAltura: $altura_en_cm centimetros \nPeso: $peso_en_kg kilos \n \nHabilidades:" >> output.txt
        for nombres_habilidades in "${nombre_habilidades[@]}"; do
            echo " * $nombres_habilidades" >> output.txt
        done 
        echo "---------------------" >> output.txt
    done < "$busco_resultado_1"
}

busco_csv_2
mostrar_datos_pokemon_padron