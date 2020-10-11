#!/bin/bash

function deleteArchive(){
	file="archive-id-${1}.txt"
	if [[ ! -f $file ]]; then
		"$file does not exist"
		exit 1
	fi
	echo "Deleting all : file=$file, acct=$acct, region=$region, vault=$vault"
	archive_ids=$(cat $file)
	for archive_id in ${archive_ids}; do
		echo "Deleting Archive: ${archive_id}"
		aws --profile=glacier glacier delete-archive --archive-id=${archive_id} --vault-name ${vault} --account-id ${acct} --region ${region}
	done
}

function notifyDone(){
	message=$1
	aws --profile=glacier sns publish --topic=arn:aws:sns:us-east-1:363072288608:admin-notifications --message="$message"
}


if [[ -z ${acct} ]] || [[ -z ${region} ]] || [[ -z ${vault} ]] ; then
	echo "Please set the following environment variables: "
	echo "acct"
	echo "region"
	echo "vault"
	exit 1
fi

deleteArchive 0 &
deleteArchive 1 &
deleteArchive 2 &
deleteArchive 3 &
deleteArchive 4 &

echo "waiting on background jobs"
notifyDone "waiting on background jobs"
wait
notifyDone "Finished Deleting Archives"
echo "Finished deleting archives"

