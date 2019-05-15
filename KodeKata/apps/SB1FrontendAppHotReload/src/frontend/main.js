import React from 'react';
import ReactDOM from 'react-dom';

import RootComponent from './components/root';

import './styles.less';

ReactDOM.render(
  <RootComponent />,
  document.getElementById('main-sb1-app-container')
);

if (module.hot) {
  module.hot.accept();
}
