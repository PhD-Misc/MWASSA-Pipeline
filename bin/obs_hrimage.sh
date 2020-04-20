#!/bin/bash

usage()
{
echo "hrimage.sh [-o obsnum]
        -o obsnum               : the obsid" 1>&2;
exit 1;
}

calibrationPath=
obsnum=

while getopts 'o:' OPTION
do
    case "$OPTION" in
        o)
            obsnum=${OPTARG}
            ;;
        ? | : | h)
            usage
            ;;
    esac
done

# set the obsid to be the first non option
shift  "$(($OPTIND -1))"

# if obsid is empty then just pring help
if [[ -z ${obsnum} ]]
then
    usage
fi


base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/

## copy data ##
script="${base}queue/hrimage_${obsnum}.sh"
cat ${base}bin/hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/hrimage_${obsnum}.o%A"
error="${base}queue/logs/hrimage_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} ${script}"
jobid=($(${sub}))
jobid=${jobid[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid}/"`
output=`echo ${output} | sed "s/%A/${jobid}/"`

echo "Submitter hrimage job as ${jobid}"


