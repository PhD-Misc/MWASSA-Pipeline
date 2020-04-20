#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus 
#SBATCH -p workq
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --mem=12GB
#SBATCH -J SkyAnalysis
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com

set -x

{

obsnum=OBSNUM
base=BASE
tlePath=
timeSteps=
channels=
noradid=

while getopts 't:s:f:n:' OPTION
do
    case "$OPTION" in
	n)
	    noradid=${OPTARG}
	    ;;
        s)
            timeSteps=${OPTARG}
            ;;
        f)
            channels=${OPTARG}
            ;;
        t)
            tlePath=${OPTARG}
            ;;
    esac
done





datadir=${base}processing/${obsnum}
cd ${datadir}

SkyAnalysis --obs ${obsnum} --satid ${noradid} --notimeSteps ${timeSteps} --tle ${tlePath}


}
