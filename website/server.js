var express     = require('express'),
    http        = require('http'),
    path        = require('path'),
    socketio    = require('socket.io'),
    app         = express(),
    io,
    server;

//Routers behave like middleware themselves and can be ".use()'d" by the app or in other routers
var router = express.Router();

// Environment Settings
app.set('port', process.env.PORT || 3000 );

// Middleware
app.use(express.favicon());
app.use(express.bodyParser());
app.use(express.compress());
app.use(express.static(path.join(__dirname, 'public')));

// Routing
app.get('/', function (req, res) {
    res.render('index');
});


// Create Server
server = http.createServer(app);

// Bind Socket.io
io = socketio.listen(server);

// Start Server
server.listen(app.get('port'), function () {
    console.log('Server listening on port ' + app.get('port'));
});

// Handle Socket Connections
io.on('connection', function (socket) {
    setTimeout(function () {
    	socket.emit('lub');
    }, 1000)
});

