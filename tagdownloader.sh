dump=both #dump/download/both for only dump url to txt/only download/both
log=login= # Your e621 login
api=api_key= # Your e621 api key

if [[ -n $2 ]]; then
dump=$2
fi
p=1
trap "rm $1" EXIT
lc=320
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.6 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=$1&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' >>$1
l=$(wc -l $1 | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
name=$(echo "$1" | sed 's/+/ /g' ) 
if [ $dump = dump ] || [ $dump = both ]; then
cp "$1" "$name.url.txt" 
fi

if [ $dump = download ] || [ $dump = both ]; then
for url in $(cat $1 ) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url -C - ; done
fi
