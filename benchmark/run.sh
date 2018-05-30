#!/bin/bash -eux

fio /app/eval.fio
fio2gnuplot -t Bandwitdh -b -g
fio2gnuplot -t iops -i -g
fio2gnuplot -t lat -g -p '*_lat*'
python -m SimpleHTTPServer 8000
