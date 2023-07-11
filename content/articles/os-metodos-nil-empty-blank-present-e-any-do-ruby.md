---
date: 2012-12-25T00:00:00-03:00
description: "Os métodos nil?, empty?, blank?, present? e any? do Ruby"
tags: ["nil", "empty", "blank", "present", "any", "ruby"]
title: "Os métodos nil?, empty?, blank?, present? e any? do Ruby"
url: "os-metodos-nil-empty-blank-present-e-any-do-ruby"
---

Ok, nem todos eles são do Ruby, mas por mais que pareça simples, no decorrer do desenvolvimento paramos para analizar qual método utilizar para verificar se um objeto esta vazio, se é nulo ou não e afim. Para facilitar a memorização, vamos reunir aqui algumas situações.

### Objetivo

Diferenciar o uso dos métodos `nil?`, `empty?`, `blank?`, `present?` e `any?` para aplicá-los da melhor forma.

### nil?

Este é o mais simples dos métodos, pois ele simplesmente verifica se algo é nulo, onde apenas `nil` irá retornar `true`:

```rb
nil.nil? # true
qualquer_outra_coisa.nil? # false
```

### empty?

A princípio este método é simples e até bem inteligente por verificar até se um hash esta vazio:

```rb
''.empty? # true
[].empty? # true
{}.empty? # true
```

Repare que uma string é vazia se não existir nada nela, nem mesmo espaços em branco, pois este método não faz um `trim` na string e é ai que começa a confusão, pois:

```rb
' '.empty? # false
[nil].empty? # false
{ key: nil }.empty? # false
```

Uma string com espaço, um array com um elemento, mesmo este sendo o próprio `nil` ou um hash que contenha uma chave cujo valor seja `nil` irá retornar `false`.

Precisamos ter cuidado para não utilizarmos o método `empty?` em objetos nulos:

```rb
nil.empty? # NoMethodError: undefined method `empty?` for nil:NilClass
```

Dai surgem aquelas velhas condicionais que são muito chatas, principalmente em Java:

```java
cat != null && !cat.empty()
```

E que a princípio não conseguimos escapar em Ruby:

```rb
!cat.nil? && !cat.empty?
```

Haveria algo que verifica se um objeto não é nulo e nem vazio para acabar com essas duas condições? Sim! É ai que entra o `blank?`.

### blank?

Introduzido pelo [ActiveSupport](http://guides.rubyonrails.org/active_support_core_extensions.html "ActiveSupport"), este método faz o seu trabalho além de englobar os resultados do método `empty?`:

```rb
' '.blank? # true
nil.blank? # true
false.blank? # true
"\t".blank? # true
"\n".blank? # true

0.blank # false

# Herança do método `empty?`:
''.blank? # true
[].blank? # true
{}.blank? # true

' '.blank? # false
[nil].blank? # false
{ key: nil }.blank? # false
```

> Para números, mesmo sendo o zero o valor é `falso`, então esqueça aquela história do JavaScript.

Sendo assim podemos refatoração as duas condicionais citadas anteriormente:

```rb
# !cat.nil? && !cat.empty?
!cat.blank?
```

Mas não é legal comparações negativas e seria uma boa termos uma comparação positiva, que é o caso do `present?`.

### present?

Este método é simplesmente o negado do `blank?`:

```rb
def present?
  !blank?
end
```

Logo podemos refatorar o nosso método da seguinte forma:

```rb
# !cat.nil? && !cat.empty?
cat.present?
```

Se você precisar retornar o próprio objeto, em uma condicional, se ele não for vazio, uma variante boa do `present?` é o método [presence](http://api.rubyonrails.org/classes/Object.html#method-i-presence "Presence").

### any?

Por fim temos um método para trabalhar em cima de arrays e hashes, no qual passamos um bloco para fazermos a condição:

```rb
['cat'].any? { |item| item == 'cat' } # true
```

Mas com frequência vemos o uso deste método sem a passagem do bloco, que faz o Ruby passar um bloco implícito com o próprio objeto que estamos aplicando o método: `{ |this| this }`. Sendo assim, se algo for retornado do array ou do hash receberemos `true`:

```rb
[''].any? # true
[nil].any? # true
{ key: nil }.any? # true

[].any? # false
{}.any? # false
[false].any? # false
```

Veja que o próprio conteúdo do objeto é analizado, logo o retorno de uma string em branco representa alguma coisa (uma string em branco), porém o valor `false` será ele mesmo: `false`.

Vale lembrar que aqui temos o mesmo problema do `empty?`, onde devemos tomar cuidado com o nil:

```sh
NoMethodError: undefined method `any?` for nil:NilClass
```
