#!/bin/bash

TOKEN="1938599872:AAFYrS9Og7ip_jvnJkJZInpiZ-eanL5-sPQ"
ID="634331220"
WALLET="aris98"

URL="https://api.telegram.org/bot$TOKEN/sendMessage" 
MSG="ᕲ DuinoCoin" 
JSON=$(curl -s -X GET https://server.duinocoin.com/users/$WALLET -H "Accept: application/json" | jq .) 
JSON2=$(curl -s -X GET https://server.duinocoin.com/api.json -H "Accept: application/json" | jq .) 
BALANCE=$(echo $JSON | jq '.result.balance.balance') 
USER=$(echo $JSON | jq '.result.balance.username') 
WORKERS=$(echo $JSON | jq '.result.miners' | jq '.[].identifier') 
ALL=$(echo $JSON | jq '.result.miners[]' | jq '"\n"+.identifier +"\nACC/REJECT: "+  
(.accepted|tostring) +"/"+ (.rejected|tostring) +"\nHASHRATE: "+ (.hashrate|tostring)  
+"\nDIFFICULTY: "+ (.diff|tostring)+"\n"') 
PRICE=$(echo $JSON2 | jq '(."Duco price"|tostring)') 
PRIUP=$(echo $JSON2 | jq '."Last update"') 
 
if [ $? -ne 0 ] 
then 
        exit 0 
else 
        /usr/bin/curl -s -X POST $URL \ 
                -d chat_id=$ID \ 
                -d parse_mode=HTML \ 
                -d text="$(printf "$MSG\n\t\t- \U1F435 Username: <code>$USER</code>\n\t\t- \U1FA99 Balance: <code><code>$BALANCE</code>\n\t\t- \U1F4B8 Price: <code>$PRICE</code>\n\t\t- \U1F550 Price Update:\n <code>$PRIUP</code>\n\t\t- \U26CF Workers:\n\n<code>$ALL</code>")" \ 
                > /dev/null 2>&1 
        exit 0 
fi
