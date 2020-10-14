var AWS = require("aws-sdk");
var split2 = require("split2");
const util = require('util');


const Transform = require('stream').Transform
class GlacierDelete2 extends Transform {
    _transform(chunk, encoding, cb) {
        glacierDelete2(chunk, cb)
    }
}
class GlacierDelete extends Transform {
    _transform(chunk, encoding, cb) {
        glacierDelete(chunk, cb)
    }
}
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
    }, 200)
}


process.stdin
    .pipe(split2())
    .pipe(new GlacierDelete2)
    .pipe(process.stdout)
