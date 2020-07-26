log=login= # Your e621 login
api=api_key= # Your e621 api key
dump=download #dump tag url list to txt or download
sc=no #download with renaming or no. Not recomended if set updating or not finish ever
dwo=no #change if you have problem with ordering
count=1 #from what number start renaming

sl=$(echo "$1" | grep -o "e621.net") 
if [[ $sl = "e621.net" ]];then
bp=$(echo "$1" | grep -o "/pools[^ ]*\|sets[^ ]*\|tags[^ ]*" | sed "s|[/=]| |g" ) 
set $bp $2 $3
fi

trap 'rm "$2".url' EXIT
if [[ -n $4 ]]; then
sc=$4
dwo=$4
fi
if [[ -n $3 ]]; then
dump=$3
fi
p=1
lc=320
if [[ pools == $1* ]]; then
name=$(curl -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$2.json" | jq -r '.name') 
dir=$name 
pid=$(curl -# -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$2.json" | jq -c '.post_ids') 
pid=${pid:1:-1}
echo "Getting url of $name pool" 
if [[ $dwo = yes ]]; then
curl -s -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/posts/{$pid}.json?$log&$api" | jq -r '.post.file.url' |sed "/null/d"  >"$2".url
else
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=pool%3A$2+order%3Aid&$log&$api&limit=320&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d">>"$2".url
l=$(wc -l "$2".url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
fi

elif [[ sets == $1* ]]; then
name=$(curl -# -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$2.json" | jq -r '.name') 
echo "Getting url of $name set" 
dir=$name 
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=set%3A$2+order%3Aid&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d">>"$2".url
l=$(wc -l "$2".url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done

elif [[ tags == $1* ]]; then
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=$2&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d" >>"$2".url
l=$(wc -l "$2".url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
name=$(echo "$2" | sed 's/+/ /g' ) 
if [ $dump != download ]; then
cp "$2.url" "$name.url.txt" 
fi
if [ $dump != dump ]; then
for url in $(cat "$2".url) ; do ln=$(basename "$url") ; curl --create-dirs -o "$name/$ln" "$url" -C - ; done
fi
fi
if [ $dump != download ]; then
cp "$2.url" "$name.url.txt" 
fi
if [ $dump != dump ]; then
if [[ sets == $1* ]] && [[ $sc = no ]]; then
for url in $(cat "$2".url ) ; do ln=$(basename "$url") ; curl --create-dirs -o "$name/$ln" "$url" -C - ; done
elif ! [ "$1" = tags ]; then
 while read l
do 
e=$(if [[ $l =~ ^.*[.](gif|jpg|png|webm) ]] ;then echo "${l##*.}"; else echo "Corrupted link!!!"; fi)
curl --create-dirs -o "$dir/${count}.$e" -C - "$l"
count=$((count+1))
done <"$2".url
fi
fi
