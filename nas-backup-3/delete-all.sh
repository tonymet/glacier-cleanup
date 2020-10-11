#!/bin/bash

function deleteArchive(){
	file="archive-id-${1}.txt"
	if [[ ! -f $file ]]; then
		"$file does not exist"
		exit 1
	fi
	echo "Deleting all : file=$file, acct=$acct, region=$region, vault=$vault"
	archive_ids=$(cat $file)
	i=0
	for archive_id in ${archive_ids}; do
		if [[ $i -lt $offset ]]; then
			echo "skipping $archive_id"
			i=$((i+1))
			continue;
		fi
		echo "[$file, $i] del ${archive_id}"
		aws --profile=glacier glacier delete-archive --archive-id=${archive_id} --vault-name ${vault} --account-id ${acct} --region ${region}
		# notify every 500
		i=$((i+1))
		if [[ $((i % 500)) -eq 0 ]]; then
			notifyDone "file $file done $i"
		fi
	done
}

function notifyDone(){
	message=$1
	aws --profile=glacier sns publish --topic=arn:aws:sns:us-east-1:363072288608:admin-notifications --message="$message"
}


if [[ -z ${acct} ]] || [[ -z ${region} ]] || [[ -z ${vault} ]] || [[ -z ${offset} ]]  ; then
	echo "Please set the following environment variables: "
	echo "acct"
	echo "region"
	echo "vault"
	echo "offset"
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

