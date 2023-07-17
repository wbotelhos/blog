---
date: 2023-07-17T00:00:00-03:00
description: "How To Create a HTTP Server With Elixir"
tags: ["elixir", "http-server", "socket", "gen_tcp"]
title: "How To Create a HTTP Server With Elixir"
url: "how-to-create-a-http-server-with-elixir"
---

A HTTP server receives a resquest and gives you a response. It happens through a URL plus a port like https://www.wbotelhos.com:443, when you make a request to it, it gives you my blog home page as the response. So, how can I do it using Elixir?

# Goal

Create a HTTP Server that listen for a request and returns a response.

# The gen_tcp Module

Erlang has a module called [gen_tcp](https://www.erlang.org/doc/man/gen_tcp.html) that makes the hard work for you. That code can be converted to Elixir using the following rules to convert from one syntax to another:

|Erlang    |Elixir    |
|----------|----------|
|Variable  |variable  |
|symbol    |:symbol   |
|module    |:module   |
|:         |.         |
|"charlist"|'charlist'|

# Create the Project

```sh
mix new how_to_create_a_http_server_with_elixir
```

# Create the Listener

The listener is the socket responsible to listen the requests. Here is a module with a method to create it:

```elixir
defmodule HttpServer do
  def start(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Server running on #{port}...\n")

    accept_connection(listen_socket)
  end
end
```

The `:gen_tcp.listen` receives the port to be listened and some options:

- `:binary`: The packets are received as a binary data;
- `packet: :raw`: Receives the entire pure binary with no changes;
- `active: false`: Will receive data only when we explicit allow it;
- `reuseaddr: true`: Allow reuse the address even if the server crashes;

Then we need to accept the connections.

# Accept Connections

Now it's time to accept connections from clients. For that we use `:gen_tcp.accept` providing the listen socket that will result in the client socket. At this point the connection will be hanged waiting for any connection:

```elixir
def accept_connection(listen_socket) do
  IO.puts("Waiting for connection...\n")

  {:ok, client_socket} = :gen_tcp.accept(listen_socket)

  IO.puts("Connection accepted!\n")

  process_request(client_socket)

  accept_connection(listen_socket)
end
```

Then we process the connection and turns back to accept connection again. Yes, it's a loop, it's receives the request, responds and start to accept connection again.

# Process Request

Here we need to read the request and write the response. Very simple, right?

```elixir
def process_request(client_socket) do
  IO.puts("Processing request...\n")

  client_socket
  |> read_request
  |> create_response()
  |> write_response(client_socket)
end
```

# Read the Request

The `:get_tcp.recv` receives the client socket and since we're using `packet: :raw` options we specify that we want read the entiry binary since the first length. I request is returned to be used:

```elixir
def read_request(client_socket) do
  {:ok, request} = :gen_tcp.recv(client_socket, 0)

  request
end
```

# Create Response

The response will be a valid HTTP response, where the last line, separated by an empty line, is the body:

```elixir
def create_response(_request) do
  body = "Hello HTTP Server!"

  """
  HTTP/1.1 200 OK\r
  Content-Type: text/html\r
  Content-Length: #{byte_size(body)}\r
  \r
  #{body}
  """
end
```

Please, ignore the initial condition for now.

# Write Response

Then we just send the response back to the client and close this socket, since it's done:

```elixir
def write_response(response, client_socket) do
  :ok = :gen_tcp.send(client_socket, response)

  IO.puts("Response:\n\n#{response}\n")

  :gen_tcp.close(client_socket)
end
```

# Testing

Open the `iex`:

```sh
iex -S mix
```

And then boot up the server:

```elixir
HttpServer.start(4000)

# Server running on 4000...

# Waiting for connection...
```

Now on another terminal make the request:

```sh
curl http://localhost:4000

# Hello HTTP Server!
```

On the server terminal you'll see:

```elixir
# Connection accepted!

# Processing request...

# Response:

# HTTP/1.1 200 OK
# Content-Type: text/html
# Content-Length: 18

# Hello HTTP Server!
```

# Dealing With Server Crash

If any error happens, the server will crash and stop working. You can test it adding a condition to raise some error:

```elixir
def create_response(request) do
  if String.match?(request, ~r{GET /error}) do
    raise(request)
  end

  # ...
end
```

Now call the route `/error`:

```sh
# Terminal 1

curl http://localhost:4000/error
```

So in another terminal you can try to send a normal request and it won't work, since the server crashed:

```sh
# Terminal 2

curl http://localhost:4000
```

It happens because the `process_request` is processing the response on the same process (PID) that the server it self. So if the process method crashes the server will die together. We can solve it creating a new process to deal with the response:

```elixir
def accept_connection(listen_socket) do
  # ...

  pid = spawn(fn -> process_request(client_socket) end)

  IO.puts("Processing at PID: #{inspect(pid)}\n")

  # ...
end
```

Now the `process_request` will happen on a new process so if it crashes the server will continue working.
Add the prefix `[#{inspect(pid)}] ` on all `IO.puts` for you debug the PIDs:

```sh
[#PID<0.138.0>] Server running on 4000...

[#PID<0.138.0>] Waiting for connection...

[#PID<0.138.0>] Connection accepted!

Processing at PID: #PID<0.139.0>

[#PID<0.139.0>] Processing request...

[#PID<0.138.0>] Waiting for connection...

[#PID<0.139.0>] Response:

HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 18

Hello HTTP Server!
```

The PID `0.138.0` is where the server is running and the `0.139.0` is where the processing response run once.

# Dealing With Opened Socket

If you call the error endpoint `curl http://localhost:4000/error` the server will be kept alive, but the terminal where you run the call will still kept freezed. It happens because the socket wasn't properly closed.

Here is why:

```elixir
{:ok, client_socket} = :gen_tcp.accept(listen_socket)

IO.puts("[#{inspect(self())}] Connection accepted!\n") # #PID<0.138.0>

pid = spawn(fn -> process_request(client_socket) end)

IO.puts("Processing at PID: #{inspect(pid)}\n") # #PID<0.139.0>
```

The `client_socket` was created on the PID `0.138.0` and was sent to the PID `0.139.0` where the client socket was supose to be closed. It won't work because the owner of the client socket is the PID `138` so `:gen_tcp.close` from PID `139` has no effect. Only PID `138` has this power, so we can bind this responsability:

```elixir
def accept_connection(listen_socket) do
  # ...

  :ok = :gen_tcp.controlling_process(client_socket, pid)

  # ...
end
```

Now we're saying: "My current context `self()` will control the `client_socket` registered on this `pid`".
Try to call the endpoint error again and you have the crash followed by the console release:

```sh
curl http://localhost:4000/error

# curl: (52) Empty reply from server
```

# Conclusion

It's very simple create a HTTP Server using Elixir, but it's just an example for you understand better how the things work. In a real world you should use a battle tested server like [Cowboy](https://github.com/ninenines/cowboy).

Repository: [https://github.com/wbotelhos/how-to-create-a-http-server-with-elixir](https://github.com/wbotelhos/how-to-create-a-http-server-with-elixir)

Any suggestion? Please, open an issue [here](https://github.com/wbotelhos/blog/issues/new?title=How%20To%20Create%20a%20HTTP%20Server%20With%20Elixir).
