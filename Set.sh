count=1
echo "Specify the name of the set you would like to download"
read set
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
curl -o "${count}.${e}" -C - $l
count=$((count+1))
done <url