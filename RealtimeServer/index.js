const content = require('fs').readFileSync(__dirname + '/index.html', 'utf8');

const httpServer = require('http').createServer((req, res) => {
  // serve the index.html file
  res.setHeader('Content-Type', 'text/html');
  res.setHeader('Content-Length', Buffer.byteLength(content));
  res.end(content);
});

const io = require('socket.io')(httpServer);

io.on('connection', socket => {
  console.log('connected');

  socket.on('message', (data) => {
    io.emit('message',data);
    console.log(data);
  });

  socket.on('LocationUpdated', (data) => {
    io.emit('position',data);
    console.log(data);
  });

  socket.on('NewOrder', (data) => {
    io.emit('new',data);
    console.log(data);
    //io.emit('message', data);
  });

});

httpServer.listen(3000, () => {
  console.log('go to http://localhost:3000');
});