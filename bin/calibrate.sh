#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=8:00:00
#SBATCH --ntasks=28
#SBATCH --mem=124GB
#SBATCH -J calibrate
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

source /group/mwa/software/module-reset.sh
module use /group/mwa/software/modulefiles
module load MWA_Tools/mwa-sci
module list

set -x

{

obsnum=OBSNUM
base=BASE
calibrator=

while getopts 'c:' OPTION
do
    case "$OPTION" in
        c)
            calibrator=${OPTARG}
            ;;
    esac
done


datadir=${base}/processing/${obsnum}

cd ${datadir}



}
