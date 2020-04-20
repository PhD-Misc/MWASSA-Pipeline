#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=24:00:00
#SBATCH --ntasks=28
#SBATCH --mem=120GB
#SBATCH -A mwasci
#SBATCH -J stacker
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

set -x

{

obsnum=OBSNUM
base=BASE
datadir=${base}processing/${obsnum}
timeStart=TIMESTEP
channels=CHANNELS
noradid=SAT
timeEnd=$((timeStart+15))
echo ${noradid}

cd ${datadir}

mem=110

for q in `seq ${timeStart} ${timeEnd}`;
do
    while [[ $(jobs | wc -l) -ge 28 ]]
    do
        wait -n $(jobs -p)
    done

    stacker --obs ${obsnum} --timeStep ${q} --noStacks 5 --freqChannels ${channels} --NORADID ${noradid} &   
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



}
