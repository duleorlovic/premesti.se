# README

Premesti.Se

* Rails 5
* Neo4j database
* yarn installed: bootstrap 3, jquery 3, font awesome 4, snapsvg
* svg animations


# Database

Database is Neo4j. To install use this rails tasks

~~~
rails neo4j:install[community-latest,development]
rails neo4j:install[community-latest,test]
rails neo4j:config[development,$(expr $NEO4J_PORT + 2)]
rails neo4j:config[test,$(expr $NEO4J_TEST_PORT + 2)]
~~~

Start server with:

~~~
rails neo4j:start[development]
gnome-open http://localhost:$(expr $NEO4J_PORT + 2) # http://localhost:7042/browser/
rails neo4j:start[test]
gnome-open http://localhost:$(expr $NEO4J_TEST_PORT + 2) # http://localhost:7047/
~~~

Note that when you are changing the ports, then run `spring stop` to reload new
env.

Drop migrate and seed with custom rake tasks.

~~~
rake db:drop
rake db:migrate
rake db:seed
~~~

# Locale

You can see in Serbian language by visiting <http://sr.localhost:3000>

# Test

Run test with

~~~
bin/rails test
bin/rails test:system
guard
~~~
