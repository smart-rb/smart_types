# SmartCore::Types &middot; [![Gem Version](https://badge.fury.io/rb/smart_types.svg)](https://badge.fury.io/rb/smart_types) [![Build Status](https://travis-ci.org/smart-rb/smart_types.svg?branch=master)](https://travis-ci.org/smart-rb/smart_types)

> A set of objects that acts like types (type checking and type casting) with a support for basic type algebra.

Minimalistic type system for any ruby project. Supports custom type definitioning,
type validation, type casting and type categorizing. Provides a set of commonly used type
categories and general purpose types. Has a flexible and simplest type definition toolchain.

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

- Primitives

```ruby
SmartCore::Types::Value::Any
SmartCore::Types::Value::Nil
SmartCore::Types::Value::String
SmartCore::Types::Value::Symbol
SmartCore::Types::Value::Text
SmartCore::Types::Value::Integer
SmartCore::Types::Value::Float
SmartCore::Types::Value::Numeric
SmartCore::Types::Value::BigDecimal
SmartCore::Types::Value::Boolean
SmartCore::Types::Value::Array
SmartCore::Types::Value::Hash
SmartCore::Types::Value::Proc
SmartCore::Types::Value::Class
SmartCore::Types::Value::Module
SmartCore::Types::Value::Time
SmartCore::Types::Value::DateTime
SmartCore::Types::Value::Date
SmartCore::Types::Value::TimeBased
```

---

## Nilable types

- invoke `.nilable` on any type object:

```ruby
SmartCore::Types::Value::String.nilable
# -- or --
SmartCore::Types::Value::Time.nilable
# and etc.
```

---

## Type validation and type casting

```ruby
# documentation is coming

SmartCore::Types::Value::String.valid?('test') # => true
SmartCore::Types::Value::String.valid?(123.45) # => false

SmartCore::Types::Value::String.cast(123) # => "123"
SmartCore::Types::Value::Float.cast('55') # => 55.0
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

## Roadmap

- type configuration:

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

- namespaced type errors:

```ruby
# before:
SmartCore::Types::Value::Boolean.validate!(123)
# => SmartCore::Types::TypeError
SmartCore::Types::Value::Class.cast(123)
# => SmartCore::Types::TypeCastingError

# after:
SmartCore::Types::Value::Boolean.validate!(123)
# => SmartCore::Types::Value::Boolean::TypeError
# (inheritance tree: Types::Value::<Type>::TypeError => Types::Value::TypeError => Types::TypeError)

SmartCore::Types::Value::Class.cast(123)
# => SmartCore::Types::Value::Class::TypeCastingError
# (inheritance tree: the same as above)
```

- type refinements:

```ruby
SmartCore::Types::Value::Time.refine_checker do |value, original_checker|
  # new type checker
end

SmartCore::Types::Value::Time.refine_caster do |value, original_caster|
  # new type caster
end
```

- options for type casters:

```ruby
SmartCore::Types::Value.define_type(:Date) do |type|
  type.define_caster do |value, options = {}| # options goes here
    iso = options.fetch(:iso, nil)
    iso ? ::Date.pasre(value, iso) : ::Date.parse(value)
  end
end

# usage:
SmartCore::Types::Value::Date.cast('2020-01-01', { iso: :rfc3339 })
```

- new types:

```ruby
SmartCore::Types::Value::Method
SmartCore::Types::Value::UnboundMethod
SmartCore::Types::Value::Enumerable
SmartCore::Types::Value::Comparable
SmartCore::Types::Value::Enumerator
SmartCore::Types::Value::EnumeratorChain
SmartCore::Types::Value::Range
SmartCore::Types::Value::Rational
SmartCore::Types::Value::Set
SmartCore::Types::Value::SortedSet
SmartCore::Types::Value::IO
SmartCore::Types::Value::StringIO
SmartCore::Types::Struct::Schema
SmartCore::Types::Struct::StrictArray
SmartCore::Types::Struct::StrictHash
SmartCore::Types::Struct::Map
SmartCore::Types::Variative::Enum
SmartCore::Types::Variative::Variant
SmartCore::Types::Protocol::InstanceOf
SmartCore::Types::Protocol::Interface
SmartCore::Types::Protocol::Ancestors
SmartCore::Types::Protocol::Enumerable
SmartCore::Types::Protocol::Comparable
SmartCore::Types::Protocol::Forwardable
SmartCore::Types::Protocol::Callable
```

- constrained types;

- module-based integration;

- constructor implementation and support;

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
