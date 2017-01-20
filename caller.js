var HTTP = require('http');

var options = {
  host: 'localhost',
  port: '4567',
  path: '/game/turn'
}

callback = function(response) {
  var result = '';
  response.on('data', function(chunk) {
    result += chunk;
  });

  response.on('end', function() {
    console.log(result);
  });
}

console.log("starting loop");


function chain() {
  HTTP.get(options, callback).on('error', function(e) {
      console.log(e);
  });
}

for(var i = 0; i < 100; i++) {
  chain();
}