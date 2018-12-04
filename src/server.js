const express = require('express');
const redis = require('redis');
const async = require('async');
const winston = require('winston');

let client = redis.createClient();
let app = express();

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.Console()
    ]
});

client.on('error', function (err) {
    console.log('Error ' + err)
});

app.get('/', function (req, res) {
    var timestamp = +new Date();
    var total_count = 0;
    var deleted = 0 ;
    client.incr(timestamp);
    client.keys('*', function (err, keys) {
        if (err) {
            res.json(err)
            return
        }
        if (keys) {
            async.map(keys, function (key, cb) {
                client.get(key, function (error, value) {
                    if (error) return cb(error);
                    var job = {};
                    job['jid'] = key;
                    job['data'] = value;
                    cb(null, job);
                });
            },
            function (error, results) {
                if (error) return console.log(error);

                results.map(function (item) {

                    var ts = parseInt(item['jid']);
                    var count = parseInt(item['data']);

                    if (timestamp - ts > 60000) {
                        client.del(ts);
                        deleted = deleted + 1;
                    }
                    else {
                        if (count >= 1){
                            total_count = total_count + count;
                        }

                    }
                });
                res.json({'count': total_count, 'deleted': deleted});
            });
        }
        else{
            res.json({'count': 0, 'deleted': deleted});
        }
    });

});

app.listen(8080, function () {
    console.log('My app listening on port 3000!');
});