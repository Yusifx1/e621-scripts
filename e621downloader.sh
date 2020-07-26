
dump=both #dump/download/both for only dump url to txt/only download/both
count=1   #from what number start renaming.
#for set
sc=yes    #download with renaming or no.




sl=$(echo "$1" | grep -o "e621.net") 
if [[ $sl = "e621.net" ]];then
bp=$(echo "$1" | grep -o "/pools[^ ]*\|sets[^ ]*\|tags[^ ]*" | sed "s|[/=]| |g" ) 
set $bp $2 $3
fi

echo "$1rr$2rr$3"

trap 'rm -f $id.md5 $id.url' EXIT

if [[ -n $4 ]]; then
sc=$4
fi
if [[ -n $3 ]]; then
dump=$3
fi

p=1
lc=320
if [[ -n $1 ]]; then number=$(echo $1|sed 's/pools/1/g;s/pool/1/g;s/sets/2/g;s/set/2/g;s/tags/3/g;')
else
echo "What you want to download (enter selection number) "
echo "1) Pool"
echo "2) Set" 
echo "3) Tags" 
read number
fi

if [[ $number = 1 ]]; then

if [[ -n $2 ]]; then id=$2
else
echo "Specify the ID of the pool"
read id 
fi
json=$(curl -s -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json") 
name=$(echo $json | jq -r '.name')
id="pool%3A$id"

elif [[ $number = 2 ]]; then
if [[ -n $2 ]]; then id=$2
else
echo "Specify the id or shortname of the set you would like to download"
read id
fi
json=$(curl -s -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$id.json") 
id="set%3A$id"
name=$(echo $json | jq -r '.name')

elif [[ $number = 3 ]]; then
if [[ -n $2 ]]; then id=$2
else
echo "Specify tag list" 
read id
fi
name=$id
fi

name=$(echo $name|sed 's/_/ /g;s/\//／/g' )
echo "Getting url of $name" 

if [[ $number = 3 ]];then 
pids=".id"
else
pids=$(echo $json | jq '.post_ids[]') 
fi
echo
while [ $lc = 320 ] 
do
echo -e "\e[1AGetting page $p"
pagejson+=$(curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=$id&limit=320&page=$p" |jq -r '.posts[]')
pc=$(echo $pagejson|jq '.id' | wc -l)
lc=$((pc/p))
((p++))
done

for pid in $(echo $pids)
do
echo $pagejson|jq -r 'select(.id=='$pid')|.file | "\(.md5).\(.ext)"'>>$id.md5
done


while read md5
do 
m2=$(echo $md5|cut -c 1-2)
m4=$(echo $md5|cut -c 3-4)
echo "https://static1.e621.net/data/$m2/$m4/$md5">>$id.url
done<$id.md5
echo "Downloading $name"
length=$(wc -l <$id.url)
echo 
echo 
echo
if [ $dump != download ]; then
mkdir -p "$name" && cp "$id.url" "$name.url.txt" 
fi
if [ $dump != dump ]; then
if [[ $number = 3 ]] || [[ $sc = no && $number = 2 ]]; then
for url in $(cat $id.url) ; do ln=$(basename $url) ; echo -e "\e[2ADownloading #$count of $length" && curl -# --create-dirs -o "$name/$ln" $url -C - ; count=$((count+1)); done
else
 while read l
do 
e=$(if [[ $l =~ ^.*[.](gif|jpg|png|swf|webm) ]] ;then echo "${l##*.}"; else echo "Corrupted link!!!"; fi)

echo -e "\e[2ADownloading #$count of $length" && curl -# --create-dirs -o "$name/${count}.$e" -C - $l 
count=$((count+1))
done <$id.url
fi
fi

