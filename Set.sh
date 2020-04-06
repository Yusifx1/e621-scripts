savedir=name   #Save file in folder named by id or name

count=1
echo "Specify the id or shortname of the set you would like to download"
read set
if [[ $savedir = id ]]; then
if ! [[ -d $set ]]; then
mkdir $set
else
echo "updating pool $set"
fi

elif [[ $savedir = name ]]; then
name=`curl -# -A "e621downloader/1.1 (Yusifx1/e621-scripts)" "https://e621.net/post_sets/$set.json" | jq -r '.name'`
if ! [[ -d $name ]]; then
mkdir $name
savedir="$name"
else
savedir="$name"
echo "updating pool $name"
fi
fi

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
curl -o "${savedir}/${count}.${e}" -C - $l
count=$((count+1))
done <url
