#!/bin/bash

#Default values
host=e621.net #use e621 or e926 for scrapping
lockhost=false #use only host value despite url host
prefix=
pagelimit=1-750
postlimit=320
dump=both #dump/download/both for only dump url to txt/only download/both
count=1   #from what number start renaming.
order=default  #order of scraping.If you change "default" value it won't sort pools and sets




usage="\
Usage: $0 [OPTION]...

Options:
  -h,  --help     display this help and exit.
  -H, --host      define host to scrape url from (e621.net or e926.net)
  -p, --directory-prefix      directory prefix
  -s, --order      order of scraping. For more info
  --post-limit      count of post on each e621/e926 page (max and default value 320)
  --page-limit      pages to scrape (max and default value 1-750)
 
Arguments:
  some url      script will parse url of e621/e926
  dump/download/both      for only dump url to txt/only download/both
  pool/set/tags      what will being scraped
"

   while test $# -gt 0; do
           case "$1" in
-h|--help)
      echo "$usage"
      exit 0
      ;;
-H|--host)
                    shift
if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
host=$1
lockhost=true
fi
                    ;;
both|dump|download)
dump=$1
shift
                    ;;
-s|--order)
                 shift
if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
order=$1
shift
fi
                    ;;
-p|--directory-prefix)
                    shift
if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
prefix=$1
shift
fi
                    ;;
--post-limit)
                    shift
if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
postlimit=$1
shift
fi
                    ;;
--page-limit)
                    shift
if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
pagelimit=$1
shift
fi
                    ;;
                pool|pools)
                    shift
                    number=1
 if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
id=$1
echo $id
shift
fi
                    ;;
                set|sets)
                    shift
                    number=2
 if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
id=$1
shift
fi
                    ;;
 tag|tags)
                    shift
                    number=3
 if [[ $1 = -* || -z $1 ]]; then
echo "Argument is empty"
else
id=$1
shift
fi
                    ;;

*)
sl=$(echo "$1" | grep -o 'e621.net\|e926.net') 
if [[ "$sl" = "e621.net" || "$sl" = "e926.net" ]];then
if [[ $lockhost = "false" ]];then
host=$sl
fi
bp=$(echo "$1" | grep -o "/pools[^ ]*\|sets[^ ]*\|tags[^ ]*" | sed 's/pools/1/;s/sets/2/;s/tags/3/;s|[/=]| |g;') 
number=$(echo $bp|cut -d' ' -f1)
id=$(echo $bp|cut -d' ' -f2)
else
echo "Unknown $1 argument or flag"
fi
shift
;;
         
          esac
  done  


trap 'rm -f $id.md5 $id.tmp $id.md $id.url' EXIT

maxpage=$(echo $pagelimit|cut -d'-' -f2)
p=$(echo $pagelimit|cut -d'-' -f1)
lc=1
if [[ -z $number ]]; then
echo "What you want to download (enter selection number) "
echo "1) Pool"
echo "2) Set" 
echo "3) Tags" 
read number
fi

if [[ $number = 1 ]]; then
if [[ -z $id ]]; then
echo "Specify the ID of the pool"
read id 
fi
json=$(curl -A "e621downloader/1.9 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json") 
name=$(jq -r '.name'<<<$json)
id="pool%3A$id"
rid=$(jq -r '.name' <<<$json)

elif [[ $number = 2 ]]; then
if [[ -z $id ]]; then
echo "Specify the id or shortname of the set you would like to download"
read id
fi
json=$(curl -A "e621downloader/1.9 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$id.json") 
id="set%3A$id"
name=$(jq -r '.name'<<<$json)
rid=$(jq -r '.name' <<<$json)

elif [[ $number = 3 ]]; then
if [[ -z $id ]]; then
echo "Specify tag list" 
read id
fi
name=$id
fi

name=$(echo $name|sed 's/_/ /g;s/\//／/g' )
echo "Getting url of $name" 

echo
if [[ $order != "default" ]];then
id+="+order:$order"
fi
while [[ $lc = 1 ]]
do
echo -e "\e[1AGetting page $p"
tmp=$(curl -s -A "e621-downloader/1.9 (Yusifx1/e621-scripts)"  "https://$host/posts.json?tags=$id&limit=$postlimit&page=$p")
jq -r '.posts|map( { (.id|tostring): "\(.file.md5).\(.file.ext)" } )|add'<<<$tmp>>$id.tmp
pc=$(cat $id.tmp| wc -l)
pc=$((pc/p-2))
if [[ $p = $maxpage || $pc != $postlimit ]];then
lc=0
fi

((p++))
done

echo "Extracting urls ... This may take a few minutes"
aa=$(cat $id.tmp| jq -s add)
if [[ $number = 3 || $order != "default" ]];then 
jq -r '.[]' <<<$aa >>$id.md5
else
pids=$(jq '.post_ids[]'<<<$json) 
for pid in $pids
do
jq -r '."'$pid'"' <<<$aa >>$id.md5
done
fi
cut --output-delimiter='/' -c 1-2,3-4 $id.md5>>$id.md

while read md5 && read md <&3
do 
if [[ $md5 = "null" ]];then
echo "">>$id.url
else
echo "https://static1.e621.net/data/$md/$md5">>$id.url
fi
done<$id.md5 3<$id.md

length=$(wc -l <$id.url)
echo ""
echo ""
echo ""


if [ $dump != download ]; then
cp "$id.url" "$prefix$name.url.txt" 
fi

if [ $dump != dump ]; then
 while read l
do 
if [[ -n $l ]];then
ln=$(basename $l)
echo -e "\e[2ADownloading #$count of $length" && curl -# --create-dirs -o "$prefix$name/${count}_$ln" -C - $l 
fi
count=$((count+1))
done <$id.url
fi
