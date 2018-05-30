#!/bin/bash -eux

fio /app/eval.fio --output-format=terse --output=results.csv
fio2gnuplot -t bw -b -g -p '*_bw*'
fio2gnuplot -t iops -i -g -p '*_iops*'
python -m SimpleHTTPServer 8000
