log=login= # Your e621 login
api=api_key= # Your e621 api key
dump=both #dump/download/both for only dump url to txt/only download/both
sc=no #download with renaming or no. Not recommended for sets that dont have order

sl=$(echo "$1" | grep -o "e621.net") 
if [[ $sl = "e621.net" ]];then
bp=$(echo "$1" | grep -o "sets[^ ]*" | sed "s|sets/||g" ) 
set $bp $2 $3
fi

if [[ -n $3 ]]; then
sc=$3
fi
if [[ -n $2 ]]; then
dump=$2
fi
count=1
trap "rm url" EXIT
echo "$dump" 
name=$(curl -# -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$1.json" | jq -r '.name') 
echo "Getting url of $name set" 
dir=$name
p=1
lc=320
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=set%3A$1+order%3Aid&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d" >>url
l=$(wc -l url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done

if [ $dump != download ]; then
cp "url" "$name.url.txt"
fi

if [ $dump != dump ]; then
if [[ $sc = no ]]; then
for url in $(cat url ) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url -C - ; done
else
while read l
do 
e=$(if [[ $l =~ ^.*[.](gif|jpg|png|webm) ]] ;then echo "${l##*.}"; else echo "Corrupted link!!!";fi)
curl --create-dirs -o "$dir/${count}.${e}" -C - $l
count=$((count+1))
done <url
fi
fi