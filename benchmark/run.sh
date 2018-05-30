#!/bin/bash -eux

echo ${BUCKET}
echo ${VOLUME_TYPE}
mkdir /tmp/io
cp /app/eval.fio /tmp/io/eval.fio
cd /tmp/io

fio ./eval.fio
fio2gnuplot -t Bandwitdh -b -g
fio2gnuplot -t iops -i -g
fio2gnuplot -t lat -g -p '*_lat*'

s3cmd put --recursive /tmp/io s3://${BUCKET}/${VOLUME_TYPE}/`date +%Y_%m_%d-%H_%M_%S`/

#python -m SimpleHTTPServer 8000
