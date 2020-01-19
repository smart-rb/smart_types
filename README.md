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

## Type validation and type casting

```ruby
# documentation is coming
```

---

## Custom type definition

```ruby
# documentation is coming
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
