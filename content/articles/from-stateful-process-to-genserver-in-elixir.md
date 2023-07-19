---
date: 2022-01-10T00:00:00-03:00
description: "From Stateful Process to GenServer in Elixir"
tags: ["elixir", "genserver", "stateful", "process"]
title: "From Stateful Process to GenServer in Elixir"
---

When we talk about Functional Languages like Elixir we're talking about our functions being pure where the same input gives you the same output. We're talking about not depending on keeping state receiving different mutations. So if you need to keep the state in Elixir, how can it be done? Well, GenServer does, but we'll get there.

# Goal

We'll create a stateful process and refactor it until gets the GenServer implementation, in this way you can learn how the state works and how GenServer encapsulates it.

# Loop

The magic behind keeping state is to keep the code in a loop, so you can change a provided value and call itself again and again and again and...

```elixir
defmodule GenericServer do
  def loop(state) do
    IO.puts("Listening with state: #{inspect(state)}")

    receive do
      {:call, caller, message} ->
        IO.puts("#{inspect(caller)} sent #{inspect(message)}")

        new_state = Map.put(state, :total, state[:total] + 1)

      loop(new_state)
    end
  end
end
```

This function will loop the process and wait for some message that can be matched with `{:call, caller, message}`. This match will increase the total key and this new map will be given to the loop again. If you do not call the loop again, the process will die.

Since `receive` blocks the process we'll start it in a new process different from the terminal using `spawn` and initialize the state:

```elixir
pid = spawn(GenericServer, :loop, [%{total: 0}])
#PID<0.144.0>
```

With PID `0.144.0` in hand we can send a message to this process:

```elixir
send(pid, {:call, self(), "Will match :call"})
# #PID<0.141.0> sent "Will match :call"
# Listening with state: %{total: 1}
```

We sent a message to process PID matching the block `:call` providing the terminal PID `self()` as `0.141.0` and a message.

Let's improve it and create a method to increment, decrement, and display the result:

```elixir
defmodule GenericServer do
  def loop(state) do
    IO.puts("Listening with state: #{inspect(state)}")

    receive do
      {:decrement, value} ->
        new_state = Map.put(state, :total, state[:total] - value)

        loop(new_state)

      {:increment, value} ->
        new_state = Map.put(state, :total, state[:total] + value)

        loop(new_state)

      {:result, caller} ->
        new_state = state

        send(caller, new_state)

        loop(new_state)
    end
  end
end
```

Only the `:result` block receives the caller's PID to have the opportunity to send the message back to the caller.

```elixir
pid = spawn(GenericServer, :loop, [%{total: 0}])
#PID<0.144.0>

send(pid, {:increment, 7})
# Listening with state: %{total: 7}

send(pid, {:decrement, 2})
# Listening with state: %{total: 5}

send(pid, {:result, self()})
# Listening with state: %{total: 5}

Process.info(self(), :messages)
# {:messages, [%{total: 5}]}

flush
# {:result, %{total: 5}}
# :ok
```

Since we sent a message to the terminal, we can get the message in the mailbox. In the final we `flush` it to clear the messages.

To avoid mixing up the logic of the calculation with the logic to receive the messages, let's refactor and separate the calculation into two different handles: `call` that returns a response to the caller and `cast` that doesn't:

```elixir
defmodule GenericServer do
  def loop(module, state) do
    IO.puts("Listening with state: #{inspect(state)}")

    receive do
      {:call, message, caller} ->
        new_state = module.handle_call(message, state)

        send(caller, new_state)

        loop(module, new_state)

      {:cast, message} ->
        new_state = module.handle_cast(message, state)

        loop(module, new_state)
    end
  end

  def handle_call(:result, state) do
    state
  end

  def handle_cast({:decrement, value}, state) do
    Map.put(state, :total, state[:total] - value)
  end

  def handle_cast({:increment, value}, state) do
    Map.put(state, :total, state[:total] + value)
  end
end
```

The `receive` now listen to `call` and `cast` where `cast` won't send a response back. We added the `module` variable to identify the module that has the handles, in this case the main module itself. All handles return the state, isolating this state manipulation logic.

