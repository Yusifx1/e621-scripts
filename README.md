# e621-scripts
Pool, set, tag and etc downloaders for e621

Basic script that use curl and jq. Work with wget to but i planned for android download less. If you want i can write instruction or script. Now with all in one and removed direction variable selection because it was useless. You can change it in code if you want select directory. Change dir=$"where you want" or $id typed by id begining of script. Also removed base.cfg. Now you should write varibles in main script (allinone.sh)

Don't blame me pls. It's my first script ever. I writed it with phone on text editor and tested on termux. That's mean this must work on Android. Reason of writing this new api of site and only Android system usage. 


# USAGE

jq and curl needed

bash e621downloader.sh

Select what you want download by typing number

Then type id/shortname for set or tags

For command line usage (new seperate scripts and e621downloader-cl only):

bash "script" "id/shortname or tags" if you want change parametrs add "yes/no" 

# Examples

bash pool.sh 19197 yes - this download pool 19197 with dwo mode on (dwo=yes). (NSFW) In this comic you should turn dwo to yes if you want rename with pool order.

bash set.sh envseries - this download set shortnamed "envseries" (id is 20313) with default mode (sc=no) 

bash tagdownloader.sh furry+hat+-dragon+cute dump=no - this will download posts with furry, hat, cute and without dragon tags. 

+add tag
-exclude added tag

# Parametrs

For pools:

Two mode fast(dwo=no) and slow (dwo=yes). If you have problem with order with first mode activate second mode (dwo=yes) (this dependent by pool ordering). Default value - no

For sets:

sc=on downloads set posts by id with renaming (oldest upload first). sc=no download sets with source name. Default value - no

For tag downloader:
dump=yes dump all link to txt for downloading with another downloader or dump=no download with curl

You can change this settings permamently in script first lines. 

# Writing login and API key

log=login=tysh1 # Your e621 login. Tysh1 is my nickname on e621. 

api=api_key=dvgdgd... # Your e621 api key. No my api key not start with dvgdgd i just spammed keyboard. DONT TRY HACK MY E621 ACCOUNT!!! 

# DESCRIPTION
Now all in one. Run script select what you want download by number. Then type id/shortname for set or tags. 

Changed separate scripts. Now it work like this:

bash "script name" "poolid or set id/shortname or tags" 

Old selective scripts will be in old scripts folder. 

# TO-DO (Thanks to savageorange from e621 for help) 

Fix problems listed by savageorange. (İn progress) 

Add progressbar instead curl progress meter (-# not work correct). 

Add function to use both: name and id.


# FUTURE PLANS

Make js (usescript) with this functions with one click. 
Started learning javascript with firefox (I know that chrome better but mobile firefox have extension support with tampermonkey/greasemonkey addon) 
