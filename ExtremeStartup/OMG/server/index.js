const express = require('express');
const morgan = require('morgan');
const app = express();

// http://10.226.7.52:3000/players/597b7f10

app.use(morgan('common'));

app.get('*', (req, res) => {
  console.log('  request.query', req.query);
  console.log('  request.headers', req.headers);

  const match = req.query && req.query.q && req.query.q.match(/^(.+):\s(.*)$/)
  if (match && match.length > 1 && match[2] === 'what is your name') {
    res.send('OMG');
  } else {
    res.send('OK');
  }  
});

module.exports = app;
