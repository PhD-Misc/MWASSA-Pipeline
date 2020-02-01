#!/bin/bash

usage()
{
echo "autoSubmitJobs.sh [-d download Link] [-l location] [-c calibration] [-o obsnum] [-a account] [-t tlePath] [-f channels] [-s timeSteps]
	-d download Link	: the ASVO link to download observation
	-l location		: the location, default=pawsey
	-c calibration		: path to calibration solution
	-a account		: pawsey Account to use
	-t tlePath		: path to the tle.txt files
	-f channels		: the number of channels in ms, default=768
	-s timeSteps		: the number of timeSteps in ms, default=56
	-o obsnum		: the obsid" 1>&2;
exit 1;
}

link=
location="pawsey"
calibrationPath=
tlePATH=
obsnum=
account=
channels=768
timeSteps=56

while getopts 'd:l:c:o:a:t:f:s:' OPTION
do
    case "$OPTION" in
        f)
            channels=${OPTARG}
            ;;
        s)
            timeSteps=${OPTARG}
            ;;
        t)
            tlePATH=${OPTARG}
            ;;
        d)
            link=${OPTARG}
            ;;
        l)
            location=${OPTARG}
            ;;
        c)
            calibrationPath=${OPTARG}
            ;;
        o)
            obsnum=${OPTARG}
            ;;
        a) 
            account=${OPTARG}
            ;;
        ? | : | h)
            usage
            ;;
    esac
done

# if obsid is empty then just pring help
if [[ -z ${obsnum} ]]
then
    usage
fi

base=/astro/mwasci/sprabu/satellites/MWASSA-Pipeline/

## copy data ##
script="${base}queue/asvo_${obsnum}.sh"
cat ${base}bin/asvo.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${base}:g" > ${script}

output="${base}queue/logs/asvo_${obsnum}.o%A"
error="${base}queue/logs/asvo_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} -A ${account} ${script} -l ${link} "
jobid1=($(${sub}))
jobid1=${jobid1[3]}

# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid1}/"`
output=`echo ${output} | sed "s/%A/${jobid1}/"`

echo "Submitted asvo job as ${jobid1}"


## run cotter ##
script="${base}queue/cotter_${obsnum}.sh"
cat ${base}/bin/cotter.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                 -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/cotter_${obsnum}.o%A"
error="${base}queue/logs/cotter_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} --dependency=afterok:${jobid1} -A ${account} ${script} -c ${calibrationPath} "
jobid2=($(${sub}))
jobid2=${jobid2[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid2}/"`
output=`echo ${output} | sed "s/%A/${jobid2}/"`

echo "Submitter cotter job as ${jobid2}"


## run hrimage ##
script="${base}queue/hrimage_${obsnum}.sh"
cat ${base}/bin/hrimage.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                 -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/hrimage_${obsnum}.o%A"
error="${base}queue/logs/hrimage_${obsnum}.e%A" 
sub="sbatch --begin=now+15 --output=${output} --error=${error} --dependency=afterok:${jobid2} -A ${account}  ${script} -s ${timeSteps} -f ${channels}"
jobid3=($(${sub}))
jobid3=${jobid3[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid3}/"`
output=`echo ${output} | sed "s/%A/${jobid3}/"`

echo "Submitter hrimage job as ${jobid3}"


## run RFISeeker ##
script="${base}queue/rfiseeker_${obsnum}.sh"
cat ${base}/bin/rfiseeker.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                 -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/rfiseeker_${obsnum}.o%A"
error="${base}queue/logs/rfiseeker_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} -A ${account} --dependency=afterok:${jobid3} ${script} -t ${tlePATH} -s ${timeSteps} -f ${channels}"
jobid4=($(${sub}))
jobid4=${jobid4[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid4}/"`
output=`echo ${output} | sed "s/%A/${jobid4}/"`
echo "Submitter RFISeeker job as ${jobid4}"



## run clear job ##
script="${base}queue/clear_${obsnum}.sh"
cat ${base}/bin/clear.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                 -e "s:BASE:${base}:g" > ${script}
output="${base}queue/logs/clear_${obsnum}.o%A"
error="${base}queue/logs/clear_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} -A ${account} --dependency=afterok:${jobid4} ${script}"
jobid5=($(${sub}))
jobid5=${jobid5[3]}
# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid5}/"`
output=`echo ${output} | sed "s/%A/${jobid5}/"`
echo "Submitter clear job as ${jobid4}"


















