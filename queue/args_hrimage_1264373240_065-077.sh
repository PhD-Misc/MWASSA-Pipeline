#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=4:00:00
#SBATCH --ntasks=28
#SBATCH --mem=120GB
#SBATCH -A mwasci
#SBATCH -J hrimage
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

source /group/mwa/software/module-reset.sh
module use /group/mwa/software/modulefiles
module load MWA_Tools/mwa-sci
module list

set -x

{

obsnum=1264373240_065-077
base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/
datadir=${base}processing/${obsnum}
timeStep=73


cd ${datadir}

mem=60

t1=$((timeStep*2))
t2=$((t1+2))

mkdir ${t1}

wsclean -name ${obsnum}-2m-${timeStep} -size 1400 1400 -temp-dir ${t1} \
	-abs-mem ${mem} -interval ${t1} ${t2} -channels-out 416\
	-weight natural -scale 5amin ${obsnum}.ms

}
