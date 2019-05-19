#!/bin/bash
# This script grabs a screenshot both from aiqcn and iboca in order to make a daily snapshot of the service
# Feel free to suggest improvements, or clone it and make it happen in your own server
# or modify and redistribute it to suit your needs

# You need the environment vars
# LOCAL_FILE Local directory where you will store your screenshots
# BROWSHOT_KEY Key for the browshot service
# COMMITER_EMAIL Email to be used in git history
# COMMITER_NAME Who configured the service
# AUTH_TOKEN An oauth token for github API
# INFIX_FILE Name of the file with date to be used
# AIQCN_FILE file name for the aiqcn service
# IBOCA_FILE file name for the iboca service

GIT_PATH="https://api.github.com/repos/kike-canaries/collected-data/contents/co/bog/ibocapm25/images/"
curl -L "https://api.browshot.com/api/v1/simple?url=https://aqicn.org/map/bogota/&key=$BROWSHOT_KEY" -o $LOCAL_FILE$AIQCN_FILE
curl -L "https://api.browshot.com/api/v1/simple?url=http://iboca.ambientebogota.gov.co/mapa&key=$BROWSHOT_KEY" -o $LOCAL_FILE$IBOCA_FILE
(echo -n '{"message": "Uploaded '; echo $AIQCN_FILE; echo '", "committer": {"name": "'; echo $COMMITER_NAME; echo '", "email": "'; echo $COMMITER_EMAIL; echo '"}, "content": "'; base64 $LOCAL_FILE$AIQCN_FILE; echo '"}') | curl -vvv -X PUT -H "Content-Type: application/json" -H "Authorization: token $AUTH_TOKEN" -d @- $GIT_PATH$AIQCN_FILE
(echo -n '{"message": "Uploaded '; echo $IBOCA_FILE; echo '", "committer": {"name": "'; echo $COMMITER_NAME; echo '", "email": "'; echo $COMMITER_EMAIL; echo '"}, "content": "'; base64 $LOCAL_FILE$IBOCA_FILE; echo '"}') | curl -vvv -X PUT -H "Content-Type: application/json" -H "Authorization: token $AUTH_TOKEN" -d @- $GIT_PATH$IBOCA_FILE
