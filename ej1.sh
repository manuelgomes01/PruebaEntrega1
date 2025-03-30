parametros_filtrar_pokemones () {
    numero_tipo_pokemon=$(( ($padron_pokemon % 18) + 1 ))
    minimo_estadistica_pokemon=$(( ($padron_pokemon % 100) + 350 ))
}

busco_csv_1 () {
    busco_archivo_tipo_pokemon=$(find ~/Documents/FIUBA/software/TP1 -type f -name "pokemon_types.csv")
    busco_archivo_stat_pokemon=$(find ~/Documents/FIUBA/software/TP1 -type f -name "pokemon_stats.csv")
    busco_archivo_pokemon=$(find ~/Documents/FIUBA/software/TP1 -type f -name "pokemon.csv")
}

filtro_pokemon_padron () {
    array_pokemon_id=()
    for resultado_pokemon_id in $(grep -o ".*,$numero_tipo_pokemon" "$busco_archivo_tipo_pokemon" | cut -d "," -f1); do
        array_pokemon_id+=("$resultado_pokemon_id")
    done
    nombre_pokemon_final=()
    > resultado.txt
    for pokemon_id in "${array_pokemon_id[@]}"; do
        sumatoria_base_stat=0
        for base_stat in $(grep "^$pokemon_id," "$busco_archivo_stat_pokemon" | cut -d "," -f3); do
            sumatoria_base_stat=$(( sumatoria_base_stat + base_stat ))
        done
        if [[ "$sumatoria_base_stat" -gt "$minimo_estadistica_pokemon" ]]; then
            nombre_pokemon=$(grep "^$pokemon_id," "$busco_archivo_pokemon" | cut -d "," -f2)
            nombre_pokemon_final+=("$nombre_pokemon")
        fi
    done
    for nombre_pokemon in "${nombre_pokemon_final[@]}"; do
            echo "$nombre_pokemon" >> resultado.txt
    done
}

padron_pokemon=$1
directorio_de_guardado=$2
mkdir -p "$directorio_de_guardado"
cd "$directorio_de_guardado"
parametros_filtrar_pokemones
busco_csv_1
filtro_pokemon_padron