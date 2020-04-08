# e621-scripts
Pool, set, tag and etc downloaders for e621

Basic script that use curl and jq. Work with wget to but i planned for android download less. If you want i can write instruction or script. 

Don't blame me pls. It's my first script ever. I writed it with phone on text editor and tested on termux. That's mean this must work on Android. Reason of writing this new api of site and only Android system usage. 


# USAGE

jq and curl needed

bash "script which you want"

Then type id or name for set

# DESCRIPTION

For pools:

Poolbyid - work litle bit slow but this is best for pool where you need order (this dependent by pool ordering).
 
Poolbytag - fast method sorted by id of post (upload date). 

For sets:

Set - downloads sets by id with renaming (oldest upload first). Limit of e621 is 320 post. 

Setwc -  download sets with source name. 

# TO-DO

Pass e621/e926 limitation. (In progress.) 

Add progressbar instead curl progress meter (-# not work correct). 

Add function to use both: name and id.

Collect all script to one. 

# FUTURE PLANS

Make js (usescript) with this functions with one click. 
