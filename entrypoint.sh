#!/bin/sh -l

dbname=$1
drnum=$2
orgname=$3
waitformerge=$4

if [ -z "$drnum" ]; then
  drnumout=$(pscale deploy-request list $dbname --org $orgname -f json)
  drnum=$(jq -n "$drnumout" | jq -r '.[0].number')
fi

. /.pscale/cli-helper-scripts/wait-for-dr-validation.sh 
wait_for_dr_validation 9 "$dbname" "$drnum" "$orgname" 60

command="pscale deploy-request deploy $dbname $drnum --org $orgname -f json"

cmdout=$(eval $command)

ret=$?
if [ $ret -ne 0 ]; then
  exit $ret
fi

if [ "true" == "$waitformerge" ];then
  . /.pscale/cli-helper-scripts/wait-for-deploy-request-merged.sh
  wait_for_deploy_request_merged 9 "$dbname" "$drnum" "$orgname" 60
fi
