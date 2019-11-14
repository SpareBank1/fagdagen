const express = require('express');
const morgan = require('morgan');
const app = express();

// http://10.226.7.52:3000/players/597b7f10

app.use(morgan('common'));

app.get('*', (req, res) => {
  console.log('  request.query', req.query);
  console.log('  request.headers', req.headers);

  const match = req.query && req.query.q && req.query.q.match(/^([0-9a-z]*):\s(.*)$/)
  if (match && match.length > 1 && match[2].indexOf('which of the following numbers is the largest') >= 0) {
    const numbers = match[2].split(': ')[1].split(',').sort().map(i => parseInt(i));
    res.send('' + Math.max(...numbers));
  } else if (match && match.length > 1 && match[2].indexOf('what is') >= 0) {
    const numbers = match[2].match(/(\d+)\splus\s(\d+)/);
    res.send('' + (parseInt(numbers[1]) + parseInt(numbers[2])));
  } else {
    res.send('OK');
  }  
});

module.exports = app;
