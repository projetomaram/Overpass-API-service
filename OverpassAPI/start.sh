#!/bin/bash

echo "Iniciando Overpass API..."
echo "Diretório da Base de Dados: $DB_DIR"

echo "Limpando arquivos de socket/lock antigos para garantir um início limpo..."
rm -f ${DB_DIR}/osm3s_osm_base

echo "Iniciando processos de backend da Overpass API..."
nohup /OP_API/bin/dispatcher --osm-base --db-dir=$DB_DIR &

echo "Iniciando Apache..."
exec /usr/sbin/apache2ctl -D FOREGROUND