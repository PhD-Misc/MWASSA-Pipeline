#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=20:00:00
#SBATCH --ntasks=28
#SBATCH --mem=124GB
#SBATCH -J hrimage
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

source /group/mwa/software/module-reset.sh
module use /group/mwa/software/modulefiles
module load MWA_Tools/mwa-sci
module list

set -x

{

mem=120

obsnum=OBSNUM
base=BASE
timeSteps=
channels=

while getopts 't:s:f:' OPTION
do
    case "$OPTION" in
        s)
            timeSteps=${OPTARG}
            ;;
        f)
            channels=${OPTARG}
            ;;
    esac
done


datadir=${base}/processing/${obsnum}
cd datadir

for g in `seq 0 ${timeSteps}`;
do
    i=$((g*1))
    j=$((i+1))
    rm -r ${i}
    mkdir ${i}
    wsclean -name ${obsnum}-2m-${i} -size 1400 1400 -temp-dir ${i} \
        -abs-mem ${mem} -interval ${i} ${j} -channels-out ${channels}\
        -weight natural -scale 5amin ${obsnum}.ms
    rm *image.fits
    rm -r ${i}
done

}
