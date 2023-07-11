---
date: 2021-07-29T00:00:00-03:00
description: "I18n With Phoenix"
tags: ["elixir", "phoenix", "i18n"]
title: "I18n With Phoenix"
---

It's a good idea to translate your texts, even if you'll display your site only in one language. With this technique, the texts will be centralized in only one place and you can separate them by domains. [Phoenix](https://www.phoenixframework.org) uses [gettext](https://www.gnu.org/software/gettext) to do the translation and we'll see how to do that.

# Goal

Translate and understand how translation in Phoenix works.

# Setup

Let's create a Phoenix project:

```ex
mix phx.new i18n_with_phoenix
cd i18n_with_phoenix
mix deps.get
mix ecto.create
```

# Phoenix Translation

You can use the tag `gettext` providing the template with optional keys:

```ex
# lib/i18n_with_phoenix_web/templates/page/index.html.eex

<%= gettext "Hello, %{name}!", name: "Botelho" %>
```

Here you can see we're not referring to a key that would represent the translation, but passing the inline template as "key", like [Mustache](https://github.com/mustache/mustache) does.

### Extracting Files

A cool feature, in Phoenix, is the `extract` that extracts our translations call to a translation file called `.pot` (Portable Object Template):

```sh
mix gettext.extract

# Extracted priv/gettext/default.pot
# Extracted priv/gettext/errors.pot
```

Now we have two files at `priv/gettext` like `config/locales` in [Rails](https://rubyonrails.org) but instead of `.yml` we use `.pot` where we'll keep the template `"Hello, %{name}!"`:

```ex
# priv/gettext/default.pot

## This file is a PO Template file.
##
## "msgid"s here are often extracted from source code.
## Add new translations manually only if they're dynamic
## translations that can't be statically extracted.
##
## Run "mix gettext.extract" to bring this file up to
## date. Leave "msgstr"s empty as changing them here as no
## effect: edit them in PO (.po) files instead.
msgid ""
msgstr ""

#, elixir-format
#: lib/i18n_with_phoenix_web/templates/page/index.html.eex:1
msgid "Hello, %{name}!"
msgstr ""
```

Here the template is identified by `msgid` (key like) and we have the value for it called `msgstr` (value like), but you shouldn't pass a value directly here because it'll have no effect, since this file is the default  template.

A cool thing is that the auto-extract indicates the file and the line where the translation was called (`lib/i18n_with_phoenix_web/templates/page/index.html.eex:1`).

You should always use the auto-extract unless you're using a dynamic translation, in this case, `gettext` can't discover it.

> But wait! If it's a template, not a key, why do I need to supply a value for it? Ok, it's confusing, hold on a second...

If a `msgid` has no `msgstr`, the template itself is used, it works like a default. You can think like this: `msgid` is the key, and `msgstr` is the value, but if the `msgstr` is empty then we'll use the key as the value. To be clear, another file for another language will use the same `msgid` with other `msgstr`. In the final, it's nice to use it this way because you refer to a string as a key instead of a key that can have any value inside there that you'll need to open the translation file to discover.

## Merging Files

Now we have all templates, we need to create the `.po` (Portable Object) files containing the translation values for each locale used in the application with the following command:

```sh
mix gettext.merge priv/gettext

# Wrote priv/gettext/en/LC_MESSAGES/errors.po (0 new translations, 0 removed, 21 unchanged, 0 reworded (fuzzy))
# Wrote priv/gettext/en/LC_MESSAGES/default.po (1 new translation, 0 removed, 0 unchanged, 0 reworded (fuzzy))
```

One new translation was merged on `priv/gettext/en/LC_MESSAGES/default.po`, since the default locale is `en`. The `.po` keeps the reference to `.pot` template through the `msgid`.

Let's check the content of `priv/gettext/en/LC_MESSAGES/default.po`:

```ex
## "msgid"s in this file come from POT (.pot) files.
##
## Do not add, change, or remove "msgid"s manually here as
## they're tied to the ones in the corresponding POT file
## (with the same domain).
##
## Use "mix gettext.extract --merge" or "mix gettext.merge"
## to merge POT files into PO files.
msgid ""
msgstr ""
"Language: en\n"
"Plural-Forms: nplurals=2\n"

#, elixir-format
#: lib/i18n_with_phoenix_web/templates/page/index.html.eex:1
msgid "Hello, %{name}!"
msgstr ""
```

The `Language` is `en` and we have our id, now scoped to `en` folder. We can set the `str` and define the translation for it like: `Olá %{name}`, but since this file is in English and the default value is already in English, let's just keep it blank, so the default will be used.

We have no error when the value is not defined, different from Rails, for example, since we can use the inline template by itself:

**Rails:**

```rb
I18n.t "missing.message", name: "Botelho"

# "translation missing: en.missing.message"
```

**Phoenix:**

```ex
gettext "Missing %{name}!", name: "Botelho"

Missing Botelho!
```

## Adding New Locales

I'm from Brazil, so I want to add translations for `pt-BR`, for it, we can run:

```sh
mix gettext.merge priv/gettext --locale pt_BR

# Created directory priv/gettext/pt_BR/LC_MESSAGES
# Wrote priv/gettext/pt_BR/LC_MESSAGES/errors.po (21 new translations, 0 removed, 0 unchanged, 0 reworded (fuzzy))
# Wrote priv/gettext/pt_BR/LC_MESSAGES/default.po (1 new translation, 0 removed, 0 unchanged, 0 reworded (fuzzy))
```

> Different from Rails, our country code needs to be declared separated by underline.

Now we need to set the translation:

```ex
# priv/gettext/pt_BR/LC_MESSAGES/default.po

msgid "Hello, %{name}!"
msgstr "Olá, %{name}!"
```

## Default Locale

We can change the default locale to `pt-BR`, or any other, and declare each locale that we support in `config/config.exs`:

```ex
config :i18n_with_phoenix, I18nWithPhoenix.Gettext, default_locale: "pt_BR", locales: ~w(pt_BR en)
```

The config is on our app `i18n_with_phoenix` key and we use the `I18nWithPhoenixWeb` module to refer to the `Gettext`. The default locale is `pt_BR` but we can change it between `pt_BR` and `en`.

## Pluralization

Instead use `gettext` use `ngettext` that receives a singular text on the first param, a plural text on the second param, the counter number as the third param, and then the interpolation keys.

```ex
# lib/i18n_with_phoenix_web/templates/page/index.html.eex

<%= ngettext "%{name} last login: 1 day!", "%{name} last login: %{count} days!", 2, name: "Botelho" %>
```

The number `2` is the value used as `count`. For the value `1`, the first argument is used, for the values `> 1` the second argument is used, since it is plural.

Run `mix gettext.extract --merge` to extract and merge the PO files.

```ex
msgid "%{name} last login: %{count} day!"
msgid_plural "%{name} last login: %{count} days!"
msgstr[0] "%{name} último login: %{count} dia!"
msgstr[1] "%{name} último login: %{count} dias!"
```

Now we have the `msgid_plural` and the str for singular (1) and plural (2) situations.

## Domains

Separate the translation files is good to organize the things. You can do it using the `dgettext`.

```ex
<%= dgettext "greetings", "Welcome back %{name}!", name: "Botelho" %>
```

The first param is the domain name and after extract/merge a file called `greetings.po` with this translation will be created.
If you want to use the domain with the pluralization, just use the `dngettext`.

```ex
<%= dngettext "greetings", "Welcome back %{name} after 1 day!", "Welcome back %{name} after %{count} days!", 2, name: "Botelho" %>
```

## Dynamic Location Change

To change between locales, you can use the plug [set_locale](https://github.com/smeevil/set_locale), but since I had a problem using `pt-BR` locale, let's create our own code, so you can understand better how it works.

We'll create a [Plug](https://hexdocs.pm/phoenix/plug.html#module-plugs):

```ex
# lib/i18n_with_phoenix_web/plugs/locale.ex

defmodule I18nWithPhoenix.Plugs.Locale do
  import Plug.Conn

  def init(default_locale), do: default_locale
end
```

We called our Plug `Locale` and imported the `Plug.Conn` to make this module behave like a Plug. We need an initialize that will receive a default locale. Now we can plug it on our Route:

```ex
# lib/i18n_with_phoenix_web/router.ex

pipeline :browser do
  ...
  plug I18nWithPhoenix.Plugs.Locale, "pt_BR"
end
```

Now every time the route pass through the `:browser` pipe this plug will be executed providing an argument that represents our default locale received on `init` method.

Back to our Plug, we need to define the `call` method where we can set the desired locale:

```ex
@locales Gettext.known_locales(AppWeb.Gettext)

def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _default_locale) when locale in @locales do
    set_locale(conn, locale)
  end

  defp set_locale(conn, locale) do
    Gettext.put_locale(I18nWithPhoenixWeb.Gettext, locale)

    conn
    |> put_resp_cookie("locale", locale, max_age: :timer.hours(24) * 365)
    |> assign(:locale, locale)
  end
```

Here we defined a variable holding all available locales defined in `config.ex` as `locales` and fetched by the `know_locales` method. With these values, we can make a guard clause and execute this `call` method only if the param `locale` is included on it, then calling the `set_locale`.

The method `set_locale` first uses `put_locale` to change the default locale of the application and then we save it on Cookie to memorize this config with one year of duration. In the final, we assign this location to use on the view and finally we return the desired `conn` for the `call` method.

When the locale is not valid this first `call` method won't be called, so we'll create another `call` method for invalid locations or for the case this param is not provided.

```ex
def call(conn, default_locale) do
  set_locale(conn, conn.cookies["locale"] || default_locale)
end
```

Here we try to fetch the cookie value and set it as the current locale, but if it's not present we set the default locale. The final Plug is:

```ex
defmodule I18nWithPhoenixWeb.Plugs.Locale do
  import Plug.Conn

  @locales Gettext.known_locales(I18nWithPhoenixWeb.Gettext)

  def init(default_locale), do: default_locale

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _default_locale)
      when locale in @locales do
    set_locale(conn, locale)
  end

  def call(conn, default_locale) do
    set_locale(conn, conn.cookies["locale"] || default_locale)
  end

  defp set_locale(conn, locale) do
    Gettext.put_locale(I18nWithPhoenixWeb.Gettext, locale)

    conn
    |> put_resp_cookie("locale", locale, max_age: :timer.hours(24) * 365)
    |> assign(:locale, locale)
  end
end
```

Now add the locales links on your code:

```ex
<a href="?locale=pt_BR">pt-BR</a>
<a href="?locale=en">en</a>
```

When you click on this links the locale will change, so the translation.

## Domain

Ok, everything is good but the fact we're using only one file, called default, to hold all our translation. With a bigger system, things can become hard to maintain. But it's possible to separate the translation in domain:

 ```ex
<%= dgettext("admin", "%{name}, logged as an Admin!", name: "Botelho") %>
```

After the extract and merge you'll see a new file called `admin.po|t` been created:

```sh
mix gettext.extract --merge

# Wrote priv/gettext/pt_BR/LC_MESSAGES/admin.po (1 new translation, 0 removed, 0 unchanged, 0 reworded (fuzzy))
# Wrote priv/gettext/en/LC_MESSAGES/admin.po (1 new translation, 0 removed, 0 unchanged, 0 reworded (fuzzy))
```

Now you can find your translation easier and always separated that temporary translation in another domain to be easy to remove later.

## Conclusion

It was a simple way to do the translation, but we have other ways like use headers or embed the locale in the URL Path. Of course, we have a couple of libs out there to help us too, but it's important to know at least the basics of how things work. Just try to translate your text since the beginning of your app to avoid double work in the future.

Repository link: https://github.com/wbotelhos/i18n-with-phoenix
