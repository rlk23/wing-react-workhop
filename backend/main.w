bring react;
bring cloud;
bring http;

let api = new cloud.Api(
  cors: true
);

api.get("/title", inflight () => {
  return {
    status: 200,
    body: "Hello from the API"
  };
});

let project = new react.App(
  projectPath: "../client",
  localPort: 3001
 
);

project.addEnvironment("title", "Learn React with Wing");
project.addEnvironment("apiUrl", api.url);