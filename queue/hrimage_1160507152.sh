#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M magnus
#SBATCH -p workq
#SBATCH --time=20:00:00
#SBATCH --nodes=1
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

obsnum=1160507152
base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/
datadir=${base}/processing/${obsnum}
cd datadir

mem=60

for g in `seq 0 56`;
do
    i=$((g*1))
    j=$((i+1))
    rm -r ${i}
    mkdir ${i}
    wsclean -name ${obsnum}-2m-${i} -size 1400 1400 -temp-dir ${i} \
        -abs-mem ${mem} -interval ${i} ${j} -channels-out 768\
        -weight natural -scale 5amin ${obsnum}.ms
    rm *image.fits
    rm -r ${i}
done

}
