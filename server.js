const Pusher = require('pusher');
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const pusher = new Pusher({
  appId: '1841463',
  key: '38d0122e284cfacbf6d5',
  secret: 'b20b930041015f1ae34b',
  cluster: 'ap2',
  useTLS: true

});

const app = express();
app.use(bodyParser.json());
app.use(cors());

app.post('/send-message', (req, res) => {
console.log('Received message:', req.body);
  const { channel, message, sender } = req.body;

  if (!channel || !message || !sender) {
    return res.status(400).send({ error: 'Channel, message, and sender are required' });
  }

  pusher.trigger(channel, 'message', { message, sender });
  res.sendStatus(200);
  res.send('Message received');
});

/*app.post('/send-message', (req, res) => {
console.log('Received message:', req.body);
  const { from_id, to_id, message} = req.body;

  if (!from_id || !to_id || !message) {
    return res.status(400).send({ error: 'Channel, message, and sender are required' });
  }

  pusher.trigger('private-chatify.3', 'messaging', { message,from_id,to_id});
  res.sendStatus(200);
  res.send('Message received');
});*/

const port = 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});






/*
const Pusher = require('pusher');

const pusher = new Pusher({
  appId: '1841463',
  key: '38d0122e284cfacbf6d5',
  secret: 'b20b930041015f1ae34b',
  cluster: 'ap2',
  useTLS: true
});

module.exports = pusher;
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

app.post('/send-message', (req, res) => {
  const { channel, message } = req.body;

  if (!channel || !message) {
    return res.status(400).send({ error: 'Channel and message are required' });
  }

  pusher.trigger(channel, 'message', { message });

  res.sendStatus(200);
});

const port = 3000;

app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});
*/




//*/
//const express = require('express');
//const bodyParser = require('body-parser');
//const Pusher = require('pusher');
//
//const app = express();
//const port = 3000;
//
//app.use(bodyParser.json());
//
//// Pusher configuration
//const pusher = new Pusher({
//  appId: '1841463',
//  key: '38d0122e284cfacbf6d5',
//  secret: 'b20b930041015f1ae34b',
//  cluster: 'ap2',
//  useTLS: true
//});
//
//// Endpoint to send a message
//app.post('/message', (req, res) => {
//  const { channel, message } = req.body;
//
//  // Trigger the message event
//  pusher.trigger(channel, 'message', {
//    message
//  });
//
//  res.sendStatus(200);
//});
//
//app.listen(port, () => {
//  console.log(`Server running at http://localhost:${port}`);
//});
//*/



















//add msg work done......//


//const express = require('express');
//const Pusher = require('pusher');
//const bodyParser = require('body-parser');
//const cors = require('cors');
//
//const app = express();
//const port = 3000;
//
//// Middleware
//app.use(cors());
//app.use(bodyParser.json());
//
//// Pusher setup
//const pusher = new Pusher({
//  appId: '1841463',
//  key: '38d0122e284cfacbf6d5',
//  secret: 'b20b930041015f1ae34b',
//  cluster: 'ap2',
//  useTLS: true
//});
//
//// Basic route for testing
//app.get('/', (req, res) => {
//  res.send('Server is up and running!');
//});
//
//// POST /message route
//app.post('/message', (req, res) => {
//  const { message } = req.body;
//  if (!message) {
//    return res.status(400).send('Message is required');
//  }
//
//  pusher.trigger('chat', 'message', { message })
//    .then(() => {
//      res.status(200).send('Message sent');
//    })
//    .catch(error => {
//      console.error('Error triggering Pusher:', error);
//      res.status(500).send('Error triggering Pusher');
//    });
//});
//
//app.listen(port, () => {
//  console.log(`Server running on port ${port}`);
//});

