#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=8:30:00
#SBATCH --ntasks=28
#SBATCH --mem=120GB
#SBATCH -A pawsey0345
#SBATCH -J cotter
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

source /group/mwa/software/module-reset.sh
module use /group/mwa/software/modulefiles
module load MWA_Tools/mwa-sci
module list

set -x

{

obsnum=1264325712
base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/
calibrationPath=

while getopts 'p:' OPTION
do
    case "$OPTION" in
        p)
            calibrationPath=${OPTARG}
            ;;
    esac
done


datadir=${base}/processing/${obsnum}
cd datadir


cotter -norfi -initflag 2 -timeres 2 -freqres 40 *gpubox* -absmem 110 -edgewidth 80 -m ${obsnum}.metafits -o ${obsnum}.ms

#applysolutions ${obsnum}.ms ${calibrationPath}

rm *.zip
#rm *gpubox*.fits


}
