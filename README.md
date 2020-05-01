# SmartCore::Types &middot; [![Gem Version](https://badge.fury.io/rb/smart_types.svg)](https://badge.fury.io/rb/smart_types) [![Build Status](https://travis-ci.org/smart-rb/smart_types.svg?branch=master)](https://travis-ci.org/smart-rb/smart_types)

> A set of objects that acts like types (type checking and type casting) with a support for basic type algebra.

Full-featured type system for any ruby project. Supports custom type definitioning,
type validation, type casting and type categorizing. Provides a set of commonly used type
categories and general purpose types. Has a flexible and simplest type definition toolchain.

Just add and use :) Enjoy! :)

## Installation

```ruby
gem 'smart_types'
```

```shell
bundle install
# --- or ---
gem install smart_types
```

```ruby
require 'smart_core/types'
```

---

## Type Interface

```ruby
# documentation is coming

type.valid?(value)
type.validate!(value)
type.cast(value)
type.nilable
type3 = type1 | type2
type4 = type1 & type2
```

## Supported types

- Primitive Value Types:

```ruby
SmartCore::Types::Value::Any
SmartCore::Types::Value::String
SmartCore::Types::Value::Symbol
SmartCore::Types::Value::Text
SmartCore::Types::Value::Integer
SmartCore::Types::Value::Float
SmartCore::Types::Value::Numeric
SmartCore::Types::Value::Boolean
SmartCore::Types::Value::Array
SmartCore::Types::Value::Hash
SmartCore::Types::Value::Proc
SmartCore::Types::Value::Class
SmartCore::Types::Value::Module
```

---

## Nilable types

```ruby
SmartCore::Types::Value::Any.nilable
SmartCore::Types::Value::String.nilable
SmartCore::Types::Value::Symbol.nilable
SmartCore::Types::Value::Text.nilable
SmartCore::Types::Value::Integer.nilable
SmartCore::Types::Value::Float.nilable
SmartCore::Types::Value::Numeric.nilable
SmartCore::Types::Value::Boolean.nilable
SmartCore::Types::Value::Array.nilable
SmartCore::Types::Value::Hash.nilable
SmartCore::Types::Value::Proc.nilable
SmartCore::Types::Value::Class.nilable
SmartCore::Types::Value::Module.nilable
```

---

## Constrained types

```ruby
# documentation is coming
```

---

## Type validation and type casting

```ruby
# documentation is coming
```

---

## Custom type definition

```ruby
# documentation is coming

# example:
SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker do |value|
    value.is_a?(::String)
  end

  type.define_caster do |value|
    value.to_s
  end
end
```

---

## Basic type algebra

```ruby
# documentation is coming
```

---

## Type system integration

```ruby
# documentation is coming
```

---

## Roadmap

- type configuration

```ruby
SmartCore::Types::Value.type(:Time) do |type|
  type.configuration do |config| # config definition
    setting :iso, :rfc2822
    # TODO: think about a more convinient DSL
  end

  type.define_caster do |value, config| # config usage
    case config.standard
    when :rfc2822
      ::Time.rfc2822(value)
    else
      # ...
    end
  end
end
```

- pipelined type caster definition for the sum-based types:

```ruby
SmartCore::Types::Value::TimeLike = SmartCore::Types::System.type_sum(
  SmartCore::Types::Time,
  SmartCore::Types::DateTime,
  SmartCore::Types::Date,
) do |type|
  type.define_caster(:pipelined) # try Time.cast => try DateTime.cast => try Date.cast
end
```

- namespaced type errors

```ruby
# before:
SmartCore::Types::Value::Boolean.validate!(123)
# => SmartCore::Types::TypeError

# after:
SmartCore::Types::Value::Boolean.validate!(123)
# => SmartCore::Types::Value::Boolean::TypeError
# (inheritance tree: Types::Value::<Type>::TypeError => Types::Value::TypeError => Types::TypeError)
```

## Contributing

- Fork it ( https://github.com/smart-rb/smart_types )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
