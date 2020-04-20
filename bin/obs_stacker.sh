#!/bin/bash

usage()
{
echo "obs_stacker.sh [-t timeStep] [-o obsnum] [-f noChannels] [-n noraid]
        -t timeStep	        : the timeStep
	-n norardid		: the satellite norad id
	-f noChannels		: no. of channels out (default=768)
        -o obsnum               : the obsid" 1>&2;
exit 1;
}


timeStep=
obsnum=
channels=768
noradid=

while getopts 't:o:f:n:' OPTION
do
    case "$OPTION" in
        n)
            noradid=${OPTARG}
            ;;
        t)
            timeStep=${OPTARG}
            ;;
	f)
	    channels=${OPTARG}
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

script="${base}queue/stacker_${obsnum}.sh"
cat ${base}bin/stacker.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${base}:g"\
                                -e "s:CHANNELS:${channels}:g"\
                                -e "s:SAT:${noradid}:g" \
				-e "s:TIMESTEP:${timeStep}:g" > ${script}
output="${base}queue/logs/stacker_${obsnum}.o%A"
error="${base}queue/logs/stacker_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} ${script} "
jobid1=($(${sub}))
jobid1=${jobid1[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid1}/"`
output=`echo ${output} | sed "s/%A/${jobid1}/"`

echo "Submitted asvo job as ${jobid1}"

