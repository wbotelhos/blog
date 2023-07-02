---
date: 2012-11-30T00:00:00-03:00
description: "Testando Helpers Que Usam current_user do Devise"
tags: ["helper", "devise", "current_user"]
title: "Testando Helpers Que Usam current_user do Devise"
---

Creio que a maioria dos desenvolvedores [Rails](https://github.com/rails/rails) utilizam a gem [Devise](https://github.com/plataformatec/devise) para manipular tarefas de autenticação. Pela segunda vez, perdi bons minutos quebrando a cabeça para testar um método que depende do usuário da sessão. Vejamos...

# Objetivo

Fazer um stub do `current_user` em um helper.

# Cenário

Tenho um método que retorna se o usuário logado é administrador ou não.

```ruby
def admin?
  current_user.admin?
end
```

# Conhecimento inicial

Saiba que é possível fazer o stub do `current_user` a partir do `helper`, não somente a partir do `controller`, ficando algo como:

```ruby
  allow(helper).to receive(:current_user) { User.new }
```

# Teste inicial

Sabendo disso teríamos:

```ruby
describe '#admin?' do
  context 'when user is admin' do
    before do
      allow(helper).to receive(:current_user) { User.new admin: true }
    end

    it 'returns true' do
      expect(admin?).to be_true
    end
  end
end
```

# Problema

Ao rodarmos o teste, é dado que o método `current_user` é `undefined`:

```bash
undefined local variable or method `current_user`
```

Mas como se stubamos o `current_user`? É ai que acabamos quebrando a cabeça. Veja que o stub não foi feito direto no método, mas sim, pelo `helper`. Logo precisamos apenas fazer a chamada do método a partir do `helper` também, ficando:

```ruby
expect(helper.admin?).to be_true
```

Agora estamos utilizando a parte do código com stub e o resultado será o esperado.
