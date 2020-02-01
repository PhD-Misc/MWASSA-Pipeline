#! /bin/bash -l
#SBATCH --export=NONE
#SBATCH -M zeus
#SBATCH -p copyq
#SBATCH --time=5:00:00
#SBATCH --ntasks=8
#SBATCH --mem=10GB
#SBATCH -J asvo
#SBATCH --mail-type FAIL,TIME_LIMIT,TIME_LIMIT_90
#SBATCH --mail-user sirmcmissile47@gmail.com


set -x

{

obsnum=OBSNUM
base=BASE
link=

while getopts 'l:' OPTION
do
    case "$OPTION" in
        l)
            link=${OPTARG}
            ;;
    esac
done

echo "The download link is ${link}"

datadir=${base}/processing

cd ${datadir}
mkdir -p ${obsnum}
cd  ${obsnum}

outfile="${obsnum}_ms.zip"
msfile="${obsnum}.ms"

if [[ -e "${outfile}" ]]
then
    echo "${outfile} exists, not downloading again"
elif [[ -e "${msfile}" ]]
then
    echo "${msfile} exists, not downloading again"
else
    wget -O ${obsnum}_ms.zip "${link}"
fi

if [[ -e "${outfile}" ]]
then
    unzip -n ${outfile}
    rm ${outfile}
fi

}




