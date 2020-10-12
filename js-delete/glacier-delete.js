var AWS = require("aws-sdk");
var readline = require('readline');

var myConfig = new AWS.Config({
      region: 'us-east-1'
});
var rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
      terminal: false
});

var params = {
      accountId: process.env["acct"],
      // archiveId: "NkbByEejwEggmBz2fTHgJrg0XBoDfjP4q6iu87-TjhqG6eGoOY9Z8i1_AUyUsuhPAdTqLHy8pTl5nfCFJmDl2yEZONi5L26Omw12vcs01MNGntHEQL8MBfGlqrEXAMPLEArchiveId", 
      vaultName: process.env["vault"]
 };

var glacier = new AWS.Glacier({region:"us-east-1"});
var i = 0;
rl.on('line', function(line){
        params.archiveId = line;
        let param2 = {accountId:params.accountId, archiveId: line, vaultName: params.vaultName}
        //console.log(line, param2.archiveId);
        setTimeout(() => {
            let i2 = i
            glacier.deleteArchive(param2, function (err, data) {
            rl.resume();
              if (err) console.log(err, err.stack); // an error occurred
              else{
                  console.log(`[i=${i2}, archiveId = ${param2.archiveId}`)
              }
        })}, 50 * i);
        i++;
})

