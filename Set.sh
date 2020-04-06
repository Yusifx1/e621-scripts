
count=1
echo "Specify the id or shortname of the set you would like to download"
read set

name=`curl -# -A "e621downloader/1.1 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$set.json" | jq -r '.name'`
echo "Downloading $name set" 

curl -s -A "MyProject/1.0 (new api is shit)"  "https://e621.net/posts.json?tags=set%3A$set+order%3Aid" |jq -r '.posts[]|.file.url' >url
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
else echo Corrupted link!!!
fi
curl --create-dirs -o "${name}/${count}.${e}" -C - $l
count=$((count+1))
done <url
