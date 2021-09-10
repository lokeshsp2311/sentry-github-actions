import logo from './logo.svg';
import './App.css';
import * as Sentry from "@sentry/react";
import { Integrations } from "@sentry/tracing";

console.log(process.env);
Sentry.init({
  dsn: "https://8a9369e30a804dc08eca1cc51e2908ba@o475667.ingest.sentry.io/5952849",
  integrations: [new Integrations.BrowserTracing()],
  environment: String(process.env.SENTRY_ENV).toUpperCase(),
  // We recommend adjusting this value in production, or using tracesSampler
  // for finer control
  tracesSampleRate: 0.3,
});

Sentry.configureScope(scope => {
  scope.setTag("version", `v0.1`);
});

const methodDoesNotExist = () => {
  const error = new Error("Button failure");
  console.log(error)
  Sentry.withScope(scope => {
    scope.setTag("app.status", "CRASHED");
    Sentry.captureException(error);
  });
};

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <button onClick={methodDoesNotExist}>Break the world</button>;
      </header>
    </div>
  );
}

export default App;
