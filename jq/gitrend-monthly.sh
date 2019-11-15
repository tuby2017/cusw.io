#!/usr/bin/env bash  
# requirment: bash, jq.
# optional: soimort/translate-shell, ffmpeg, libttspico-utils and its dependencies (from synaptic). 
## usage: ./gitrend-monthly.sh 
## final output files: /tmp/gitrend.ogg, /tmp/c2.txt
## blogpost: https://hemisc.neocities.org/b/33.htm
## json source from: Unpublished/GithubTrending

#trans=~/path/to/trans #optional
tmpOut=c2.txt;  
audio=gitrend;
cd /tmp/;  
# file path variables  
jsonOutput=a.json;
sortedOutput=a2.json;
prjsInfo=b;
prjsInfo2=b2;
outxt=c;
# for tts  

: << '@me'
@me
# download data from someone else 
curl https://raw.githubusercontent.com/Unpublished/GithubTrending/trends/trending_monthly-all.json > $jsonOutput

curl https://raw.githubusercontent.com/Unpublished/GithubTrending/trends/trending_monthly-unknown.json >> $jsonOutput

# sort by stars
sed -i 's/\]\[/,/' $jsonOutput
jq -s '.[]|sort_by(.stars)|reverse' $jsonOutput \
> $sortedOutput && \
mv $sortedOutput $jsonOutput 

#exit
# extract prj lang, name by owner,stars into string
# remove " [] blank_lines leading_spaces ,$
# rounding stars number
# remove leading comma, extra comma space, .0K to K,  _ to ' '. add like at end
#
cat $jsonOutput |jq '.|map([.language,.repo+" by "+.owner,(.stars|tostring)]|join(","))' \
| tr -d '"'|sed 's/\[//; s/\]//;/^$/d; s/^[[:space:]]*//; s/,$//;' \
| numfmt  --to=si --round=down --invalid=ignore --delimiter=, --field 3  \
| sed 's/, */, /g; s/\.0K/K/g; s/$/ like/; s/^, //g' \
| tr _ ' ' > $prjsInfo

# extract description
# remove (and stuff inside) :1 perline: ^null$
# replace @ to at
#

cat $jsonOutput | jq '.[].description'|tr -d '"'| \
sed "s/[(][^)]*[)]//g; s/[:][^:]*[:]//g; s/^null$//g; s/@/ at /; " \
> $prjsInfo2

# translate non-english line
## french/german wont be translate, unless there's special char
# remove punctuation, grep non-english line and line number. 
# --> Extract line number and map to array
# using ./trans line by line from match
# 
if [[ -f "$trans" ]]; then
mapfile -t lineNm < <(cat $prjsInfo2 |sed 's/[[:punct:]]//g'|\
 grep -Pn '[^\x00-\x7F]'|\
 cut -f1 -d':')
if [ ${#lineNm[@]} != 0 ]; then
 echo translating;
 for i in "${lineNm[@]}";do n=$(echo "$i");
 ext="$($trans -t en -b "$(sed -n $n\p $prjsInfo2)")" && sleep 1.5;
 sed -i $n"s@.*@$ext@" $prjsInfo2; done
fi
fi


# join $prjsInfo/2 files
# cut off after 258 chars per line, and add . if not exist at end
#
echo "fetch on `date '+%Y %B %d.' `" > $outxt
paste -d "\n" $prjsInfo $prjsInfo2 | sed n\;G|cut -c -258 \
| sed "s/[[:space:]]*$//; s/,$/./"|awk '!/[[:punct:]]$/ && NF{$NF=$NF"."}1' \
| cat -s >> $outxt
find $outxt -exec sed -i '' 's/, */, /g' {} + 2> /dev/null;

#exit # after this line for audio
if ! which pico2wave >/dev/null;then exit;fi

# small correction for $audio's transcript, WIP
if grep -q 'JavaScript' $outxt; then
 find $outxt -exec sed '' -e 's/JavaScript/Java-Script/g; 
 s/.js/ dot JS;/g; s/macos/mac OS/gI; s/OS/ OS/g;' {} + \
 > $tmpOut 2> /dev/null 
 outxt=$tmpOut;
fi;

# tts, output audio. apply treble and speed up filter.
# test filter w/ $ffplay $audio.wav -af treble=g=25:f=2500,atempo=...
if [[ -f "$outxt" ]];then
pico2wave --wave="$audio.wav" "$(cat $outxt)" && \
ffmpeg -y -i "$audio.wav" -map_metadata -1 -c:a libvorbis -af "treble=g=25,atempo=1.35" -ac 1 -q:a 2 "$audio.ogg";
if [[ -f "$audio.wav" ]];then rm "$audio.wav"; fi
fi
exit;
