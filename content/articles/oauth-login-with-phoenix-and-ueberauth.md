---
date: 2022-02-12T00:00:00-03:00
description: "OAuth Login with Phoenix and Ueberauth"
tags: ["oauth", "phoenix", "ueberauth", "elixir"]
title: "OAuth Login with Phoenix and Ueberauth"
---

Rarely an application doesn't need login logic. It's important when you want to restrict some areas of your applications and identify how is using it.
We can create a password logic or we can use [OAuth](https://pt.wikipedia.org/wiki/OAuth) to connect the user through some provider like Google, Facebook, Github, Twitter, and others. Of course, [Phoenix](https://www.phoenixframework.org) already has some plugs to facilitate it for you.

# Goal

Implement an OAuth Google logic to control the login in a Phoenix application. We'll use a [skeleton application](https://github.com/wbotelhos/crud-in-5-minutes-with-phoenix-and-elixir) created in the [last article](https://www.wbotelhos.com/crud-in-5-minutes-with-phoenix-and-elixir), so I recommend you to read it first.

# Database

First let's create the user table, via [migration](https://hexdocs.pm/ecto_sql/Ecto.Migration.html), to keep the login data:

```ex
mix ecto.gen.migration create_users
```

It'll create a migration file called `priv/repo/migrations/*_create_users.exs`, open it and let's set the columns:

```ex
defmodule Bible.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :image, :string
      add :token, :string

      timestamps()
    end
  end
end
```

We need to save the email, the provider that can be Google, Facebook and so one, the avatar image and the token to recognize the user related to the provider. Let's apply this migration:

```ex
mix ecto.migrate
```

# Model

With a database table created, let's create the model to represent the user:

```ex
# lib/bible/user.ex

defmodule Bible.User do
  import Ecto.Changeset

  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :image, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:email, :image, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
```

Here we import the `Ecto.Changeset` deal with the set of changes that we'll make in the user model, like parse and validations.
The `Ecto.Schema` can map the table data into the user model, the syntax is almost the same, just change `add` in the migration to `field` in the model.

# Überauth

It's time to install the [Überauth](https://github.com/ueberauth/ueberauth) package, so we need to choose a provider, that in this case, we'll use the [Google](https://github.com/ueberauth/ueberauth_google) adding the dependencies in the `mix.exs` as the last entry into `deps` method:

```ex
# mix.exs

defp deps do
    ...
    , {:ueberauth_google, "~> 0.10"}
  ]
end
```

And you need to add the package as an extra application:

```ex
def application do
  [
    mod: {Bible.Application, []},
    extra_applications: [:logger, :runtime_tools, :ueberauth_google]
  ]
end
```

And then install it:

```ex
mix deps.get
```

# Router

We need to create three routes through the `browser` pipeline that will be responsible for login, logout, and receive the provider callbacks, so create a new scope called `/auth`:

```ex
# lib/bible_web/router.ex

scope "/auth", BibleWeb do
  pipe_through :browser

  delete "/signout", AuthController, :signout
  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

The route `/signout` will sign out the user, the `/:provider` will make a login request and the `:provider/callback` will receive the callbacks.

# Controller

The controller responsible to keep this methods is the `AuthController`, it'll have three methods.

## Sign in

The sign in method is responsible to receive the email and the provider to save or update the user in the database:

```ex
# lib/bible_web/controllers/auth_controller.ex

defp signin(conn, changeset) do
  case upsert(changeset) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "Welcome back!")
      |> put_session(:current_user, user)
      |> redirect(to: Routes.page_path(conn, :index))

    {:error, _error} ->
      conn
      |> put_flash(:error, "Signin failed!")
      |> redirect(to: Routes.page_path(conn, :index))
  end
end

defp upsert(changeset) do
  case Repo.get_by(User, email: changeset.changes.email, provider: changeset.changes.provider) do
    nil -> Repo.insert(changeset)
    user -> Repo.update(User.changeset(user, %{image: changeset.changes.image}))
  end
end
```

I'll call the `upsert` method, if we found the record, we update the `image` attribute, but if not found, we create a new user.
When success we set a message to the user, set the user in the session, and redirect it to the home page.
When fail we set an error message and redirect to the home page.

# Callback

Every time you request the provider, it will respond to you into the callback route where we'll check what came inside the `conn.assigns` variable:

```ex
# lib/bible_web/controllers/auth_controller.ex

def callback(%{assigns: assigns} = conn, _params) do
  case assigns do
    %{ueberauth_failure: %{errors: [errors]}} ->
      %{message: message} = errors

      conn
      |> put_flash(:error, message)
      |> redirect(to: Routes.page_path(conn, :index))

    %{ueberauth_auth: %{
      credentials: %{token: token},
      info: %{email: email, image: image},
      provider: provider}
    } ->
      changeset = User.changeset(%User{},
        %{email: email, image: image, provider: Atom.to_string(provider), token: token}
      )

      signin(conn, changeset)
  end
end
```

The Ueberauth can return an error where will flash and redirect to the home page.
Or it can succeed and return all the attributes we need, if it happens, we build an user changeset and calls our previous `signin` method.

# Signout

And finally, we need a method to sign out the user where we just drop de session data, flash and redirect to the home page:

```ex
# lib/bible_web/controllers/auth_controller.ex

def signout(conn, _params) do
  conn
  |> configure_session(drop: true)
  |> put_flash(:info, "See you soon.")
  |> redirect(to: Routes.page_path(conn, :index))
end
```

Now just add the plugin the beginning of the controller to execute the auth in this controller:

```ex
defmodule BibleWeb.AuthController do
  use BibleWeb, :controller

  alias Bible.Repo
  alias Bible.User

  plug Ueberauth

  # those three methods here
end
```

# Config

Now we need to configure the provider's credentials, put them before the `import_config` command:

```ex
# config/config.exs

config :ueberauth, Ueberauth,
  providers: [
    google: { Ueberauth.Strategy.Google, [default_scope: "email profile"] }
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

import_config "#{Mix.env()}.exs"
```

We set Google as provider where we'll ask, by default, the email and profile of the user.
It's necessary to provide a credential to make it work that we'll get it from the env.

# Credentials

You need a Google Account, so here the steps:

1. Access the Google [Cloud Platform -> Credentials](https://console.cloud.google.com/projectselector2/apis/credentials?pli=1&supportedpurview=project) and click in "CREATE PROJECT";

<img src="https://blogy.s3-sa-east-1.amazonaws.com/oauth-login-with-phoenix-and-uberauth/oauth-login-with-phoenix-and-uberauth-1.png" alt="Cloud Plataform Screenshot" class="align-center" />

2. Give a name for your project and click on the button "CREATE";

<img src="https://blogy.s3-sa-east-1.amazonaws.com/oauth-login-with-phoenix-and-uberauth/oauth-login-with-phoenix-and-uberauth-2.png" alt="Cloud Plataform Screenshot" class="align-center" />

3. In the left menu, access "OAuth consent screen" and give a name for your app in the field "Name", choose your email, enter your domains URLs in "App domain" for home page, privacy link, term of service link and the domain itself int "Authorized domains. Set your developer email and click in "SAVE AND CONTINUE";

<img src="https://blogy.s3-sa-east-1.amazonaws.com/oauth-login-with-phoenix-and-uberauth/oauth-login-with-phoenix-and-uberauth-3.png" alt="Cloud Plataform Screenshot" class="align-center" />

4. Next screen just click in "SAVE AND CONTINUE";
5. Again, next screen just click in "SAVE AND CONTINUE";
6. In the next screen, confirm your data and click in "BACK TO DASHBOARD";

7. Now access the "Credentials" menu in the left click in "CREATE CREDENTIALS" in the top and then choose "OAuth client ID" options;

<img src="https://blogy.s3-sa-east-1.amazonaws.com/oauth-login-with-phoenix-and-uberauth/oauth-login-with-phoenix-and-uberauth-4.png" alt="Cloud Plataform Screenshot" class="align-center" />

8. Choose **Web application**  for "Application Type" and set a name in the field "Name". For "Authorized JavaScript origins" set your local address `http://localhost:4000` to be possible to test the application locally and for "Authorized redirect URIs" we set the same as in configured in the `router.ex` with value `http://localhost:4000/auth/google/callback`, then click in "CREATE";

<img src="https://blogy.s3-sa-east-1.amazonaws.com/oauth-login-with-phoenix-and-uberauth/oauth-login-with-phoenix-and-uberauth-5.png" alt="Cloud Plataform Screenshot" class="align-center" />

9. The credential will be showed to you, copy it. If you lose this data, just click in the pencil icon in the item into "OAuth 2.0 Client IDs" section, there will be your data.

<img src="https://blogy.s3-sa-east-1.amazonaws.com/oauth-login-with-phoenix-and-uberauth/oauth-login-with-phoenix-and-uberauth-6.png" alt="Cloud Plataform Screenshot" class="align-center" />

# Envs

We need to keep our credential safe, so let's create a file to keep it:

```env
# .env.sample

export GOOGLE_CLIENT_ID=
export GOOGLE_CLIENT_SECRET=
```

It'll be just a sample to guide the developers about what ENVs are necessaries, now create a real ENV file, and set the credentials you copy, here:

```env
# .env

export GOOGLE_CLIENT_ID=910347-dnurjmr.apps.googleusercontent.com
export GOOGLE_CLIENT_SECRET=ngaa23fsah1z_agB
```

Since it has your production data, we can't commit it, so ignore it:

```sh
echo '.env' >> .gitignore
```

Now, don't forget to read the data of the .env file, it won't be read automatically like [Rails](https://rubyonrails.org/) using the gem [dotenv](https://github.com/bkeepers/dotenv):

```sh
source .env
```

If you have error like:

```sh
-bash: .env: line 1: syntax error near unexpected token `('
```

Just wrap the value into quotes.

# View

Now we can create the links for signin and signout. Since this links will be global, let's edit the layout file including the following block:

```ex
<%= if @current_user do %>
  <%= link "Signout", to: Routes.auth_path(@conn, :signout), method: :delete %>

  <img src="<%= @current_user.image %>">
<% else %>
  <%= link "Login with Google", to: Routes.auth_path(@conn, :request, :google) %>
<% end %>
```

We're using a variable called `@current_user` representing the user in session. When it exists, the signout link and the current user image are showed, but when the current user doesn't exist the sign-in link is shown.

# View Variable

For `@current_user` be available in the view, we need to assign it to the `conn`. We'll do it via [Plug](https://hexdocs.pm/phoenix/plug.html), a kind of interceptor that is executed between the middleware of the request, for example.

```ex
# lib/bible/plugs/current_user.ex

defmodule BibleWeb.Plugs.CurrentUser do
  import Plug.Conn

  def init(params), do: params

  def call(conn, _params) do
    current_user = get_session(conn, :current_user)

    assign(conn, :current_user, current_user)
  end
end
```

All Plugs has a `init`, that we just ignore, and a `call` method that will do what we need and return the `conn`.
We get the `current_user` from the session and assigns it to the `conn`, so it will be available as `@current_user` in the view.
This Plug should be executed in all browser request, so add it in the final of the pipeline `:browser`:

```ex
# lib/bible_web/router.ex

pipeline :browser do
  # ...

  plug BibleWeb.Plugs.CurrentUser
end
```

# Restricing Accesses

Everything is working, login, current user in the session but the user still can navigate through all pages. It happens because we're not verifying if the user is logged or not, we do it in the view but now we need to do it in the controllers given access or not to the methods. To do it we'll create another plug:

```ex
# lib/bible_web/router.ex

defmodule BibleWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias BibleWeb.Router.Helpers, as: Routes

  def init(params), do: params

  def call(%{assigns: %{current_user: nil}} = conn, _params) do
    conn
    |> put_flash(:info, "You must be logged in.")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  def call(conn, _params), do: conn
end
```

This plug will check the assigned `current_user`, if it's `nil` we set a flash message and redirect to the home page halting the pipeline to avoid other plugs being running, or we just return `conn` letting the request pass through normally.
Now we can plug it to the controller we want to controller the login:

```ex
# lib/bible_web/controllers/person_controller.ex

defmodule BibleWeb.PersonController do
  plug BibleWeb.Plugs.Auth when action in [:create, :delete, :index, :new, :update]
end
```

You can use the `when action in` or `when action not in`, but if the plug should work to all actions, just omit the conditional.

It's done! Just run your app `mix phx.server` an visit [localhost:4000](localhost:4000)

## Conclusion

It's so easier and safe use an OAuth login over a user/password logic and you can get the provider avatar out of the box. The bad side is that some people don't have an account on some of these providers or don't trust to use it.

Repository link: [https://github.com/wbotelhos/oauth-login-with-phoenix-and-ueberauth](https://github.com/wbotelhos/oauth-login-with-phoenix-and-ueberauth)