```elixir
pid = spawn(GenericServer, :loop, [GenericServer, %{total: 0}])
# #PID<0.143.0>
# Listening with state: %{total: 0}

send(pid, {:cast, {:increment, 7}})
# Listening with state: %{total: 7}

send(pid, {:cast, {:decrement, 2}})
# Listening with state: %{total: 5}

send(pid, {:call, :result, self()})
# Listening with state: %{total: 5}

Process.info(self(), :messages)
# {:messages, [%{total: 5}]}
```

It's not easy to remember the `send` syntax since we need to know the order of the parameters, so let's encapsulate the `send` calls:

```elixir
defmodule GenericServer do
  def start(state \\ %{total: 0}) do
    spawn(__MODULE__, :loop, [__MODULE__, state])
  end

  def decrement(pid, value) do
    cast(pid, {:decrement, value})
  end

  def increment(pid, value) do
    cast(pid, {:increment, value})
  end

  def result(pid) do
    call(pid, :result, self())
  end

  def loop(module, state) do
    IO.puts("Listening with state: #{inspect(state)}")

    receive do
      {:call, message, caller} ->
        new_state = module.handle_call(message, state)

        send(caller, new_state)

        loop(module, new_state)

      {:cast, message} ->
        new_state = module.handle_cast(message, state)

        loop(module, new_state)
    end
  end

  def call(pid, message, caller) do
    send(pid, {:call, message, caller})

    receive do
      response -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def handle_call(:result, state) do
    state
  end

  def handle_cast({:decrement, value}, state) do
    Map.put(state, :total, state[:total] - value)
  end

  def handle_cast({:increment, value}, state) do
    Map.put(state, :total, state[:total] + value)
  end
end
```

Now we extract the method to execute `call` and `cast`, so the method `increment`, `decrement`, and `result` can call them. Since now the module is the one that calls the `result` method, the `self()` PID will be the module's context, so to receive the result with no need to check the mailbox, we can add a `receive` and listen to this result.

Pay attention that we have two processes now, the PID for the spawned module and the PID of the module that asks for the result. To communicate with `loop` method, we send a message to the spawned module that returns it in the `start` method:

```elixir
pid = GenericServer.start()
# Listening with state: %{total: 0}
# #PID<0.155.0>

GenericServer.increment(pid, 7)
# Listening with state: %{total: 7}

GenericServer.decrement(pid, 2)
# Listening with state: %{total: 5}

GenericServer.result(pid)
# Listening with state: %{total: 5}
```

Ok, keeping the PID and passing it through methods is not cool, but necessary to keep the spawned process on track. We have a trick where we can give a name for the process so we can refer to it using just the name:

```elixir
defmodule GenericServer do
  @name __MODULE__

  def start(state \\ %{total: 0}) do
    pid = spawn(__MODULE__, :loop, [__MODULE__, state])

    Process.register(pid, @name)

    pid
  end

  def decrement(value) do
    cast(@name, {:decrement, value})
  end

  def increment(value) do
    cast(@name, {:increment, value})
  end

  def result() do
    call(@name, :result, self())
  end

  def loop(module, state) do
    IO.puts("Listening with state: #{inspect(state)}")

    receive do
      {:call, message, caller} ->
        new_state = module.handle_call(message, state)

        send(caller, new_state)

        loop(module, new_state)

      {:cast, message} ->
        new_state = module.handle_cast(message, state)

        loop(module, new_state)
    end
  end

  def call(pid, message, caller) do
    send(pid, {:call, message, caller})

    receive do
      response -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def handle_call(:result, state) do
    state
  end

  def handle_cast({:decrement, value}, state) do
    Map.put(state, :total, state[:total] - value)
  end

  def handle_cast({:increment, value}, state) do
    Map.put(state, :total, state[:total] + value)
  end
end
```

Now in the `start` method, we register the PID as the name of the module, in this way, we don't need to transport it, just refer to it globally to call `call` and `cast`:

```elixir
pid = GenericServer.start()
# Listening with state: %{total: 0}

GenericServer.increment(7)
# Listening with state: %{total: 7}

GenericServer.decrement(2)
# Listening with state: %{total: 5}

GenericServer.result()
# Listening with state: %{total: 5}
```

And the last refactor is separate all server logic:

