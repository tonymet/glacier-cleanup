var AWS = require("aws-sdk");
var es = require('event-stream');

var myConfig = new AWS.Config({
      region: 'us-east-1'
});
var params = {
      accountId: process.env["acct"],
      vaultName: process.env["vault"]
 };

var glacier = new AWS.Glacier({region:"us-east-1"});

function glacierDelete(line, cb){
    let param2 = {accountId:params.accountId, archiveId: line.toString(), vaultName: params.vaultName}
    glacier.deleteArchive(param2, cb)
}

function glacierDelete2(line, cb){
    let param2 = {accountId:params.accountId, archiveId: line.toString(), vaultName: params.vaultName}
    setTimeout(() => {
      cb(null, "sent " + param2.archiveId + "\n")
    }, 50)
}


process.stdin
    .pipe(es.split())
    .pipe(es.map(glacierDelete2))
    .pipe(process.stdout)
