log=login= # Your e621 login
api=api_key= # Your e621 api key
dump=both #dump/download/both for only dump url to txt/only download/both
#for set
sc=no #download with renaming or no. Not recomended if set not with order
#for pool
dwo=no #change if you have problem with ordering
count=1 #from what number start renaming

trap 'rm $id.url' EXIT
p=1
lc=320
echo "What you want to download (enter selection number) "
echo "1) Pool"
echo "2) Set" 
echo "3) Tags" 
read number
if [[ $number = 1 ]]; then
echo "Specify the ID of the pool you would like to download"
read id
name=$(curl -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json" | jq -r '.name') 
dir=$name 
pid=$(curl -# -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/pools/$id.json" | jq -c '.post_ids') 
pid=${pid:1:-1}
echo "Downloading to $dir" 
if [[ $dwo = yes ]]; then
curl -s -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/posts/{$pid}.json?$log&$api" | jq -r '.post.file.url' |sed "/null/d"  >$id.url
else
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=pool%3A$id+order%3Aid&$log&$api&limit=320&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d" >>$id.url
l=$(wc -l $id.url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
fi

elif [[ $number = 2 ]]; then
echo "Specify the id or shortname of the set you would like to download"
read id
name=$(curl -# -A "e621downloader/1.7 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$id.json" | jq -r '.name') 
echo "Getting url of $name set" 
dir=$name 
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=set%3A$id+order%3Aid&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d" >>$id.url
l=$(wc -l $id.url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done

elif [[ $number = 3 ]]; then
echo "Specify tag list" 
read id
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.7 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=$id&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' |sed "/null/d" >>$id.url
l=$(wc -l $id.url | cut -f1 -d' ') 
lc=$((l/p))
p=$((p+1))
done
name=$(echo "$id" | sed 's/+/ /g' ) 
echo "Dump to $name.txt or download (write 1 for dump 2 for download"
read t
if [ $t = 1 ]; then
cp "$id.url" "$name.txt" 
else
for url in $(cat $id.url) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url -C - ; done
fi
fi
if [ $dump != download ]; then
cp "$id.url" "$name.url.txt" 
fi
if [ $dump != dump ]; then
if [ $number = 2 -a $sc = no ]; then
for url in $(cat $id.url ) ; do ln=$(basename $url) ; curl --create-dirs -o "$name/$ln" $url ; done
elif ! [ $number = 3 ]; then
 while read l
do 
e=$(if [[ $l =~ ^.*[.](gif|jpg|png|webm) ]] ;then echo "${l##*.}"; else echo "Corrupted link!!!"; fi)
curl --create-dirs -o "$dir/${count}.$e" -C - $l
count=$((count+1))
done <$id.url
fi
fi