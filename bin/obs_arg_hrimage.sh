#!/bin/bash

usage()
{
echo "obs_arg_hrimage.sh [-t timeStep] [-o obsnum] [-f noChannels]
        -t timeStep	        : the timeStep
	-f noChannels		: no. of channels out (default=768)
        -o obsnum               : the obsid" 1>&2;
exit 1;
}


timeStep=
obsnum=
channels=768

while getopts 't:o:f:' OPTION
do
    case "$OPTION" in
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

script="${base}queue/args_hrimage_${obsnum}.sh"
cat ${base}bin/arg_hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${base}:g"\
                                -e "s:CHANNELS:${channels}:g"\
				-e "s:TIMESTEP:${timeStep}:g" > ${script}
output="${base}queue/logs/hrimage_${obsnum}.o%A"
error="${base}queue/logs/hrimage_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} ${script} "
jobid1=($(${sub}))
jobid1=${jobid1[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid1}/"`
output=`echo ${output} | sed "s/%A/${jobid1}/"`

echo "Submitted asvo job as ${jobid1}"


#timeStep=15
#script="${base}queue/args_hrimage_${obsnum}.sh"
#cat ${base}bin/arg_hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
#                                -e "s:BASE:${base}:g"\
#                                -e "s:CHANNELS:${channels}:g"\
#                                -e "s:TIMESTEP:${timeStep}:g" > ${script}
#output="${base}queue/logs/hrimage_${obsnum}.o%A"
#error="${base}queue/logs/hrimage_${obsnum}.e%A"
#sub="sbatch --begin=now+15 --output=${output} --error=${error} --dependency=afterok:${jobid1} ${script} "
#jobid2=($(${sub}))
#jobid2=${jobid2[3]}
# rename the err/output files as we now know the jobid
#error=`echo ${error} | sed "s/%A/${jobid2}/"`
#output=`echo ${output} | sed "s/%A/${jobid2}/"`
#
#echo "Submitted asvo job as ${jobid2}"
#
#
#timeStep=30
#script="${base}queue/args_hrimage_${obsnum}.sh"
#cat ${base}bin/arg_hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
#                                -e "s:BASE:${base}:g"\
#                                -e "s:CHANNELS:${channels}:g"\
#                                -e "s:TIMESTEP:${timeStep}:g" > ${script}
#output="${base}queue/logs/hrimage_${obsnum}.o%A"
#error="${base}queue/logs/hrimage_${obsnum}.e%A"
#sub="sbatch --begin=now+15 --output=${output} --error=${error} --dependency=afterok:${jobid2} ${script} "
#jobid3=($(${sub}))
#jobid3=${jobid3[3]}
# rename the err/output files as we now know the jobid
#error=`echo ${error} | sed "s/%A/${jobid3}/"`
#output=`echo ${output} | sed "s/%A/${jobid3}/"`
#
#echo "Submitted asvo job as ${jobid3}"


#timeStep=45
#script="${base}queue/args_hrimage_${obsnum}.sh"
#cat ${base}bin/arg_hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
#                                -e "s:BASE:${base}:g"\
#                                -e "s:CHANNELS:${channels}:g"\
#                                -e "s:TIMESTEP:${timeStep}:g" > ${script}
#output="${base}queue/logs/hrimage_${obsnum}.o%A"
#error="${base}queue/logs/hrimage_${obsnum}.e%A"
#sub="sbatch --begin=now+15 --output=${output} --error=${error} --dependency=afterok:${jobid3} ${script} "
#jobid4=($(${sub}))
#jobid4=${jobid4[3]}
## rename the err/output files as we now know the jobid
#error=`echo ${error} | sed "s/%A/${jobid4}/"`
#output=`echo ${output} | sed "s/%A/${jobid4}/"`

#echo "Submitted asvo job as ${jobid4}"

#timeStep=60
#script="${base}queue/args_hrimage_${obsnum}.sh"
#cat ${base}bin/arg_hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
#                                -e "s:BASE:${base}:g"\
#                                -e "s:CHANNELS:${channels}:g"\
#                                -e "s:TIMESTEP:${timeStep}:g" > ${script}
#output="${base}queue/logs/hrimage_${obsnum}.o%A"
#error="${base}queue/logs/hrimage_${obsnum}.e%A"
#sub="sbatch --begin=now+15 --output=${output} --error=${error} --dependency=afterok:${jobid4} ${script} "
#jobid5=($(${sub}))
#jobid5=${jobid5[3]}
## rename the err/output files as we now know the jobid
#error=`echo ${error} | sed "s/%A/${jobid5}/"`
#output=`echo ${output} | sed "s/%A/${jobid5}/"`

#echo "Submitted asvo job as ${jobid5}"






