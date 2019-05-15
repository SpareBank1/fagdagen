const express    = require('express');
const app        = express();

const port = process.env.PORT || 8080;
const ip   = process.env.IP || '0.0.0.0';

// Hot Reloading (webpack-hot-middleware)
(() => {

  // Step 1: Create & configure a webpack compiler
  const webpack = require('webpack');
  const webpackConfig = require(process.env.WEBPACK_CONFIG ? process.env.WEBPACK_CONFIG : '../../webpack.dev');
  const compiler = webpack(webpackConfig);

  // Step 2: Attach the dev middleware to the compiler & the server
  app.use(require("webpack-dev-middleware")(compiler, {
    logLevel: 'warn', publicPath: webpackConfig.output.publicPath
  }));

  // Step 3: Attach the hot middleware to the compiler & the server
  app.use(require("webpack-hot-middleware")(compiler, {
    log: console.log, path: '/__webpack_hmr', heartbeat: 10 * 1000
  }));
})();

app.get('/api', function (req, res) {
  res.send('Hei fra SpareBank1');
});

app.get('/api/messages', function (req, res) {
  res.send([
    {id: 123, message: 'Melding 1'},
    {id: 123, message: 'Melding 2'}
  ]);
});

// Static content
app.use(express.static('public'))

// Error handling
app.use(function(err, req, res, next){  
  console.error(err.stack);
  res.status(500).send('Nå skjedde det noe dumt');
});

app.listen(port, ip);
console.log('Server is running on http://%s:%s', ip, port);

module.exports = app ;
