const express = require('express');
const bodyParser = require('body-parser');
const Pusher = require('pusher');

const app = express();
const pusher = new Pusher({
  appId: 'YOUR_APP_ID',
  key: 'YOUR_APP_KEY',
  secret: 'YOUR_APP_SECRET',
  cluster: 'YOUR_APP_CLUSTER',
  useTLS: true
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.post('/messages', (req, res) => {
  const { message } = req.body;
  pusher.trigger('my-channel', 'message-event', { message });
  res.sendStatus(200);
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
