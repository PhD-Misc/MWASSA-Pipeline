#!/bin/bash

usage()
{
echo "autoSubmitJobs.sh [-c calibrator] [-o obsnum]
        -c calibrtor            : the calibrator source 
        -o obsnum               : the obsid" 1>&2;
exit 1;
}

calibrator=
obsnum=

while getopts 'd:l:c:o:' OPTION
do
    case "$OPTION" in
        c)
            calibrator=${OPTARG}
            ;;
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
script="${base}queue/calibrate_${obsnum}.sh"
cat ${base}bin/calibrate.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                  -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/calibrate_${obsnum}.o%A"
error="${base}queue/logs/calibrate_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} ${script} -c ${calibrator} "
jobid=($(${sub}))
jobid=${jobid[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid}/"`
output=`echo ${output} | sed "s/%A/${jobid}/"`

echo "Submitted calibration job as ${jobid}"


