#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=3:00:00
#SBATCH --ntasks=28
#SBATCH --mem=120GB
#SBATCH -A pawsey0345
#SBATCH -J hrimage
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

source /group/mwa/software/module-reset.sh
module use /group/mwa/software/modulefiles
module load MWA_Tools/mwa-sci
module list

set -x

{

obsnum=1160507272
base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/
datadir=${base}processing/${obsnum}
timeStep=3


cd ${datadir}

mem=60

t1=$((timeStep))
t2=$((t1+1))

mkdir ${t1}

wsclean -name ${obsnum}-2m-${t1} -size 1400 1400 -temp-dir ${t1} \
	-abs-mem ${mem} -interval ${t1} ${t2} -channels-out 768\
	-weight natural -scale 5amin ${obsnum}.ms

}
