log=login=tysh1 # Your e621 login
api=api_key=7a8429d29a464c521953550c97e28692 # Your e621 api key
dump=no #dump tag url list to txt or download
sc=no #download with renaming or no. Not recomended if set updating or not finish ever
dwo=no #change if you have problem with ordering
count=1 #from what number start renaming

dump=$3
sc=$3
dwo=$3
p=1
lc=320
if [[ $1 = pool ]]; then
trap "rm $2.url" EXIT
name=`curl -A "e621downloader/1.5 (Yusifx1/e621-scripts)" "https://e621.net/pools/$2.json" | jq -r '.name'`
dir=$name 
pid=`curl -# -A "e621downloader/1.5 (Yusifx1/e621-scripts)" "https://e621.net/pools/$2.json" | jq -c '.post_ids'`
pid=`echo ${pid:1:-1}`
echo "Downloading to $dir" 
if [[ $dwo = yes ]]; then
curl -s -A "e621downloader/1.5 (Yusifx1/e621-scripts)" "https://e621.net/posts/{$pid}.json?$log&$api" | jq -r '.post.file.url' |sed "/null/d"  >$2.url
else
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.5 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=pool%3A$2+order%3Aid&$log&$api&limit=320&page=$p" |jq -r '.posts[]|.file.url' >>$2.url
l=`wc -l $2.url | cut -f1 -d' '`
lc=`echo $((l/p))`
p=$((p+1))
done
fi

elif [[ $1 = set ]]; then
trap "rm $2.url" EXIT
name=`curl -# -A "e621downloader/1.5 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$2.json" | jq -r '.name'`
echo "Getting url of $name set" 
dir=$name 
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.5 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=set%3A$2+order%3Aid&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' >>$2.url
l=`wc -l $2.url | cut -f1 -d' '`
lc=$((l/p))
p=$((p+1))
done

elif [[ $1 = tag ]]; then
trap "rm $2.url" EXIT
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.5 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=$2&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' >>$2.url
l=`wc -l $2.url | cut -f1 -d' '`
lc=$((l/p))
p=$((p+1))
done
name=$(echo "$2" | sed 's/+/ /g' ) 
if [ $dump = yes ]; then
cp "$2.url" "$name.txt" 
else
for url in $(cat $2.url) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url -C - ; done
fi
fi

if [[ $1 = set ]] && [[ $sc = no ]]; then
for url in $(cat $2.url ) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url -C - ; done
elif ! [ $1 = tag ]; then
 while read l
do 
e=$(if [[ $l =~ ^.*[.](gif|jpg|png|webm) ]] ;then echo "${l##*.}"; else echo "Corrupted link!!!"; fi)
curl --create-dirs -o "$dir/${count}.$e" -C - $l
count=$((count+1))
done <$2.url
fi