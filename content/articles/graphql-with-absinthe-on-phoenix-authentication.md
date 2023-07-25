---
date: 2021-08-24T00:00:00-03:00
description: "GraphQL with Absinthe on Phoenix - Authentication"
tags: ["elixir", "phoenix", "absinthe", "graphql", "authentication"]
title: "GraphQL with Absinthe on Phoenix - Authentication"
---

###### Updated at: Jul 24, 2023

In the [last article](https://www.wbotelhos.com/graphql-with-absinthe-on-phoenix-mutation) about Mutation, we learned how to create records in an easy way, so now we have searches and insertions but we still do not control how the user access that API. For security reasons or just for control of access we need to implement the API Authentication where only logged users can access it.

# Goal

Authenticate the user and restrict the API to only the logged ones.

# User

First, let's create a user table in an Account context:

```sh
mix phx.gen.json Accounts User users email:string password_hash:string
```

Removes some files not used:

```sh
rm -rf lib/app_web/controllers
rm -rf test
rm lib/app_web/views/changeset_view.ex
rm lib/app_web/views/user_view.ex
```

And then run the migration:

```sh
mix ecto.migrate
```

We need a User type:

```elixir
# lib/app/graphql/types/user.ex

defmodule App.GraphQL.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field :email, non_null(:string)
  end
end
```

Import it in the types file:

```elixir
# lib/app/graphql/types.ex

import_types(Types.User)
```

# Signup

Ok, the user is done, now we can create a signup mutation:

```elixir
# lib/app/graphql/mutations/session.ex

defmodule App.GraphQL.Mutations.Session do
  use Absinthe.Schema.Notation

  alias App.GraphQL.Resolvers

  object :session_mutations do
    field :signup, :session do
      arg(:email, :string)
      arg(:password, :string)

      resolve(&Resolvers.User.signup/2)
    end
  end
end
```

This mutation contains a `signup` field that receives the email and password and returns a session to us. This session is the composition of the user data and a token to access the API:

```elixir
# lib/app/graphql/types/session.ex

defmodule App.GraphQL.Types.Session do
  use Absinthe.Schema.Notation

  object :session do
    field :token, non_null(:string)

    field :user, non_null(:user)
  end
end
```

Don't forget to register the mutation:

```elixir
# lib/app/graphql/schema.ex

import_fields(:session_mutations)
```

And then create the resolver:

```elixir
# lib/app/graphql/resolvers/user.ex

defmodule App.GraphQL.Resolvers.User do
  alias App.Accounts
  alias App.GraphQL
  alias App.AuthToken

  def signup(args, _context) do
    case Accounts.create_user(args) do
      {:ok, %Accounts.User{} = user} ->
        {:ok, %{token: AuthToken.create(user), user: %{email: user.email}}}

      {:error, changeset} ->
        {:error, message: "Signup failed!", details: GraphQL.Errors.extract(changeset)}
    end
  end
end
```

The method `create_user` of the Phoenix Context `Accounts` will create a user using the generated code that we've made. We need to hash the given password before saving the record inside the `changeset`:


```elixir
# lib/app/accounts/user.ex

def changeset(user, attrs) do
  user
  |> cast(attrs, [:email, :password])
  |> hash_password()
  |> validate_required([:email, :password_hash])
end
```

After cast the password we call the `hash_password` to encrypt the `password`, which will be saved into `password_hash` field, that's why we validate the presence of this field. The method is that:

```elixir
# lib/app/accounts/user.ex

defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  change(changeset, Argon2.add_hash(password))
end

defp hash_password(Ecto.Changeset = changeset), do: changeset
```

Here we receive the changeset structure and get the password that has changed, with this password we change the changeset calling the `Argon2` module to encrypt the given password. This first method just happens in case the changeset is valid, otherwise, we just return the changeset with no change.

# Token

A token is an encoded string containing a serialized data that can be used to identify the user in a session or keep some session data. The most common way to keep this token is using the [JWT](https://jwt.io). Phoenix already has [a method](https://hexdocs.pm/phoenix/Phoenix.Token.html#module-example) to encode and decode the token:

```elixir
# lib/app/auth_token.ex

defmodule App.AuthToken do
  @salt "any salt"

  def create(user) do
    Phoenix.Token.sign(AppWeb.Endpoint, @salt, user.id)
  end

  def verify(token) do
    Phoenix.Token.verify(MyApp.Endpoint, @salt, token, max_age: 60 * 60 * 24)
  end
end
```

In this case, we're creating a token containing the user's id with a default [Salt](https://en.wikipedia.org/wiki/Salt_(cryptography)). When we verify the token it sets a 24hrs to it be expired.

Let's execute the signup mutation:


```gql
mutation {
  signup(email: "wbotelhos@gmail.com", password: "password") {
    token
    user {
      email
    }
  }
}
```

```json
{
  "data": {
    "signup": {
      "token": "SFMyNTY.g2gDYQ1uBgDzrpAEewFiAAFRgA.J4cXwwWS7JYfGg1ehdpr6xoutcRWSYztrahwkzNh2D4",
      "user": {
        "email": "wbotelhos@gmail.com"
      }
    }
  }
}
```

Great, now we have a token to authenticate in the API. Before we continue we need to create the sign-in mutation.

# Signin

```elixir
# lib/app/graphql/mutations/session.ex

field :signin, :session do
  arg(:email, :string)
  arg(:password, :string)

  resolve(&Resolvers.User.signin/2)
end
```

The resolver:

```elixir
# lib/app/graphql/resolvers/user.ex

def signin(%{email: email, password: password}, _context) do
  case Accounts.authenticate(email, password) do
    {:ok, %Accounts.User{} = user} ->
      {:ok, %{token: AuthToken.create(user), user: %{email: user.email}}}

    {:error, changeset} ->
      {:error, message: "Signin failed!", details: GraphQL.Errors.extract(changeset)}
  end
end
```

And the Context method:

```elixir
def authenticate(email, password) do
  User
  |> Repo.get_by(email: email)
  |> Argon2.check_pass(password)
end
```

The `check_pass` gets the property `password_hash` and compares it to the given password.

You can signin like this:


```gql
mutation {
  signin(email: "wbotelhos@gmail.com", password: "password") {
    token
    user {
      email
    }
  }
}
```

# User's book

Let's make the book belongs to a user:

```sh
mix ecto.gen.migration add_user_in_books
code priv/repo/migrations/*_add_user_in_books.exs
```

```elixir
defmodule App.Repo.Migrations.AddUserInBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :user_id, references(:users)
    end
  end
end
```

Let's add the user relation in the book model:

```elixir
# lib/app/documents/book.ex

belongs_to :user, App.Accounts.User
```

And in the book type:

```elixir
# lib/app/graphql/types/book.ex

field :user, non_null(:user)
```

And the relation of books in the user model:

```elixir
# lib/app/accounts/user.ex

has_many :books, App.Documents.Book
```

And for the book creation, we'll receive the user owner of that book in the resolution parameter to pass it to the `create_book` method:

```elixir
# lib/app/graphql/resolvers/book.ex

def create_book(args, %{context: %{current_user: current_user}}) do
  args
  |> Map.put(:current_user, current_user)
  |> Documents.create_book()
  |> case do
    {:ok, book} ->
      {:ok, book}

    {:error, changeset} ->
      {:error, message: "Book creation failed!", details: GraphQL.Errors.extract(changeset)}
  end
```

Now `create_book` receives a user inside the arguments to be associated to the book:

```elixir
def create_book(attrs \\ %{}) do
  %Book{}
  |> Book.changeset(attrs)
  |> Ecto.Changeset.cast_assoc(:verses, with: &Verse.changeset/2)
  |> Ecto.Changeset.put_assoc(:user, attrs.current_user)
  |> Repo.insert()
end
```

Now everything about the user is connected and done.

# Set Current User

We have the token in the Headers but we needed to capture it to discover who is the user. For that, we can use a Plug to intercept all API requests and extract the user based on the token:

```elixir
# lib/app/plugs/set_current_user.ex

defmodule App.Plugs.SetCurrentUser do
  import Plug.Conn

  alias App.AuthToken
  alias App.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_user(conn) do
      nil -> conn
      user -> Absinthe.Plug.put_options(conn, context: %{current_user: user})
    end
  end

  # private

  defp get_user(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- AuthToken.verify(token),
         user <- Accounts.get_user!(user_id) do
      user
    else
      _error -> nil
    end
  end
end
```

This Plug gets the Authorization header, which must be written in lowercase, and discard the `"Bearer "` part of the value. With the token in hand, we call the `verify` to extract the hashed value that becomes the user's id. Then just find that id in the database. If some error raises or we can't find the user, then `nil` is returned.

Now let's active it:

```elixir
# lib/app_web/router.ex

pipeline :api do
  plug :accepts, ["json"]

  plug AppWeb.Plugs.SetCurrentUser
end
```

Now all requests passing through the `:api` pipe will try to get the user via the token.

But since we refactored the code on the first article not using router anymore, this plug goes directly to the `Endpoint.ex` before the Absinthe plug:

```elixir
# lib/app_web/endpoint.ex

defmodule AppWeb.Endpoint do
  # ...

  plug AppWeb.Plugs.SetCurrentUser
  plug Absinthe.Plug, schema: App.GraphQL.Schema
end
```

# Absinthe Resolution Parameter

Try to create a book with no Authorization header or with a wrong value and you'll receive:

```elixir
no function clause matching in App.GraphQL.Resolvers.Book.create_book/2
```

It happens because we're waiting for a user key inside the key context from the parameter `resolution`, the second one of our resolver:

```elixir
# lib/app/graphql/resolvers/book.ex

create_book(args, %{context: %{current_user: current_user}})
```

The `SetCurrentUser` module was responsible to set it inside the context.

# Middleware

Ok, we're protected, but I don't want that my application raises an error when the user is not present, I just want to avoid the request. Good, we can do it, we can avoid the resolver execution using a middleware:

```elixir
# lib/app/graphql/middlewares/authenticator.ex

defmodule App.Middlewares.Authenticator do
  def call(resolution, _opts) do
    case resolution.context do
      %{current_user: _current_user} ->
        resolution

      _context ->
        Absinthe.Resolution.put_result(resolution, {:error, "Sign-in required!"})
    end
  end
end
```

Similar to a Plug it receives the resolution, the same of the resolver, and extra options that you can pass to the middleware. We check if the context has a current user set, if yes we just return the resolution and continue, otherwise we put an error in the resolution.

Try to create the book again and now an error message is returned:

```json
{
  "data": {
    "createBook": null
  },
  "errors": [
    {
      "locations": [
        {
          "column": 3,
          "line": 2
        }
      ],
      "message": "Sign-in required!",
      "path": [
        "createBook"
      ]
    }
  ]
}
```

Middleware can be used to avoid some field access too, so you can return just a couple of data. By the way, remember always to put the middleware before the resolver, since it is executed from the top to the bottom.

# CORS

For sure you try to access this API from some different place than your own server and when you do it, you'll receive an error more less like this:

```
Access to fetch at 'http://localhost:4000/' from origin 'http://localhost:5173' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource. If an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.
```

To avoid it when can allow some domains access own server using the [CorsPlug](https://hexdocs.pm/cors_plug/readme.html). Add it on your `Endpoint` before the `SetCurrentUser`, since there is the place where we check the request headers:

```elixir
# lib/app_web/endpoint.ex

defmodule AppWeb.Endpoint do
  # ...
  plug CORSPlug, origin: ~r/^https?:\/\/localhost:\d{4}$/
  plug AppWeb.Plugs.SetCurrentUser
  plug Absinthe.Plug, schema: App.GraphQL.Schema
end
```

Here we're accepting all connections from `localhost` followed by an port of 4 numeric digits.

# Conclusion

Authentication is very necessary to protect your API and you can use middleware to control how this access is made. In the next article, we'll learn about Subscription.

Repository link: [https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix](https://github.com/wbotelhos/graphql-with-absinthe-on-phoenix/tree/5bf2fde9397646fae0c847ed2f2e64327b61af63)

Any suggestion? Please, send me an email [here](mailto:wbotelhos@gmail.com).
