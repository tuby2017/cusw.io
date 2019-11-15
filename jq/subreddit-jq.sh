#!/bin/bash
## debian extra require: libttspico0 (pico2wave), jq
## usage: ./subreddit-jq.sh 
## final output files: /tmp/r3, /tmp/r3.mp3

cd /tmp/
limit=5 #posts from newest 5
#limit=2

## download json
curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" "https://www.reddit.com/r/trendingsubreddits/.json?limit=$limit" > r1.json

## sort output 
#jq .data.children[].data.title r1.json 
jq -j .data.children[].data.selftext r1.json > r2

#sed -e "/**What's this**/,+5d" r2 > r3
cat r2|sed -e "/**What's this/,+5d; s/[[:space:]]*$//; /^--/d;/^\s*$/d; s/# Trending Subreddits for 2019-/on /; s/^A community for //" |sed -e '/^## \*\*/N;s/\n/. /; s/## \*\*\/\(.*\)\*\*/\1/; s/subscribers.$/subs./; /http\:/d'| sed -e 's/\([[:digit:]]\)\,\([[:digit:]]\)/\1\2/g'|numfmt  --to=si --round=down --invalid=ignore --field 4| awk '!/[[:punct:]]$/ && NF{$NF=$NF"."}1'| tr -d "*" > r3.txt

## tts
pico2wave --wave=r.wav "$(cat r3.txt)" && \
ffmpeg -y -i r.wav -af "treble=g=25,atempo=1.35" -ac 1 -c:a libmp3lame -q:a 2 r3.mp3

exit ##########

## 's/## \*\*\/r\/\(.*\)\*\*/r \1/'
## ... | sed 's@Size: \([0-9]*\)@printf "%s" $(echo \1 | numfmt --to=iec-i --suffix=B)@e'

cat r3 grep '[0-9]'| sed 's/,//g' |numfmt  --to=si --round=down > 

cat r3 |numfmt  --to=si --round=down --invalid=ignore --field 3
rm newline
http://www.pixelbeat.org/docs/numfmt.html
