# Demonstration app for federated services
Just another example app for Federated graphs usage within Apollo Gateway, or Graphql-Mesh.

### Why?
1. To have a quick reference to "what is it?"-answers;
2. To have a minimal installation for experiments and upgrades;
3. To demonstrate supergraph power in rails application context;
4. To study the pros/cons of both: graphql mesh and apollo gateway;

### What?
This application includes two extra-simple rails api-only applications,
to serve the federated subgraphs on the /graphql endpoints,
our setup will be able to compose them both to a supergraph schema
that will be used to launch our gateway.

### Quick start
Launch backend services:
```bash
git clone git@github.com:AndreyIlyunin/federated-rails-app.git
cd federated-rails-app

docker-compose up --build
```
Setup db:
```bash
cd federated-rails-app

docker-compose exec users rails db:create db:migrate db:seed
docker-compose exec articles rails db:create db:migrate db:seed
```
Compose graphql schema:
```bash
cd gateway

npm install -g @apollo/rover
rover supergraph compose --config ./supergraph-config.yaml > supergraph.graphql
```
Launch gateway with `node index.js`

### Reproduce
Create api-only rails applications (as much as you need):
```bash
rails new AppName --api
```
extend them with some models:
```bash
rails g model EntityName field:type
```
add graphql dependencies to these projects:
```ruby
# https://github.com/rmosolgo/graphql-ruby
gem 'graphql'
# https://github.com/Gusto/apollo-federation-ruby
gem 'apollo-federation'
```
run: `bundle install`
and: `rails generate graphql:install`,
this generate some code to the app/graphql dir,
we will also need to clean up all of the exampled "test"-query and mutations,
just because they are repeated in both applications, 
and federated schemas say 'NO' to query/type repeats.
the last step is to create initial entities for graphql:
```bash
rails g graphql:object EntityName
```
That is it. 
Subgraph services are ready to start as separate graphql servers.

To make them "federated", you will require to complete those steps: https://github.com/Gusto/apollo-federation-ruby#getting-started
for both of applications.

To merge them in a supergraph, we will need to use apollo-gateway:

We will use the simplest way to start (in my opinion).
Those steps are well documented here: https://www.apollographql.com/docs/federation/gateway/
but this is the fast-growing tech stack, and tools changes quickly, 
and just to take a snap:
```bash
mkdir gateway && cd gateway

npm install -g @apollo/rover # this one is required to compose sub-graphs into supergraph
npm install @apollo/gateway apollo-server graphql # this is the server with the gateway
touch index.js
touch subgraph-config.yaml 
```

<details>
  <summary>index.js</summary>

```js
const { ApolloServer } = require('apollo-server');
const { ApolloGateway } = require('@apollo/gateway');
const { readFileSync } = require('fs');

const supergraphSdl = readFileSync('./supergraph.graphql').toString();

const gateway = new ApolloGateway({
    supergraphSdl
});

const server = new ApolloServer({
    gateway,
});

server.listen().then(({ url }) => {
    console.log(`🚀 Gateway ready at ${url}`);
}).catch(err => {console.error(err)});

```
</details>

<details>
  <summary>subgraph-config.yaml</summary>

Make sure you know the ports for appropriate apps, in this example we run the users app on :3000, and the articles - :3001,
there is no matter which port or name to choose at this point.
```yaml
subgraphs:
  users:
    routing_url: http://localhost:3000/graphql
    schema:
      subgraph_url: http://localhost:3000/graphql
  articles:
    routing_url: http://localhost:3001/graphql
    schema:
      subgraph_url: http://localhost:3001/graphql
```
</details>

As you can mention, the gateway launched using the `./supergraph.graphql` file.
We can create it by spinning our services and composing from subgraphs:
```bash
rails s # or `rails s -p 3001` with different port to launch both in parallel
```

to generate the supergraph schema with rover cli (2.0.0):
```bash
rover supergraph compose --config ./supergraph-config.yaml > supergraph.graphql
```
and launch the gateway:
```bash
node index.js
```
you can use any of graphql clients (the GraphiQL extension for your browser for simply-fast setup)
and use the `http://localhost:4000` endpoint to refer the apollo server with the gateway on aboard.
