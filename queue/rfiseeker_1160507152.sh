#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus 
#SBATCH -p workq
#SBATCH --time=8:30:00
#SBATCH --ntasks=28
#SBATCH --mem=64GB
#SBATCH -A mwasci
#SBATCH -J RFISeeker
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

set -x

{

obsnum=1160507152
base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/
datadir=${base}/processing/${obsnum}
cd datadir


for q in $(seq 56)
do
  while [[ $(jobs | wc -l) -ge 28 ]]
  do
    wait -n $(jobs -p)
  done
  RFISeeker --obs ${obsnum} --freqChannels 768 --seedSigma 6 --floodfillSigma 3 --timeStep ${q} --prefix 6Sigma3floodfill --DSNRS False &
done

i=0
for job in `jobs -p`
do
        pids[${i}]=${job}
        i=$((i+1))
done
for pid in ${pids[*]}; do
        wait ${pid}
done

combinedPlot


}
