echo "Specify the name of the set you would like to download"
read set
curl -s -A "MyProject/1.0 (new api is shit)"  "https://e621.net/posts.json?tags=set%3A$set+order%3Aid" |jq -r '.posts[]|.file.url' >url

xargs -n 1 curl -O -C - <url