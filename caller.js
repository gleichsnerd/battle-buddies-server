var request = require('request');

var options = {
  uri: 'http://localhost:8282/game/turn',
  method: 'POST',
  form: {
    action: 'defend',
    direction: 'right',
    player_id: 'de5fee91-6d4e-4c75-b473-64d91076abac'
  }
}

var defend_right = function() {
  request.post('http://localhost:8282/game/turn', options).on('response', function (response) {
      console.log("responded!");
      console.log(response.statusCode);
        if (response.statusCode == 200) {
          console.log("blocking right");
          defend_right();  
        }
    }
  );
}

console.log("start");
defend_right();