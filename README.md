# E621-bash-script

Pools, sets and tags  downloader for e621

Basic script that use curl and jq. Curl can be replaced with wget if you want.

Don't blame me pls. It's my first script ever. I writed it with phone on text editor and tested on termux. That's mean this must work on Android. Reason of writing this new api of site and only Android system usage. 


# USAGE

jq and curl needed

bash e621downloader.sh

Select what you want download by typing number

Then type id/shortname or tags

<b> For command line usage:</b>

bash e621downloader.sh "url" - will download pools, sets and tags from url.

bash e621downloader.sh "pool/set/tags" "id/shortname/tags" - if you want change parametrs add "dump/download/both" for download mode and "yes/no" after it if you change set renaming (with order)

If you want run script where you want like "$yiffdownload pool 1" read "Running script where you want" . 

# Examples

bash e621downloader.sh pool 19197 download - this download pool 19197

bash e621downloader.sh set envseries download - this download set shortnamed "envseries" (id is 20313) with default mode (sc=yes) and will not dump url to txt

bash e621downloader.sh https://e621.net/post_sets/20313 - this will download set 20313 (envseries) and dump url

bash e621downloader.sh furry+hat+-dragon+cute dump - this will only dump posts url with furry, hat, cute and without dragon tags to txt. 

+add tag
-exclude added tag

# Parametrs

First paramett - three mode:
dump-dump link with order to txt, 
download-only download, 
both-dump link and download. 

For sets:
Second parametr
sc=on downloads set posts by id with renaming (ordered by creator). sc=no download sets with source name. Default value - no

You can change this settings default value permamently in script first lines. 

# DESCRIPTION
Now all in one. 

Changed separate scripts. Now it work like this:

bash "script name" "poolid or set id/shortname or tags" 

Old selective scripts will be in old scripts folder. 

Dump link work with order. That's mean you can dump pool and then download with pool order. 

I can say this script fully finished. If you find issue or it won't download anything please tell me. I will publish fix as fast as possible.

# FUTURE PLANS

Finally I created my JavaScript project. Use it for better performance and experience.
