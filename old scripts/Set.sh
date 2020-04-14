
count=1
echo "Specify the id or shortname of the set you would like to download"
read id
name=`curl -# -A "e621downloader/1.3 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$id.json" | jq -r '.name'`
echo "Getting url of $name set" 
dir=$name
sc=yes
source base.cfg
p=1
lc=320
while true;do echo -n .;sleep 1;done & 
while [ $lc = 320 ] 
do
curl -s -A "e621-downloader/1.3 (Yusifx1/e621-scripts)"  "https://e621.net/posts.json?tags=set%3A$id+order%3Aid&limit=320&$log&$api&page=$p" |jq -r '.posts[]|.file.url' >>url
l=`wc -l url | cut -f1 -d' '`
lc=`echo $((l/p))`
p=$((p+1))
done
kill $!; 
if [[ $sc = no ]]; then
xargs -n 1 curl -O -C - <url
else
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
else echo Corrupted link!!!
fi
curl --create-dirs -o "$dir/${count}.${e}" -C - $l
count=$((count+1))
done <url
fi
rm url
