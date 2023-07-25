---
date: 2023-07-24T00:00:00-03:00
description: "Site with React and TypeScript and Vite and Apollo"
tags: ["react", "vite", "graphql", "api", "reactjs", "react-router"]
title: "Site with React and TypeScript and Vite and Apollo"
---

# Goal

Using [React](https://react.dev) with [TypeScript](https://www.typescriptlang.org) we'll consume a [GraphQL](https://graphql.org) API using [Apollo](https://www.apollographql.com) and build a simple site.

This site will have different pages so the [React Router](https://reactrouter.com) will be set in place and the entire project will be supported by [Vite](https://vitejs.dev).

# GraphQL API

I'll use the API built on the article [GraphQL with Absinthe on Phoenix - Authentication](https://www.wbotelhos.com/graphql-with-absinthe-on-phoenix-authentication), but feel free to use any other API.

# React App

We'll use the [Vite](https://vitejs.dev/guide/why.html#why-vite) to create the bootstrap since it can create smaller packages and can be faster to deal with during the development.

First, make sure you have [NodeJS](https://nodejs.org) and [Yarn](https://yarnpkg.com) installed.

```sh
node --version
yarn --version
```

Then let's create the app's skeleton called `app` using React and TypeScript:

```sh
yarn create vite app --template react-ts
```

You can run the following commands:

```sh
yarn
yarn dev
```

And test it at [http://localhost:5173](http://localhost:5173)

# Cleanup

Let's remove some unused files:

```sh
rm src/App.css
rm src/index.css
rm public/vite.svg
rm src/assets/react.svg
```

# Entrypoint

Edit the `index.html` and let it clean to keep the things easy to understand:

```html
<!doctype html>

<html>
  <head>
    <title>Site with React and TypeScript and Vite and Apollo</title>
  </head>
  <body>
    <div id="root"></div>

    <script src="/src/main.tsx" type="module"></script>
  </body>
</html>
```

Here we have the script `/src/main.tsx` that starts everything and renders the content inside the `root` div.

The content of `main.tsx` should be:

```tsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
```

If you're thinking that the `!` is strange, you're right, it's strange, but it happens because we're using a `tsx`, a TypeScript extension for a React file `jsx`. Since `createRoot` must receive an element, the exclamation says: Relax, it'll exists, I ensure.

Here the `ReactDOM` creates the root element and renders inside it the `App` component wrapped by a helper that acts like a linter for our entire app, so it's a good idea to keep it.

# The App

The entry point component calls `App` and from there we'll call all other components:

```tsx
// src/App.tsx

import Home from "./components/Home";

const App = () => (
  <div style={{ maxWidth: 1800 }}>
    <Home message="Welcome to the Bible" />
  </div>
);

export default App;
```

In the past were commonly used components as a class, but nowadays we normally create components as a simple function.

**Let's see a quick review of how React works:**

The `App`, the main function, returns a `div` with a style `max-width: 1800px`. In fact `<div>` here is not an HTML element, but a React function that creates the div element. That's why it can receive attributes using the dynamic tag `{}`. Inside it, we can use JS code like the hash `{ maxWidth: 1800 }` that will become the style attributes.

The components can be compounded by another component, so we're rendering the `Home` component.

# Component

The `Home` element is called a component and it returns just the provided message:

```tsx
// src/components/Home.tsx

type HomeProps {
  message: string,
}

const Home = ({ message }: HomeProps) => (
  <div>{message}</div>
);

export default Home;
```

Using TypeScript we can specify the type used on the `Home` component, so the attributes of it must follow the specified attributes.

Ok, just test your code at [http://localhost:5173](http://localhost:5173).

# Types

Before we continue, let's agree that we'll put all types inside the `types` folder:

```tsx
// src/types/Home.tsx

export type HomeProps = {
  message: string,
}
```

```tsx
// src/types/Book.tsx

export type BookProps = {
  id: number,
  name: string,
  position: number,
}
```

If the linter complains, just add the `/* eslint-disable @typescript-eslint/no-unused-vars */` on the top of the file.

# Books

This component should receive a list of books, interact with each one and display it.

```tsx
// src/components/Books.tsx

import { BookProps } from "../types/Book";

const items = [
  { id: 1, name: 'Book 1', position: 1 },
  { id: 2, name: 'Book 2', position: 2 },
  { id: 3, name: 'Book 3', position: 3 },
]

const Books = () => {
  return (
    <ul>
      {items.map((item: BookProps) => {
        return (
          <li key={item.id}>
            <a href="#">{item.name}</a>
          </li>
        )
      })}
    </ul>
  );
}

export default Books;
```

Let's add it to the `App`:

```tsx
// src/App.tsx

import Books from "./components/Books";
import Home from "./components/Home";

const App = () => (
  <div style={{ maxWidth: 1800 }}>
    <Home message="Welcome to the Bible" />
    <Books />
  </div>
);

export default App;
```

Currently, we're using fake data, but how can we fetch it from an API?

# Apollo Client
[Apollo Client](https://github.com/apollographql/apollo-client) allows us work with GraphQL on the client side, let's install it:

```sh
yarn add @apollo/client graphql
```

On the `main.tsx` file we need to configure the client access:

```tsx
// src/main.tsx

// ...

import { ApolloProvider, ApolloClient, createHttpLink, InMemoryCache } from '@apollo/client';
import { setContext } from '@apollo/client/link/context';

const host = import.meta.env.VITE_API_HOST;
const token = import.meta.env.VITE_API_TOKEN;

const authLink = setContext((_, { headers }) => {
  return { headers: { ...headers, authorization: token ? `Bearer ${token}` : '' } };
});

const httpLink = createHttpLink({ uri: host });
const client = new ApolloClient({ cache: new InMemoryCache(), link: authLink.concat(httpLink) });

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ApolloProvider client={client}>
      <App />
    </ApolloProvider>
  </React.StrictMode>,
)
```

First, we get the host of the API and the auth token, an [JWT](https://jwt.io/introduction), to allow us to access the API:

```env
# .env

VITE_API_HOST=http://localhost:4000
VITE_API_TOKEN=eyJhbGciOiJIUzUxMiJ9.eyJhdWQiOiJodHRwczovL3d3dy53Ym90ZWxob3MuY29tIiwiZXhwIjoxNzIxNzg4MDI4LCJpYXQiOjE2OTAyNTIwMjgsImlzcyI6Imh0dHBzOi8vd3d3Lndib3RlbGhvcy5jb20iLCJqdGkiOiI4ZWY5MGExODYxNjg4MmFlYThjMmQwOTZmZDNhM2ZlNyIsIm5iZiI6MTY2ODExNjk3OSwic3ViIjoiYXBpIiwidXNlcl9pZCI6MX0.pWDmhJjxkQglVNIgxz9Fgc8dm4zVS8HKs7ls7Elp-RbBxpX1kG2iGlUTFojPYAbdETbmGeDtoWgHau6aD_oWbQ
```

Then an auth link is created adding the `authorization` header key and returning a `ApolloLink2`` type.
This type allows us concat another link containing the URL where the API lives. And finally, we create the Apollo Client using an in-memory cache and the link created before.

Ok, now we're ready to wrap the application with `<ApolloProvider>` component to allow the application to fetch an API via the created `client`.

# GraphQL Queries

Apollo Client allows us to create queries to be executed from any place we want. Here is an query to fetch all books:

```tsx
// src/graphql/queries/book.tsx

import { gql } from '@apollo/client';

const BOOKS_QUERY = gql`
  query books($limit: Int!) {
    books(limit: $limit) {
      id
      name
      position
    }
  }
`;

export { BOOKS_QUERY };
```

Using the `gql` we can easily declare GraphQL queries.

To use it just add the following code to the `Books`` component:

```tsx
// src/components/Books.tsx

// ...

import { BOOKS_QUERY } from '../graphql/queries/Book';
import { useQuery } from '@apollo/client';

const { loading, error, data } = useQuery(BOOKS_QUERY, {
  variables: { limit: 100 },
});

if (loading) {
  return <p>Loading...</p>;
}

if (error) {
  return <p>Error: {error.message}</p>;
}

return (
  <ul>
    {data.books.map((item: BookProps) => {
      return (
        <li key={item.id}>
          <a href="#">{item.name}</a>
        </li>
      )
    })}
  </ul>
);
```

The `useQuery` executes the query and returns three variables indicating if it is loading, the error when it exists and the data when it executes with success. We early return different data to be displayed on the screen based on it and finally, we can get the result inside `data.books` keeping the same logic as before.

Test your code and it should work properly now.

# Routes

We don't want the Home page living together with the books page. To allow navigation we can use the React Router:

```sh
yarn add react-router-dom
```

Now we create a component to display our links:

```tsx
// src/components/Navbar.tsx

import { Link } from 'react-router-dom';

const Navbar = () => (
  <ul>
    <li><Link to="/">Home</Link></li>
    <li><Link to="/books">Books</Link></li>
  </ul>
);

export default Navbar;
```

Just including this component on the app still won't work because we must bind each `Link` path, declared in the `to` attribute to a specific component, so our `App` will be like this:

```tsx
// ...

import Navbar from './components/Navbar';

import { BrowserRouter, Routes, Route } from 'react-router-dom';

const App = () => (
  <div style={{ maxWidth: 1800 }}>
    <BrowserRouter>
      <Navbar />

      <Routes>
        <Route path="/" element={<Home message="Welcome to the Bible" />} />
        <Route path="/books" element={<Books />} />
      </Routes>
    </BrowserRouter>
  </div>
);

export default App;
```

As you can see the `Navbar` containing the links must be inside the `BrowserRouter` to work and then we declare all route's binds. When the link to `/`books` is accessed the `<Book>` component will be displayed. Simple, right?

# Conclusion

These days it's very simple to work with React, the functional way makes it simpler using just simple functions, the API is fetched very easily with Apollo and work with routes is dead simple too.

Of course, we should use a back-end when we want to hide the JWT token and when we need to use more complex components or form we need to deal with state and more libraries, but I ensure you, it's much simpler than the old days working with HTML interpolated in the JS or even better the [HandlebarsJS](https://handlebarsjs.com).

Repository link: [https://github.com/wbotelhos/site-with-react-and-typescript-and-vite-and-apollo](https://github.com/wbotelhos/site-with-react-and-typescript-and-vite-and-apollo)

Any suggestion? Please, send me an email [here](mailto:wbotelhos@gmail.com).
