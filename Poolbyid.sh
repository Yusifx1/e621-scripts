count=1
echo "Specify the ID of the pool you would like to download"
read id
name=`curl -A "e621downloader/1.2 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json" | jq -r '.name'`
pid=`curl -# -A "e621downloader/1.2 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json" | jq -c '.post_ids'`
pid=`echo ${pid:1:-1}`
dir=$name
source base.cfg
echo "Downloading to $dir" 
curl -s -A "e621downloader/1.2 (Yusifx1/e621-scripts)" "https://e621.net/posts/{$pid}.json?$log&$api" | jq -r '.post.file.url' |sed "/null/d"  >url
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
done <url
 <url
