---
date: 2021-05-27T00:00:00-03:00
description: "CRUD in 5 Minutes with Phoenix and Elixir"
tags: ["elixi", "phoenix", "crud"]
title: "CRUD in 5 Minutes with Phoenix and Elixir"
---

I know, you already heard something like this in the Rails world. But for somebody that never created an application with Phoenix and Elixir, it is a good point to start.

# Introduction

Elixir is a new language created by [José Valim](https://twitter.com/josevalim). It's a [functional language](https://en.wikipedia.org/wiki/Functional_programming) that makes things safer and this language has a framework called [Phoenix](https://www.phoenixframework.org) that help us with HTTP requests and so.

# Dependencies

First of all, you need to install the Erlang/Elixir package manager. In this world, try to use the *asdf* that you can install via [brew](https://docs.brew.sh/Installation) using Mac:

```sh
brew update
brew install asdf
```

You need to teach asdf how install Erlang and Elixir adding some plugins on it:

```sh
asdf plugin add erlang
asdf plugin add elixir
```

Now install the last version of [Erlang](https://www.erlang.org/downloads) and install it globally:

```sh
asdf install erlang 24.0
asdf global erlang 24.0
```

And then the last version of [Elixir](https://elixir-lang.org/blog/categories.html#Releases):

```sh
asdf install elixir 1.12
asdf global elixir 1.12
```

Check your versions:

```sh
elixir --version

# Erlang/OTP 24 [erts-12.0] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

# Elixir 1.12.0 (compiled with Erlang/OTP 22)
```

You save which Erlang and Elixir version you use in a file called `.tool-versions`, very similar the `.ruby-version` in Ruby world:

```
# .tool-versions

elixir 1.12
erlang 24.0
```

Our dependencies package manager calls [Hex](https://hex.pm) so let's install it:

```sh
mix local.hex
```

And finally, we can install the [Phoenix Framework](https://github.com/phoenixframework/phoenix/blob/master/CHANGELOG.md):

```sh
mix archive.install hex phx_new 1.5.9
```

# Creating the project

I'll create the project skeleton skipping the dependencies install since we want to use [Yarn](https://yarnpkg.com) over [NPM](https://www.npmjs.com):

```sh
mix phx.new bible
cd bible
```

# Configuring Database

You'll need to install [Docker](https://docs.docker.com/docker-for-mac/install) and then create a docker file:

```yml
# docker-compose.yml

version: "3.8"

services:
  database:
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust

    image: postgres:13-alpine

    ports:
      - 5432:5432
```

Since we won't use a password in dev and test, let's set it to empty:

```
# config/dev.exs

config :bible, Bible.Repo,
  username: "postgres",
  password: "",
```

```
# config/test.exs

config :bible, Bible.Repo,
  username: "postgres",
  password: "",
```

* If you need to change the port, just add one extra property `port: 5434`, for example.

You're good to boot up your database:

```sh
docker-compose up -d
```

Now run some commands:

```sh
# installs the dependencies
mix deps.get

# creates the database
mix ecto.setup

# installs assets
cd assets && yarn install && cd -

# run the server
mix phx.server
```

Visit the URL and see your project running: [localhost:4000](http://localhost:4000)

# Creating an automatic CRUD

In Phoenix, we separate the code inside Modules, so the `Persons` will be a module containing our CRUD code.
`Person` is the model name and `persons` in the table with `name` and `description` as fields.

```sh
mix phx.gen.html Persons Person persons name:string description:text
```

Enable the CRUD routes adding the following code in the final of the block `scope "/", BibleWeb do`:

```elixir
# lib/bible_web/router.ex

scope "/", BibleWeb do
  resources "/persons", PersonController
end
```

You should apply the migration in the database:

```sh
mix ecto.migrate
```

Just visit [localhost:4000/persons](http://localhost:4000/persons) and have fun!

# Conclusion

Elixir and Phoenix are funny and strong worlds and we already have a lot of tools around this community. I believe that this language will be the future and will replace a couple of Java-like systems in big companies, mainly financial ones. What do you think?

Repository link: [https://github.com/wbotelhos/crud-in-5-minutes-with-phoenix-and-elixir](https://github.com/wbotelhos/crud-in-5-minutes-with-phoenix-and-elixir)
