var app = require('express')();
var bodyParser = require('body-parser')

// create application/x-www-form-urlencoded parser
var urlencodedParser = bodyParser.urlencoded({ extended: false })

//Server's IP address
app.set("ipaddr", "10.0.10.205");

var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
  });

});

app.post('/chat',  urlencodedParser, function(req, res) {
	  if (!req.body) 
	  	return res.sendStatus(400)
       
    res.end()
  
  var message = req.body.message;
  
    io.emit('chat message', message);
    
});

http.listen(2080, function(){
  console.log('listening on *:2080');
});
