#!/bin/bash

usage()
{
echo "obs_arg_hrimage.sh [-t timeStep] [-o obsnum]
        -t timeStep	        : the timeStep
        -o obsnum               : the obsid" 1>&2;
exit 1;
}


timeStep=
obsnum=

while getopts 't:o:' OPTION
do
    case "$OPTION" in
        t)
            timeStep=${OPTARG}
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

script="${base}queue/args_hrimage_${obsnum}.sh"
cat ${base}bin/arg_hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${base}:g"\
				-e "s:TIMESTEP:${timeStep}:g" > ${script}
output="${base}queue/logs/hrimage_${obsnum}.o%A"
error="${base}queue/logs/hrimage_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} ${script} "
jobid=($(${sub}))
jobid=${jobid[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid}/"`
output=`echo ${output} | sed "s/%A/${jobid}/"`

echo "Submitted asvo job as ${jobid}"




