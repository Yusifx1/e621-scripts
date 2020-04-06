count=1
echo "Specify the ID of the pool you would like to download"
read pid
bid=`curl -# -A "MyProject/1.0 (new api is shit)" "https://e621.net/pools/$pid.json" | jq -c '.post_ids'`
id=`echo ${bid:1:-1}`
curl -s -A "MyProject/1.0 (new api is shit)" https://e621.net/posts/{$id}.json | jq -r '.post.file.url' |sed "/null/d"  >url
 while read l
do 
if [[ $l =~ ^.*gif.*$ ]]; then
e=gif
elif [[ $l =~ ^.*jpg.*$ ]]; then
e=jpg
elif [[ $l =~ ^.*png.*$ ]]; then
e=png
elif [[ $l =~ ^.*webm.*$ ]]; then
e=webm
else 
echo Corrupted link!!!
fi
curl -o "${pid}/${count}.${e}" -C - $l
count=$((count+1))
done <url
