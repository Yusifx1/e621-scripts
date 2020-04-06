# e621-scripts
Pool, set, tag and etc downloaders for e621

Don't blame me pls. It's my first script ever and I learned all this in one day. I writed it with phone on notebook and tested on termux. That's mean this must wornk on Android. Reason of this new api of site and  

#USAGE

jq needed

bash "script which you want"

Then type id or name for set

#DESCRIPTION

For pools:

Poolbyid - work litle bit slow but this is best for pool where you need order (this dependent by pool ordering).
 
Poolbytag - fast method sorted by id of post (upload date). 

For sets:

Set - downloads sets by id with renaming (oldest upload first). 

Setwc - faster download sets with source name. 

#TO-DO

Add progressbar instead curl progress meter (-# not work correct). 

Add function to use both: name and id.

Collect all script to one. 
