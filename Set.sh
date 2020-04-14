log=login= # Your e621 login
api=api_key= # Your e621 api key
sc=no #download with renaming or no. Not recommended for updating set

sc=$2
count=1
trap "rm url" EXIT
name=`curl -# -A "e621downloader/1.5 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$1.json" | jq -r '.name'`
echo "Getting url of $name set" 
dir=$name
p=1
lc=320
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.3 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=set%3A$1+order%3Aid&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' >>url
l=`wc -l url | cut -f1 -d' '`
lc=`echo $((l/p))`
p=$((p+1))
done
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
