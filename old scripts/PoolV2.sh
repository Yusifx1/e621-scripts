log=login= # Your e621 login
api=api_key= # Your e621 api key
dwo=no
dump=download

sl=$(echo "$1" | grep -o "e621.net") 
if [[ $sl = "e621.net" ]];then
bp=$(echo "$1" | grep -o "pools[^ ]*" | sed "s|pools/||g" ) 
set $bp $2 $3
fi

if [[ -n $3 ]]; then
dwo=$3
fi
if [[ -n $2 ]]; then
dump=$2
fi
count=1
trap "rm url" EXIT
name=$(curl -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$1.json" | jq -r '.name') 
pid=$(curl -# -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$1.json" | jq -c '.post_ids') 
pid=$(echo ${pid:1:-1}) 
dir=$name
p=1
lc=320
echo "Downloading to $dir" 
if [[ $dwo = yes ]]; then
curl -s -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/posts/{$pid}.json?$log&$api" | jq -r '.post.file.url' |sed "/null/d"  >url
else
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=pool%3A$1+order%3Aid&$log&$api&limit=320&page=$p" |jq -r '.posts[]|.file.url'  |sed "/null/d" >>url
l=$(wc -l url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
fi
if [ $dump = dump ]; then cp url "$name.url";
elif [ $dump = download ] || [ $dump = both ];then
 while read l
do 
e=$(if [[ $l =~ ^.*[.](gif|jpg|png|webm) ]] ;then echo "${l##*.}"; else echo "Corrupted link!!!"; fi)
curl --create-dirs -o "$dir/${count}.$e" -C - $l
count=$((count+1))
done <url
fi
