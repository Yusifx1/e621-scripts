dump=both #dump/download/both for only dump url to txt/only download/both
log=login= # Your e621 login
api=api_key= # Your e621 api key

sl=$(echo "$1" | grep -o "e621.net") 
if [[ $sl = "e621.net" ]];then
bp=$(echo "$1" | grep -o "tags=[^ ]*" | sed "s|tags=||g" ) 
set $bp $2
fi

if [[ -n $2 ]]; then
dump=$2
fi
p=1
trap "rm $1.url" EXIT
lc=320
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=$1&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d"  >>$1.url
l=$(wc -l $1.url| cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
name=$(echo "$1" | sed 's/+/ /g' ) 
if [ $dump != download ]; then
cp "$1" "$name.url.txt" 
fi

if [ $dump != dump ]; then
for url in $(cat $1.url ) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url -C - ; done
fi
