Sorry I am bussy for last days. I will contine if I get time.
# e621-scripts

Pool, set, tag and etc downloaders for e621

Basic script that use curl and jq. If you want you can wget url list. Removed direction variable selection because it was useless. You can change it in code if you want select directory. Change dir=$"where you want" or $id typed by id begining of script. Also removed base.cfg. Now you should write varibles in main script (allinone.sh)

Don't blame me pls. It's my first script ever. I writed it with phone on text editor and tested on termux. That's mean this must work on Android. Reason of writing this new api of site and only Android system usage. 


# USAGE

jq and curl needed

bash e621downloader.sh

Select what you want download by typing number

Then type id/shortname for set or tags

For command line usage (new seperate scripts and e621downloader-cl only):

bash "script" "id/shortname or tags or e621 url" if you want change parametrs add "download parametrs dump/download/both" and "yes/no" 

If you want run script where you want like "$yiffdownload pool 1" read "Running script where you want" . 

# Examples

bash pool.sh 19197 download yes - this download pool 19197 with dwo mode on (dwo=yes). (NSFW) In this comic you should turn dwo to yes if you want rename with pool order.

bash set.sh envseries both - this download set shortnamed "envseries" (id is 20313) with default mode (sc=no) and dump url to txt

bash e621downloader-cl https://e621.net/post_sets/20313 - this will download set 20313 (envseries) 

bash tagdownloader.sh furry+hat+-dragon+cute dump - this will only dump posts url with furry, hat, cute and without dragon tags to txt. 

+add tag
-exclude added tag

# Parametrs

dump - three mode:dump-dump link with order to txt, download-only download, both-dump link and download. 

For pools:

Two mode fast(dwo=no) and slow (dwo=yes). If you have problem with order with first mode activate second mode (dwo=yes) (this dependent by pool ordering). Default value - no

For sets:

sc=on downloads set posts by id with renaming (oldest upload first). sc=no download sets with source name. Default value - no

You can change this settings default value permamently in script first lines. 

# Writing login and API key

log=login=tysh1 # Your e621 login. Tysh1 is my nickname on e621. 

api=api_key=dvgdgd... # Your e621 api key. No my api key not start with dvgdgd i just spammed keyboard. DONT TRY HACK MY E621 ACCOUNT!!! 

# DESCRIPTION
Now all in one. Run script select what you want download by number. Then type id/shortname for set or tags. 

Changed separate scripts. Now it work like this:

bash "script name" "poolid or set id/shortname or tags" 

Old selective scripts will be in old scripts folder. 

Dump link work with order. That's mean you can dump pool and then download with pool order. 

# TO-DO (Thanks to savageorange from e621 for help) 

Add progressbar instead curl progress meter (-# not work correct). 

Do something (make some improvement). Request your wish in this link e621:https://e621.net/forum_topics/26089

# FUTURE PLANS

Finally I created my JavaScript project. Future plans now there.
