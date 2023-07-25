---
date: 2021-08-08T00:00:00-03:00
description: "GraphQL with Absinthe on Phoenix - Mutation"
tags: ["elixir", "phoenix", "mutation", "graphql", "absinthe"]
title: "GraphQL with Absinthe on Phoenix - Mutation"
---

###### Updated at: Jul 23, 2023

In the [last article](https://www.wbotelhos.com/graphql-with-absinthe-on-phoenix-query-and-dataloader) about GraphQL, we learned how to create a Query and how to avoid N + 1. The systems need to fetch data but the most of time we need to create these data too and GraphQL has a mechanism called Mutation to do this job.

# Goal

Create a Mutation to save a book using the code of the [last article](https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix/tree/18533cd267f8e08ae7e699018a554dbac855e716)

# Mutation

The Mutation works very similar to Query, it queries the data in the same way, but after creating the record, and as expected we receive the input data as a parameter, like in Query, but instead it be used as a filter it's used as a parameter to be inserted into the database.

We need to import the mutations in the Schema:

```elixir
# lib/app/graphql/schema.ex

import_types(GraphQL.Mutations)

mutation do
  import_fields(:book_mutations)
end
```

The mutations files will contain the mutations:

```elixir
# lib/app/graphql/mutations.ex

defmodule App.GraphQL.Mutations do
  use Absinthe.Schema.Notation

  alias App.GraphQL.Mutations

  import_types(Mutations.Book)
end
```

The mutation is called `create_book` and it receives `name` and `position` as arguments, returning a Book:

```elixir
# lib/app/graphql/mutations/book.ex

defmodule App.GraphQL.Mutations.Book do
  use Absinthe.Schema.Notation

  alias App.GraphQL.Resolvers

  object :book_mutations do
    field :create_book, :book do
      arg(:name, :string)
      arg(:position, :integer)

      resolve(&Resolvers.Book.create_book/2)
    end
  end
end
```

And the resolver will create the book and return it in case of success, but in case of error an `message` is added along with a `details` key with a better explanation:

```elixir
# lib/app/resolvers/books.ex

alias App.GraphQL

def create_book(args, _context) do
  case Documents.create_book(args) do
    {:ok, book} ->
      {:ok, book}

    {:error, changeset} ->
      {:error, message: "Book creation failed!", details: GraphQL.Errors.extract(changeset)}
  end
end
```

Already exists a method to extract the errors from a changeset called [traverse_errors/2](https://hexdocs.pm/ecto/Ecto.Changeset.html#traverse_errors/2):

```elixir
# lib/app/graphql/errors.ex

defmodule App.GraphQL.Errors do
  def extract(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
```

Now let's create a book:

```gql
mutation {
  createBook(name: "Book Name", position: 4) {
    id
    name
    position
  }
}
```

Pay attention here because now we need to use the root key called `mutation`, when we just do queries we use `query` or just omit it that defaults to `query`. Another detail is that we should use [Lower Camel Case](https://pt.wikipedia.org/wiki/CamelCase) when we have a composed name. Inside GraphQL it'll be converted to [Snake Case](https://en.wikipedia.org/wiki/Snake_case).


```json
{
  "data": {
    "createBook": {
      "id": "4",
      "name": "Book Name",
      "position": 4
    }
  }
}
```

# Nested Fields

Sometimes we need to create a record and some children of this record at the same time. We call these fields as nested and Absinthe treats it like an `input_object` that is used as an argument of your Mutation:

```elixir
# lib/app/graphql/mutations/book.ex

field :create_book, :book do
  ...

  arg(:verses, list_of(:verse_create_inputs))
end
```

Now we have one extra argument called `verses` that is a list of `verse_create_inputs` that represents the allowed fields to be used in nested parameters:

```elixir
# lib/app/graphql/types/verse.ex

input_object :verse_create_inputs do
  field :body, non_null(:string)
  field :chapter, non_null(:integer)
  field :number, non_null(:integer)
end
```

You can't referer to a type in the args, it accepts only `input_object`. Finally, we need to enable the association of verses in the method that creates the book:

```elixir
# lib/app/documents.ex

def create_book(attrs \\ %{}) do
  %Book{}
  |> Book.changeset(attrs)
  |> Ecto.Changeset.cast_assoc(:verses, with: &Verse.changeset/2)
  |> Repo.insert()
end
```

Here we ask Ecto to cast the association verses and use the Verse changeset to do that, like a normal insertion.

Let's try it:

```gql
mutation {
  createBook(name: "Números", position: 4, verses: [{chapter: 1, number: 1, body: "No segundo ano..."}, {chapter: 1, number: 2, body: "Levantai o censo..."}]) {
    id
    name
    position
    verses {
      body
      chapter
      id
      number
    }
  }
}
```

```json
{
  "data": {
    "createBook": {
      "id": "4",
      "name": "Números",
      "position": 4,
      "verses": [
        {
          "body": "No segundo ano...",
          "chapter": 1,
          "id": "7",
          "number": 1
        },
        {
          "body": "Levantai o censo...",
          "chapter": 1,
          "id": "8",
          "number": 2
        }
      ]
    }
  }
}
```

# Conclusion

Mutations are very similar to Queries, you can expose the allowed fields and even create nested records. In the next article, we'll see how to protect our API with authentication.

Repository link: [https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix](https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix/tree/4575465b03045df4a34365c915213cd8ed5de2a3)

Any suggestion? Please, send me an email [here](mailto:wbotelhos@gmail.com).
