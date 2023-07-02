---
date: 2021-08-03T00:00:00-03:00
description: "GraphQL with Absinthe on Phoenix - Query and Dataloader"
tags: ["elixir", "absinthe", "graphql", "phoenix", "query", "dataloader"]
title: "GraphQL with Absinthe on Phoenix - Query and Dataloader"
---

One thing is true, [GraphQL](https://graphql.org) is here to stay. This query language is very useful since you can just declare the fields you can have, but choose what you want in each request. It'll avoid you to create combinations of logic that return fields for different purposes.

# Goal

We'll learn how to use GraphQL on Phoenix with the help of [Absinthe](https://github.com/absinthe-graphql/absinthe) and how to deal with Queries and how to avoid N + 1 with the help of [Dataloader](https://github.com/absinthe-graphql/dataloader).

# Setup

Let's create a Phoenix project, API like:

```sh
mix phx.new app --no-html --no-webpack
cd app
```

And install Absinthe and Absinthe Plug used to work with Phoenix:

```elixir
# mix.exs

defp deps do
  [
    {:absinthe, "~> 1.6"},
    {:absinthe_plug, "~> 1.5"}
```

And install it:

```sh
mix deps.get
```

# Database

We need a connection to the database, so let's set the PG password blank:

```elixir
# config/dev.exs

config :app, App.Repo,
  username: "postgres",
  password: "",
```

And create a [Docker Compose](https://docs.docker.com/compose) to run the PG on Docker:

```yml
version: "3.8"

services:
  database:
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust

    image: postgres:13-alpine

    ports:
      - 5432:5432
```

Now, just spin up the database and setup Ecto:

```sh
docker compose up -d

mix ecto.setup
```

# Models

We'll work with two models:

```sh
mix phx.gen.json Documents Book books name:string position:integer
```

```sh
mix phx.gen.json Documents Verse verses chapter:integer number:integer body:string book_id:references:books
```

The tables need to be created:

```sh
mix ecto.migrate
```

Let's remove some files not related to this article:

```sh
rm -rf lib/app/templates
rm -rf lib/app/controllers
rm -rf test
```

# Route

The `/api` route should forward the requests to Absinthe:

```elixir
# lib/app/router.ex

scope "/api" do
  pipe_through :api

  forward "/", Absinthe.Plug, schema: App.GraphQL.Schema
end
```

# Schema

Absinthe does not require a controller as an entry point like in Rails só the request just arrives in the Schema, the first place to receive the request and where we'll define everything:


```elixir
# lib/app/graphql/schema.ex

defmodule App.GraphQL.Schema do
  use Absinthe.Schema

  alias App.GraphQL

  import_types(GraphQL.Types.Book)
  import_types(GraphQL.Types.Verse)
end
```

Here we transform the module into an Absinthe Schema and import the two Types.

# Types

GraphQL calls the models as Type, so usually, for each model, we create a Type in GraphQL with more or fewer fields than your model:

```elixir
# lib/app/graphql/types/book.ex

defmodule App.GraphQL.Types.Book do
  use Absinthe.Schema.Notation

  object :book do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :position, non_null(:integer)

    field :verses, list_of(:verse)
  end
end
```

Here we have a Type representing the Book that will map the Book model. We call it an `object` and it exposes the model fields. Since we said we have `verses`, we need to add the relation on model:

```elixir
has_many :verses, App.Documents.Verse
```

Ok, we already have the Type, but how to list all those types? Well, we create an object that exposes the fields we want:

```elixir
# lib/app/graphql/queries/book.ex

object :book_queries do
  field :books, list_of(:book)
end
```

This object exposes the field `books` that return a list of books. Now we need to import this file and object in our schema, but since it's an object to query data, we create a new block where we can import this object as a field in Schema:

```elixir
# lib/app/graphql/schema.ex

import_types(GraphQL.Queries.Book)

query do
  import_fields(:book_queries)
end
```

It's allowed to write the objects directly inside the `query` block, but I recommend to you separate and import it inside a separate file, so you can easily find the queries related to some model and your Schema works just like a raw manifest with no logic.

For `Verse` we declare the type too, but not the query since we don't want query directly by Verse, but list it embedded in Book:

```elixir
# lib/app/graphql/types/verse.ex

defmodule App.GrapQL.Types.Verse do
  use Absinthe.Schema.Notation

  object :verse do
    field :id, non_null(:id)
    field :chapter, non_null(:integer)
    field :number, non_null(:integer)
    field :body, non_null(:string)

    field :book, :book
  end
end
```

And the relation in the model:

```elixir
belongs_to :book, App.Documents.Book
```

# Seed

Let's populate our database to test the queries:

```elixir
# priv/repo/seeds.exs

alias App.Documents

[
  %{
    name: "Gênesis",
    position: 1,
    verses: [
      %{
        body: "No princípio, criou Deus os céus e a terra.",
        chapter: 1,
        number: 1
      },
      %{
        body:
          "A terra, porém, estava sem forma e vazia; havia trevas sobre a face do abismo, e o Espírito de Deus pairava por sobre as águas.",
        chapter: 1,
        number: 2
      }
    ]
  },
  %{
    name: "Êxodo",
    position: 2,
    verses: [
      %{
        body:
          "São estes os nomes dos filhos de Israel que entraram com Jacó no Egito; cada um entrou com sua família:",
        chapter: 1,
        number: 1
      },
      %{
        body: "Rúben, Simeão, Levi e Judá,",
        chapter: 1,
        number: 2
      }
    ]
  },
  %{
    name: "Levítico",
    position: 3,
    verses: [
      %{
        body: "Chamou o Senhor a Moisés e, da tenda da congregação, lhe disse:",
        chapter: 1,
        number: 1
      },
      %{
        body:
          "Fala aos filhos de Israel e dize-lhes: Quando algum de vós trouxer oferta ao Senhor, trareis a vossa oferta de gado, de rebanho ou de gado miúdo.",
        chapter: 1,
        number: 2
      }
    ]
  }
]
|> Enum.each(fn attrs ->
  {:ok, book} = Documents.create_book(attrs)

  attrs
  |> Map.get(:verses)
  |> Enum.each(fn verse_attrs ->
    verse_attrs
    |> Map.put(:book_id, book.id)
    |> Documents.create_verse()
  end)
end)
```

Ok, three books with each one containing 2 verses.

# Query

It's time to query our data, for this some people use [GraphiQL](https://github.com/graphql/graphiql/tree/main/packages/graphiql#readme), I prefer to use the [Insominia](https://insomnia.rest/download), feel free to choose the best for you.

The `query` block exposes the entry points to GraphQL, where we already have the object `book_queries`. If you try to run it, it won't work yet:

```json
{
  books {
    id
    name
    position
  }
}
```

```json
{
  "data": {
    "books": null
  }
}
```

# Resolvers

The last query didn't work because we need to resolve how those books are returned, for that we can open a block and point the field to some method to resolve the query, there we can have arguments too:

```elixir
# lib/app/graphql/queries/book.ex

object :book_queries do
  field :books, list_of(:book) do
    arg(:limit, :integer)

    resolve(&Resolvers.Book.list_books/2)
  end
end
```

Now the field `books` accepts a `limit` argument and resolve the query via our Resolver module:

```elixir
# lib/app/graphql/resolvers/book.ex

defmodule App.GraphQL.Resolvers.Book do
  alias App.Documents

  def list_books(args, _context) do
    {:ok, Documents.list_books(args)}
  end
end
```

The Resolver just proxy it to the Phoenix Context:

```elixir
lib/app/documents.ex

defmodule App.Documents do
  ...

  alias App.Documents.Book
  alias App.Repo

  def list_books(args) do
    query = from(Book)

    Enum.reduce(args, query, fn
      {:limit, limit}, query -> from query, limit: ^limit

      true, query -> query
    end)
    |> Repo.all()
  end

  ...
```

Inside the method, we reduce the args composing the query and then we query all records. Now the books query will work, since we've resolved the query:

```json
{
  books(limit: 1) {
    id
    name
    position
  }
}
```

```json
{
  "data": {
    "books": [
      {
        "id": "1",
        "name": "Gênesis",
        "position": 1
      }
    ]
  }
}
```

# Nested Query

GraphQL enables us to do nested queries navigating through the relations and as we saw, the resolvers can indicate to us how to do that. Let's create a query to get a single book:

```elixir
# lib/app/graphql/types/book.ex

object :book_queries do
  ...

  field :book, :book do
    arg(:id, non_null(:integer))

    resolve(&Resolvers.Book.get_book/2)
  end
end
```

Then the resolver:

```elixir
# lib/app/graphql/resolvers/book.ex

def get_book(%{id: id}, _context) do
  {:ok, Documents.get_book!(id)}
end
```

Automatically we would like to return the Verses from the searched book like this:

```json
{
  book(id: 1) {
    id
    name
    position
    verses {
      id
      chapter
      number
      body
    }
  }
}
```

But it'll return an error:

```sh
Cannot return null for non-nullable field
```

It happens because we load the book, but not the verses relations. To fix it we can preload the verses:

```elixir
def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload(:verses)
```

Running the query again it works:

```json
{
  "data": {
    "book": {
      "id": "1",
      "name": "Gênesis",
      "position": 1,
      "verses": [
        {
          "body": "No princípio, criou Deus os céus e a terra.",
          "chapter": 1,
          "id": "1",
          "number": 1
        },
        {
          "body": "A terra, porém, estava sem forma e vazia; havia trevas sobre a face do abismo, e o Espírito de Deus pairava por sobre as águas.",
          "chapter": 1,
          "id": "2",
          "number": 2
        }
      ]
    }
  }
}
```

Now it worked, but since we always preload the verses, even if you remove the verses node, when you search by a book, it'll still make a query to list verses. What we want is to fetch the verses only when we ask for them, so let's resolve the field verses inside the book type, so GraphQL won't try to get it from the self-model:

```elixir
# lib/app/graphql/types/book.ex

field :verses, list_of(:verse) do
  arg(:limit, :integer)

  resolve(&Resolvers.Verses.verse_for_book/3)
end
```

Pay attention that now we used the resolve with arity *3*, where the first argument is the parent (book) element. Let's create the resolver:

```elixir
# lib/app/graphql/resolvers/verse.ex

defmodule App.GraphQL.Resolvers.Verse do
  alias App.Documents

  def verses_for_book(book, _args, _context) do
    {:ok, Documents.verses_for_book(book)}
  end
end
```

And create the method in Phoenix Context:

```elixir
# lib/app/documents.ex

def verses_for_book(book) do
  Verse
  |> where(book_id: ^book.id)
  |> Repo.all()
end
```

Now if you ask for verses it will execute two queries:

```sql
SELECT b0."id", b0."name", b0."position", b0."inserted_at", b0."updated_at" FROM "books" AS b0 WHERE (b0."id" = $1) [1]

SELECT v0."id", v0."body", v0."chapter", v0."number", v0."book_id", v0."inserted_at", v0."updated_at" FROM "verses" AS v0 WHERE (v0."book_id" = $1) [1]
```

And if you remove the verses, it will execute just one:

```sql
SELECT b0."id", b0."name", b0."position", b0."inserted_at", b0."updated_at" FROM "books" AS b0 WHERE (b0."id" = $1) [1]
```

# Dataloader

As you could see, create the resolver is the way to conditionally load or not your relations, but it becomes hard to keep while your application grows. Most people end up dealing with it, but we still have a bad thing happening behind the scene, the *N + 1*.

I've already heard from a developer that he doesn't like GraphQL, that it's slow because N + 1, but we have ways to avoid it. In the Rails world we have the [Batch Loader](https://github.com/exAspArk/batch-loader) and for Absinthe we have the [Dataloader](https://github.com/absinthe-graphql/dataloader).

First, let's install it:

```elixir
# mix.exs

{:dataloader, "~> 1.0"}
```

Dataloader needs a data source entry point, let's define it in Phoenix Context:

```elixir
# lib/app/documents.ex

def datasource() do
  Dataloader.Ecto.new(Repo, query: &query/2)
end
```

This method will delegate to the method `query` with model name as first argument and a map of optional elements. Let's create a query method for Verse:

```elixir
# lib/app/documents.ex

defp query(Verse, %{scope: :book, limit: limit}) do
  Verse |> limit(^limit)
end

defp query(model, _) do
  model
end
```

Very similar with method `verses_for_book` we identify the purpose of the query based on the key called `scope` (you can choose how you want to identify it), so here we saying: If we query Verse schema with key `scope: :book` we want to build the query like this.

If no query matches we just return the queryable model with no changes in the "criteria".

Now in the Schema, we can register that data source:

```elixir
# lib/app/graphql/schema.ex

alias App.Documents

def context(ctx) do
  loader =
    Dataloader.new()
    |> Dataloader.add_source(Documents, Documents.datasource())

  Map.put(ctx, :loader, loader)
end
```

The context method is used to carry data to Absinthe, so we create a Dataloader, register one Datasource, referred by `Documents` (you can have many), and put it into context.

Now we prepend the Dataloader middleware into Absinthes's plugins:

```elixir
# lib/app/graphql/schema.ex

def plugins, do: [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
```

And finally the funny part, we'll replace the resolver with Dataloader:

```elixir
# lib/app/graphql/types/book.ex

import Absinthe.Resolution.Helpers, only: [dataloader: 3]

field :verses, list_of(:verse) do
  arg(:limit, :integer)

  resolve dataloader(Documents, :verses, args: %{scope: :book})
end
```

Using `dataloader/3` we refer to the Dataloader registered as `Documents`, asks for the `:verses` (Verse) relation, and provide the scope into `args` to identify the query in pattern match of `query/2` methods. A cool thing here is that `args` are merged with the args coming from the query, in this case, `limit`, so you don't need to explicitly pass it to args.

# Folder Organization

Instead of importing all Types and Queries in your Schema, you can create a file, in the root of graphql folder, that imports all other files, and then in your Schema you import just this index file:

```elixir
# lib/app/graphql/types.ex

defmodule App.GraphQL.Typesdo
  use Absinthe.Schema.Notation

  alias App.GraphQL.Types

  import_types(Types.Book)
  import_types(Types.Verse)
end

```

```elixir
# lib/app/graphql/queries.ex

defmodule App.GraphQL.Queries do
  use Absinthe.Schema.Notation

  alias App.GraphQL.Queries

  import_types(Queries.Book)
  import_types(Queries.Verse)
end
```

And just update your Schema:

```elixir
# lib/app/graphql/schema.ex

import_types(GraphQL.Types)
import_types(GraphQL.Queries)
```

# Conclusion

GraphQL saves us from code duplication with a modern query mechanism and for N + 1 we already have great tools to deal with it. In the next series of GraphQL will learn about Mutation.

Repository link: [https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix](https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix/tree/18533cd267f8e08ae7e699018a554dbac855e716)
