import os
import sys
import time
import subprocess

fio_size="64M" # size in fio
fio_runtime="5" # runtime in fio for time_based tests

kernel_version = os.uname()[2]
columns="iotype;bs;njobs;iodepth;iops;slatmin;slatmax;slatavg;clatmin;clatmax;clatavg;latmin;latmax;latavg"

# Eliminate noise by running each test n times and calculating average.
n_iterations=3

for run in ('write', 'randwrite', 'read', 'randread'):
  for blocksize in ('512', '1k', '4k', '512k'):
     for numjobs in (1, 32, 64):
        for iodepth in (1, 8, 32, 64, 128):

           command = "fio -name=temp-fio --bs="+str(blocksize)+" --ioengine=libaio --iodepth="+str(iodepth)+" --size="+fio_size+" --direct=1 --rw="+str(run)+" --filename=/bmvol/bmfile --numjobs="+str(numjobs)+" --time_based --runtime="+fio_runtime+" --group_reporting"
           sys.stdout.write(command)
           print(command)

           for i in range (0, n_iterations):
             os.system("sleep 2") #Give time to finish inflight IOs
             output = subprocess.check_output(command, shell=True)

           sys.stdout.write(output)
           print(output)