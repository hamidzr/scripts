#!/bin/zsh

# record from a source, aka mic

source_id=$(pick-source.sh $@)

outdir=${HOME}/tmp/recording
mkdir -p ${outdir}
outfile="${outdir}/source-$(dateString.sh).mp3"
channels=2


if [ -z $source_id ]; then
  exit 1
fi

echo "recording to ${outdir}..\n"
parec --channels=${channels} --format=s16le -d ${source_id} | \
  lame -r --quiet -q 3 --lowpass 17 --abr 192 - ${outfile}