```elixir
defmodule GenericServer do
  def start(module, state, options) do
    pid = spawn(__MODULE__, :loop, [module, state])

    Process.register(pid, options[:name])
  end

  def loop(module, state) do
    IO.puts("Listening with state: #{inspect(state)}")

    receive do
      {:call, message, caller} ->
        new_state = module.handle_call(message, state)

        send(caller, new_state)

        loop(module, new_state)

      {:cast, message} ->
        new_state = module.handle_cast(message, state)

        loop(module, new_state)
    end
  end

  def call(pid, message, caller) do
    send(pid, {:call, message, caller})

    receive do
      response -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end
end
```

From the client logic:

```elixir
defmodule Counter do
  @name __MODULE__

  def start(state \\ %{total: 0}) do
    GenericServer.start(__MODULE__, state, name: @name)
  end

  def decrement(value) do
    GenericServer.cast(@name, {:decrement, value})
  end

  def increment(value) do
    GenericServer.cast(@name, {:increment, value})
  end

  def result() do
    GenericServer.call(@name, :result, self())
  end

  # callbacks

  def handle_call(:result, state) do
    state
  end

  def handle_cast({:decrement, value}, state) do
    Map.put(state, :total, state[:total] - value)
  end

  def handle_cast({:increment, value}, state) do
    Map.put(state, :total, state[:total] + value)
  end
end
```

```elixir
pid = Counter.start()
# #PID<0.159.0>
# Listening with state: %{total: 0}

Counter.increment(7)
# Listening with state: %{total: 7}

Counter.decrement(2)
# Listening with state: %{total: 5}

Counter.result()
# Listening with state: %{total: 5}
```

Done! We could create a stateful process from scratch and understand how to send and receive messages between the process. Ok, but what is the relation of it to GenServer? Well, you just wrote a GenServer with a slight difference in the interface.

For our `call` callbacks we need to add one extra parameter called `from` in the second position. It'll contain the PID from the caller and the unique identification of the request, but we won't use it. All callbacks must return a tuple over a single value. Since the call method needs to return a response, the first value of the tuple is `reply`, the second is the value we want to reply to the caller and the third is the state:

```elixir
  def handle_call(:result, _from, state) do
    {:reply, state, state}
  end
```

For `cast` callback we don't have the `from` parameter, since we don't reply to the caller, so the first key of the tuple is `noreply` and the second is the state:

```elixir
  def handle_cast({:decrement, value}, state) do
    {:noreply, Map.put(state, :total, state[:total] - value)}
  end

  def handle_cast({:increment, value}, state) do
    {:noreply, Map.put(state, :total, state[:total] + value)}
  end
```

GenServer has a couple of callbacks and we implemented two of them, but don't worry we already have generic callbacks implemented, we just need to use the module GenServer `use GenServer`:

```elixir
defmodule Counter do
  use GenServer

  @name __MODULE__

  def start(state \\ %{total: 0}) do
    GenServer.start(__MODULE__, state, name: @name)
  end

  def decrement(value) do
    GenServer.cast(@name, {:decrement, value})
  end

  def increment(value) do
    GenServer.cast(@name, {:increment, value})
  end

  def result() do
    GenServer.call(@name, :result)
  end

  # callback

  def handle_call(:result, _from, state) do
    {:reply, state[:total], state}
  end

  def handle_cast({:decrement, value}, state) do
    {:noreply, Map.put(state, :total, state[:total] - value)}
  end

  def handle_cast({:increment, value}, state) do
    {:noreply, Map.put(state, :total, state[:total] + value)}
  end
end
```

Let's test our GenServer, but now the return of the `start` will be a tuple too:

```elixir
{:ok, pid} = Counter.start()
# {:ok, #PID<0.159.0>}

Counter.increment(7)
# :ok

Counter.decrement(2)
# :ok

Counter.result()
# %{total: 5}
```

# Conclusion

Congratulations! You now understand how a GenServer works under the roof. If you need to manipulate the initial state you can use the callback `init`. If you need to split the callback in two peace, you can add an extra `{:continue, value}` on the return of the tuple. If you want to hold a generic message use `handle_info`, manipulate something before a normal exit, `terminate`. To handle a change module version, `code_change`. To intercept the state result, `format_status`.

You can find everything about GenServer [in the documentation](https://hexdocs.pm/elixir/1.12/GenServer.html).

Any suggestion? Please, send me an email [here](mailto:wbotelhos@gmail.com).
