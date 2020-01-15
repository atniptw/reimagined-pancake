import React from 'react';
import logo from './logo.svg';
import './App.css';
import { getRequest } from './api/fetchUtil';
import { Welcome } from './components';

class App extends React.PureComponent {
  state: { welcomeText: string } = {
    welcomeText: 'Welcome'
  }
 
  fetchWelcomeText() {
    getRequest().then(text => {
      this.setState({ welcomeText: text.greeting })
      });
  }

  render() { 
    this.fetchWelcomeText();

    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <Welcome
            text={this.state.welcomeText}
          />
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    );
  }
}

export default App;
