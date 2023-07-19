---
date: 2023-07-18T00:00:00-03:00
description: "SOLID Principles"
tags: ["solid", "principles", "single-responsability", "open-closed", "liskov-substitution", "interface-segregation", "dependency-inversion", "srp", "ocp", "isp", "dip"]
title: "SOLID Principles"
url: "solid-principles"
---

The SOLID Principles are five ways to make Object Oriented programming better to deal with.

# Goal

Explain each of the five principles:

- (S)ingle Responsibility
- (O)pen Closed
- (L)iskov Substitution
- (I)nterface Segregation
- (D)ependency Inversion

# Single Responsability (SRP)

> "A class should have one, and only one reason to change."

The point here is to make sure that one specific method should do only one thing, not two or more.

Imagine a method to display an account balance:

```rb
class Balancer
  def self.get(account)
    "Balance: #{account.balance.round(2)}"
  end
end
```

```rb
Balancer.get(OpenStruct.new(balance: 42.125))

# "Balance: 42.13"
```

Now you need to send this value to an API to format it. Any problem? Yes, It's a text where the method is doing more than one thing not having a single responsibility. Let's fix it:

```rb
class Balancer
  def self.get(account)
    account.balance.round(2)
  end
end

class BalancerDecorator
  def self.show(value)
    "Balance: #{value}"
  end
end
```

Now we have two separate responsibilities, one to get the balance and another one to format the value:

```rb
balance = Balancer.get(account)
formatted_balance = API.format(balance)

BalanerDecorator.show(formatted_balance)

# "Balance: $42.13"
```

It's now more readable and decoupled making things easier to deal with, like get the result and send it to an external API.

# Open Closed (OCP)

> "You should be able to extend a class's behavior without modifying it."

It's a kind of use of the [Liskov Substitution](#liskov-substitution) and [Dependency Inversion](#dependency-inversion) together to solve the problem.
The point here is to enable you to use a code but not allow you to change its original content.

So imagine a class responsible to get the balance from a bank account:

```rb
class Balancer
  def self.get(account)
    if account.agency.present? && account.number.present?
      account.get_balance
    end
  end
end
```

After a while you need to get the balance from a blockchain wallet, so you do:

```rb
class Balancer
  def self.get(account)
    if account.bank?
      if account.agency.present? && account.number.present?
        account.get_balance
      end
    elsif account.wallet?
      if account.chain.present? && account.address.present?
        account.total
      end
    end
  end
end
```

For every account type, you'll need to modify the `Balancer` class not respecting the "closed for modification" because you're modifying it and for sure you're not extending it.

If you think about an interface you can abstract the way we validate the account and the way we get the balance using consistent methods name:

```rb
class Bank
  def balance
    get_balance
  end

  def valid?
    agency.present? && number.present?
  end
end
```

```rb
class Wallet
  def balance
    total
  end

  def valid?
    chain.present? && address.present?
  end
end
```

And now you can just trust that interface:

```rb
class Balancer
  def self.get(account)
    account.balance if account.valid?
  end
end
```

```rb
Balancer.get(Bank.new(agency: '001', number: '12345-6'))
Balancer.get(Wallet.new(chain: 'polygon', address: '0x824EaeZ'))
```

Now for every new account type, you just need to respect the `valid?` and `balance` interface.

# Liskov Substitution (LSP)

> "Derived classes must be substitutable for their base classes."

In the previous principle `Bank` and `Wallet` were two different classes representing an account.
This principle says: where you receive a `Bank` or `Account` you should be able to replace it with `Account` if it is their base class.

So we could improve the last principle by creating the base class:

```rb
class Account
  def balance
    raise("balance not implemented yet!")
  end

  def valid?
    raise("valid? not implemented yet!")
  end
end
```

And making sure `Bank` and `Wallet` inherit from it:

```rb
class Bank < Account
end

class Wallet < Account
end
```

So the `Balancer` could receive both classes or now be substituted by `Account`:

```rb
class Balancer
  def self.get(account: Account)
  end
end
```

And any class provided to `Balancer` that does not implement `balance` or `valid?` is breaking this principle.

# Interface Segregation (ISP)

> "Make fine-grained interfaces that are client-specific."

The point here is to avoid methods on the interface that whoever inherits from it won't use it.

Imagine the class `Account` having the method called `swap`:

```rb
class Account
  # ...

  def swap(_token)
    raise("swap not implemented yet!")
  end
end
```

In this case the class `Wallet` can use it, but not the class `Bank`.

So instead to force `Bank` and others to implement it, just move it to the specific class:

```rb
class Wallet
  # ...

  def swap(token)
    # ...
  end
end
```

If you accumulate too many specific methods for a use case, maybe it should become a new interface like a `Web3Account`.

# Dependency Inversion (DIP)

> "Depend on abstractions, not on concretions."

A base class should be always generic enough to not refer to a specialized class otherwise a second class inheriting from the base class would automatically need to know the specific class either, and we don't want this dependency.

Let's see an example already used that presents us the injection:

```rb
class Balancer
  def self.get(account: Account)
  end
end
```

Here we allow any `Account` class. Using the base class we can accept the `Bank` or `Wallet` or any other class that inherit from `Account`. With this, we just inject a specialized class that doesn't let `Balancer` know a specific implementation trusting in the interface:

```rb
Balancer.get(Bank.new(agency: '001', number: '12345-6'))
Balancer.get(Wallet.new(chain: 'polygon', address: '0x824EaeZ'))
```

The `Balancer` just cares about the class being able to respond to `valid?` and `balance`.

Use Dependency Injection helps a lot to create better tests since you can create [doubles](https://en.wikipedia.org/wiki/Test_double) to simulate a real object of `Account` type. Or even inject a [Fake Object](https://en.wikipedia.org/wiki/Mock_object) that receives an URL and returns a fake response avoiding your test access to the internet and making your test slow.

# Conclusion

The SOLID Principle helps us a lot to build better software and each principle is related to other, like OCP that need to receive a DIP and its object should have a good ISP to be possible to use the LSP. And I hope you write a good SRP to avoid troubles in the future.

Any suggestion? Please, send me an email [here](mailto:wbotelhos@gmail.com).
