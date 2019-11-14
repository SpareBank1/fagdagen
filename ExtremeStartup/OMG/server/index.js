const express = require('express');
const morgan = require('morgan');
const app = express();
const port = 3000;

app.use(morgan('dev'));

app.get('*', (req, res) => {
  console.log('  request.query', req.query);
  console.log('  request.headers', req.headers);

  const match = req.query.q.match(/^(.+):(.*)$/)
  if (match[2] === 'what is your name') {
    //res.send('OMG');
    res.send('OMG');
  } else {
    res.send('OK');
  }  
})

module.exports = app;