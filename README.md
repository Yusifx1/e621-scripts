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

# Options

  -h,  --help     display help and exit.
  -H, --host      define host to scrape url from (e621.net or e926.net)
  -p, --directory-prefix      directory prefix
  -s, --order      order of scraping. For more info
  --post-limit      count of post on each e621/e926 page (max and default value 320)
  --page-limit      pages to scrape (max and default value 1-750)
 
Arguments:
  some url      script will parse url of e621/e926
  dump/download/both      for only dump url to txt/only download/both
  pool/set/tags      what will being scraped

# FUTURE PLANS

Finally I created my JavaScript project. Use it for better performance and experience.
