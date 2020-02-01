#!/bin/bash

usage()
{
echo "autoSubmitJobs.sh [-d download Link] [-o obsnum]
        -d download Link        : the ASVO link to download observation
        -o obsnum               : the obsid" 1>&2;
exit 1;
}

link=
obsnum=

while getopts 'd:o:' OPTION
do
    case "$OPTION" in
        d)
            link=${OPTARG}
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

script="${base}queue/asvo_${obsnum}.sh"
cat ${base}bin/asvo.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/asvo_${obsnum}.o%A"
error="${base}queue/logs/asvo_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} ${script} -l ${link} "
jobid=($(${sub}))
jobid=${jobid[3]}

# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid}/"`
output=`echo ${output} | sed "s/%A/${jobid}/"`

echo "Submitted asvo job as ${jobid}"




