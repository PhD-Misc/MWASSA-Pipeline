#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p workq
#SBATCH --time=24:00:00
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

obsnum=OBSNUM
base=BASE
datadir=${base}processing/${obsnum}
timeStart=TIMESTEP
channels=CHANNELS
timeEnd=$((timeStart+15))

cd ${datadir}

mem=110
for ((timeStep=${timeStart};timeStep<${timeEnd};timeStep++));do
t1=$((timeStep*1))
t2=$((t1+1))

rm -r ${t1}

mkdir ${t1}

wsclean -name ${obsnum}-2m-${timeStep} -size 5000 5000 -temp-dir ${t1} \
	-abs-mem ${mem} -interval ${t1} ${t2} -channels-out ${channels}\
	-weight natural -scale 1.25amin  ${obsnum}.ms
rm *image.fits
done

}
