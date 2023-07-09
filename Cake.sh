#!/bin/bash

is_linux_system_file() {
    local filename="$1"
    local system_files=(
        "/bin"
        "/boot"
        "/dev"
        "/etc"
        "/home"
        "/lib"
        "/opt"
        "/root"
        "/sbin"
        "/usr"
        "/var"
    )

    for folder in "${system_files[@]}"; do
        if [[ "$filename" == "$folder"* ]]; then
            return 0
        fi
    done

    return 1
}

if [[ $EUID -ne 0 ]]; then
    echo "Para assar o boloprecisa ser executado como root ou com privilégios de superusuário."
    exit 1
fi

read -p "ATENÇÃO: Este script é altamente perigoso se você estiver arquivos importantes, ele limpará tudo que é fora do sistema com excessão de programas, deseja continuar a assar o bolo? (S/N): " choice
if [[ "$choice" != "S" && "$choice" != "s" ]]; then
    echo "Operação cancelada.!"
    exit 0
fi

echo "Assando bolo em nome do Deus máquina..."

rm -rf /home/*
find /home -type f -delete
echo "/home Limpo."
echo "iniciando análise e limpeza do sistema, (só se você quiser uma limpeza de cada arquivo do sistema)"
sleep 10
echo "Tenha paciência, isso vai demorar ou CTRL + C para sair."
sleep 5

while IFS= read -r -d '' file; do
    if ! is_linux_system_file "$file"; then
        echo "Removendo o arquivo: $file"
        rm -rf "$file"
    fi
done < <(find / -type f -print0)

echo "Bolo assado com sucesso, Sistema limpo com sucesso mas lembre-se que esse script não ajuda se você estiver querendo se proteger contra tecnicas forense."
