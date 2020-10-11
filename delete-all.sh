#!/bin/bash

file='./output.json'

if [[ -z ${acct} ]] || [[ -z ${region} ]] || [[ -z ${vault} ]]; then
	echo "Please set the following environment variables: "
	echo "acct"
	echo "region"
	echo "vault"
	exit 1
fi

echo "Deleting all : acct=$acct, region=$region, vault=$vault"
archive_ids=$(jq .ArchiveList[].ArchiveId < $vault/$file)

for archive_id in ${archive_ids}; do
    echo "Deleting Archive: ${archive_id}"
    aws glacier delete-archive --archive-id=${archive_id} --vault-name ${vault} --account-id ${acct} --region ${region}
done

echo "Finished deleting archives"
