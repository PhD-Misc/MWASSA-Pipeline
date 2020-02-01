#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus 
#SBATCH -p workq
#SBATCH --time=4:30:00
#SBATCH --ntasks=28
#SBATCH --mem=64GB
#SBATCH -A mwasci
#SBATCH -J RFISeeker
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

set -x

{

obsnum=1264373056_065-077
base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/
datadir=${base}processing/${obsnum}
cd ${datadir}


for q in $(seq 148)
do
  while [[ $(jobs | wc -l) -ge 28 ]]
  do
    wait -n $(jobs -p)
  done
  RFISeeker --obs ${obsnum} --freqChannels 416 --seedSigma 6 --floodfillSigma 3 --timeStep ${q} --prefix 6Sigma3floodfill --DSNRS False &
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

RFICombinedPlot --obs ${obsnum} --timeStep 148 --prefix 6Sigma3floodfill --FULLTLE /astro/mwasci/sprabu/satellites/MWA-fast-image-transients/conjunction/FULLTLE.txt --LEOTLE /astro/mwasci/sprabu/satellites/MWA-fast-image-transients/conjunction/LEOTLE.txt --MEOTLE /astro/mwasci/sprabu/satellites/MWA-fast-image-transients/conjunction/MEOTLE.txt --HEOTLE /astro/mwasci/sprabu/satellites/MWA-fast-image-transients/conjunction/HEOTLE.txt

}
