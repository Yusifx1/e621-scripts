count=1
echo "Specify the ID of the pool you would like to download"
read id
name=`curl -A "e621downloader/1.3 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json" | jq -r '.name'`
pid=`curl -# -A "e621downloader/1.3 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json" | jq -c '.post_ids'`
pid=`echo ${pid:1:-1}`
dwo=no
dir=$name
p=1
lc=320
source base.cfg
echo "Downloading to $dir" 
if [[ $dwo = yes ]]; then
curl -s -A "e621downloader/1.3 (Yusifx1/e621-scripts)" "https://e621.net/posts/{$pid}.json?$log&$api" | jq -r '.post.file.url' |sed "/null/d"  >url
else
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.3 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=pool%3A$id+order%3Aid&$log&$api&limit=320&page=$p" |jq -r '.posts[]|.file.url' >>url
l=`wc -l url | cut -f1 -d' '`
lc=`echo $((l/p))`
p=$((p+1))
done
fi
 while read l
do 
if [[ $l =~ ^.*gif ]]; then
e=gif
elif [[ $l =~ ^.*jpg ]]; then
e=jpg
elif [[ $l =~ ^.*png ]]; then
e=png
elif [[ $l =~ ^.*webm ]]; then
e=webm
else 
echo Corrupted link!!!
fi
curl --create-dirs -o "$dir/${count}.$e" -C - $l
count=$((count+1))
done <url && rm url
