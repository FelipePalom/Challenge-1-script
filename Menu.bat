#!/bin/bash

# Verifica que se hayan pasado suficientes argumentos
if [ $# -ne 6 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_sistema_operativo> <num_cpus> <memoria_gb> <vram_mb> <tamano_disco_gb>"
    exit 1
fi

# Asigna los argumentos a variables
nombre_vm=$1
tipo_so=$2
num_cpus=$3
memoria_gb=$4
vram_mb=$5
tamano_disco_gb=$6

# Crea la máquina virtual
VBoxManage createvm --name $nombre_vm --ostype $tipo_so --register

# Configura la cantidad de CPUs y la memoria RAM
VBoxManage modifyvm $nombre_vm --cpus $num_cpus --memory $(($memoria_gb * 1024))

# Configura la memoria de video
VBoxManage modifyvm $nombre_vm --vram $vram_mb

# Crea un disco duro virtual
VBoxManage createhd --filename "$nombre_vm.vdi" --size $((tamano_disco_gb * 1024))

# Asocia el disco duro virtual a la máquina virtual
VBoxManage storagectl $nombre_vm --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $nombre_vm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$nombre_vm.vdi"

# Crea un controlador IDE
VBoxManage storagectl $nombre_vm --name "IDE Controller" --add ide

# Imprime la configuración de la máquina virtual
echo "Configuración de la Máquina Virtual $nombre_vm:"
VBoxManage showvminfo $nombre_vm | grep -E "Name:|Memory size|Number of CPUs|VRAM size|SATA|IDE"

echo "Máquina Virtual creada y configurada correctamente."
