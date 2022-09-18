# SmartCore::Types &middot; <a target="_blank" href="https://github.com/Cado-Labs"><img src="https://github.com/Cado-Labs/cado-labs-logos/raw/main/cado_labs_badge.svg" alt="Supported by Cado Labs" style="max-width: 100%; height: 20px"></a> &middot; [![Gem Version](https://badge.fury.io/rb/smart_types.svg)](https://badge.fury.io/rb/smart_types) ![ci](https://github.com/smart-rb/smart_types/workflows/ci/badge.svg?branch=master) [![coverage](https://coveralls.io/repos/github/smart-rb/smart_types/badge.svg?branch=master)](https://coveralls.io/github/smart-rb/smart_types?branch=master)

> A set of objects that acts like types (type checking and type casting) with a support for basic type algebra.

Minimalistic type system for any ruby project. Supports custom type definition,
type validation, type casting and type categorizing. Provides a set of commonly used type
categories and general purpose types. Has a flexible and simplest type definition toolchain.

---

<p>
  <a href="https://github.com/Cado-Labs">
    <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_supporting.svg" alt="Supported by Cado Labs" />
  </a>
</p>

---

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

## Usage

- [Type interface and basic type algebra](#type-interface-and-basic-type-algebra)
- [Supported types](#supported-types)
  - [Primitives](#primitives) (`SmartCore::Types::Value`)
  - [Protocols](#protocols) (`SmartCore::Types::Protocol`)
  - [Variadic](#variadic) (`SmartCore::Types::Variadic`)
- [Nilable types](#nilable-types)
- [Custom type definition](#custom-type-definition)
  - [Primitive type definition](#primitive-type-definition)
  - [With type invariants](#with-type-invariants)
- [Type validation](#type-validation)
- [Type casting](#type-casting)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Build](#build)
- [License](#license)
- [Authors](#authors)

---

## Type Interface and basic type algebra

```ruby
# documentation is coming

type.valid?(value)
type.validate!(value)
type.cast(value)
type.nilable
type3 = type1 | type2
type4 = type1 & type2
```

Types with runtime:

```ruby
# get a type object with a custom runtime (instances of String or Symbol):
type = SmartCore::Types::Protocol::InstanceOf(::String, ::Symbol)
type.valid?(:test) # => true
type.valid?('test') # => true
type.valid?(123.456) # => false

# another type object with a custom runtime (tuple (String, Integer, Time)):
type = SmartCore::Types::Variadic::Tuple(::String, ::Integer, ::DateTime)
type.valid?(['test', 1, DateTime.new]) # => true
type.valid?([:test, 2]) # => false
```

## Supported types

#### Primitives:

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
SmartCore::Types::Value::Set
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

#### Protocols:

```ruby
SmartCore::Types::Protocol::InstanceOf
```

```ruby
# examples (SmartCore::Types::Protocol::InstanceOf):
SmartCore::Types::Protocol::InstanceOf(::Integer) # only integer
SmartCore::Types::Protocol::InstanceOf(::String, ::Symbol) # string or symbol
SmartCore::Types::Protocol::InstanceOf(::Time, ::DateTime, ::Date) # time or datetime or date
```

---

#### Variadic:

```ruby
SmartCore::Types::Variadic::ArrayOf
SmartCore::Types::Variadic::Enum
SmartCore::Types::Variadic::Tuple
```

```ruby
# example (SmartCore::Types::Variadic::ArrayOf):
SmartCore::Types::Variadic::ArrayOf(::String, ::Array) # array of strings or arrays

# example (SmartCore::Types::Variadic::Enum):
SmartCore::Types::Variadic::Enum('string', 1337, :symbol) # one of enumerated values

# examples (SmartCore::Types::Variadic::Tuple):
SmartCore::Types::Variadic::Tuple(::String, ::Integer, ::Time) # array with signature [<string>, <integer>, <time>]
SmartCore::Types::Variadic::Tuple(::Symbol, ::Float) # array with signature [<symbol>, <float>]
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

## Custom type definition

Type definition is a composition of:

- type checker (required);
- type caster (optional);
- type invariants (optional);
- type invariant chains (optional);

Invariant is a custom validation block that will work as a logical value checker. You can have as much invariants as you want.

Type invariants does not depends on each other (invariant defined out from chain does not depends on other invariants);

Invariants inside invariant chains will be invoked in order they was defined and each internal invariant depends on the valid previous invariant check.

**!IMPORTANT!** Type sum and type multiplication does not support invariant checking and custom invariant definition at this moment.
Type sum and type mult ignores type invariants in their validation logic (currently this functionality in development yet).

Invariant checking is a special validation layer (see [#type validation](#type-validation) readme section). Invariant error code pattern:
  - for invariant chains: `TypeName.invariant_chain_name.invariant_name`;
  - for single invariant: `TypeName.invariant_name`;

#### Primitive type definition

```ruby
# documentation is coming

# example:
SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker do |value, runtime_attrs| # runtime attributes are optional
    value.is_a?(::String)
  end

  type.define_caster do |value, runtime_attrs| # runtime attributes are optional
    value.to_s
  end
end

# get a type object:
SmartCore::Types::Value::String
# --- or ---
SmartCore::Types::Value::String() # without runtime attributes
# --- or ---
SmartCore::Types::Value::String('some_attr', :another_attr) # with runtime attributes

# work with type object: see documentation below
```

#### With type invariants

```ruby
SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker do |value, runtime_attrs|
    value.is_a?(::String)
  end

  type.define_caster do |value, runtime_attrs|
    value.to_s
  end

  # NOTE:
  #    invariant defined out from chain does not depends on other invariants
  type.invariant(:uncensored_content) do |value, runtime_attrs|
    !value.include?('uncensored_word')
  end

  type.invariant(:filled) do |value, runtime_attrs|
    value != ''
  end

  type.invariant_chain(:password) do
    invariant(:should_present) do |value, runtime_attrs|
      value != ''
    end

    invariant(:should_have_numbers) do |value, runtime_attrs|
      v.match?(/[0-9]+/)
    end

    # NOTE:
    #   inside a chain each next invariant invocation
    #   depends on previous successful invariant check
  end
end
```

---

## Type validation

Type validation reflects on two APIs:

- type checker ([how to define type checkers](#custom-type-definition));
- type invariants (invariants and invariant chains) ([how to define type invariants](#custom-type-definition));

Type invariants does not depends on each other (invariant defined out from the chain does not depends on other invariants);

Invariants inside invariant chains will be invoked in order they was defined and each internal invariant depends on the valid previous invariant check.

**!IMPORTANT!** Type sum and type multiplication does not support invariant checking and custom invariant definition at this moment.
Type sum and type mult ignores type invariants in their validation logic (currently this functionality in development yet).

Invariant checking is a special validation layer (see [#type validation](#type-validation) readme section) and represents a set of error codes in result object;

Type validation interface:

- `valid?(value)` - validates value and returns `true` or `false`;
  - returns `ture` only if the type checker returns `true` and all invariants are valid;
- `validate(value)` - validates value and returns the monadic result object:
  - `SmartCore::Types::Primitive::Validator::Result` for primitive types;
  - `SmartCore::Types::Primitive::SumValidator::Result` for sum-based types;
  - `SmartCore::Types::Primitive::MultValidator::Result` for mult-based types;
  - `SmartCore::Types::Primitive::NilableValidator::Result` for nilable types;
- `validate!(value)` - validates value and returns nothing (for successful validation) or
  raises an exception (`SmartCore::Types::TypeError`) (for unsuccessful validation);

Validation result object interface:

- `#success?` / `#failure?` (`#success?` is a combination of `valid_check? && valid_invariants?`; `#failure?` - is an opposite of `#success?`);
- `#valid_check?` (valid type checker or not);
- `#valid_invariants?` (`false` if at least one invariant is invalid);
- `#errors` (the same as `#invariant_errors` and the same as `#error_codes`) - an array of failed invariant names;
  - error code patterns:
    - for invariant chains: `TypeName.invariant_chain_name.invariant_name`;
    - for single invariant: `TypeName.invariant_name`;
- `#checked_value` (the same as `#value`) - checked value :)

---

Imagine that we have `String` type like this:

```ruby
SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker do |value|
    value.is_a?(::String)
  end

  type.define_caster do |value|
    value.to_s
  end

  type.invariant(:uncensored_content) do |value|
    !value.include?('uncensored_word')
  end

  type.invariant(:filled) do |value|
    value != ''
  end

  type.invariant_chain(:password) do
    invariant(:should_present) { |value| value != '' }
    invariant(:should_have_numbers) { |value| v.match?(/[0-9]+/) }
  end
end
```

Validation interface and usage:

```ruby
SmartCore::Types::Value::String.valid?('test123') # => true
SmartCore::Types::Value::String.valid?(123.45) # => false
```

```ruby
result = SmartCore::Types::Value::String.validate('test')

result.checked_value # => 'test'
# --- same as: ---
result.value

result.success? # => false (valid_check? && valid_invariants?)
result.failure? # => true

result.valid_check? # => true
result.valid_invariants? # => false

# invariant errors:
result.errors # => ['String.password.should_have_numbers']
# -- same as: ---
result.invariant_errors
# -- same as: ---
result.error_codes
```

```ruby
result = SmartCore::Types::Value::String.validate('test1234')
result.success? # => true
result.errors # => []
```

```ruby
SmartCore::Types::Value::String.validate!('test') # => SmartCore::Types::TypeError
```

---

## Type casting

```ruby
SmartCore::Types::Value::String.cast(123) # => "123"
SmartCore::Types::Value::Float.cast('55') # => 55.0
```

---

## Basic type algebra

> (type sum and type multiplication does not support invariants at this moment (in development yet));

```ruby
# documentation is coming

# how to define primitive type sum:
SmartCore::Types::Value::Text = SmartCore::Types::Value::String | SmartCore::Types::Value::Symbol
SmartCore::Types::Value::Numeric = SmartCore::Types::Value::Float | SmartCore::Types::Value::Integer

# how to define primitive type multiplication:
SmartCore::Types::Value::CryptoString = SmartCore::Types::Value::NumberdString & SmartCore::Types::Value::SymbolicString
```

---

## Roadmap

- migrate to `Github Actions`;

- support for `block`-attribute in runtime attributes;

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
SmartCore::Types.configure do |config|
  config.warn_on_type_refinements = true # false by default
end
```

```ruby
SmartCore::Types::Value.refine(:Time) do |type|
  # new type definition
end

SmartCore::Types::Value::Time.refine do |type|
  # new type definition
end
```

```ruby
SmartCore::Types::Value::Time.refine_checker do |value, original_checker|
  # new type checker
end

SmartCore::Types::Value::Time.refine_caster do |value, original_caster|
  # new type caster
end

SmartCore::Types::Value::Time.refine_runtime_attributes_checker do |value, original_checker|
  # new runtime attribute checker
end

SmartCore::Types::Value::Time.refine_invariant(:name) do |value|
  # new invariant
end

SmartCore::Types::Value::Time.refine_invariant_chain(:chain_name) do
  # new invariant chain
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
SmartCore::Types::Value::SortedSet
SmartCore::Types::Value::IO
SmartCore::Types::Value::StringIO
SmartCore::Types::Value::BasicObject
SmartCore::Types::Struct::Schema
SmartCore::Types::Struct::JSONSchema
SmartCore::Types::Struct::StrictArray
SmartCore::Types::Struct::StrictHash
SmartCore::Types::Struct::Map
SmartCore::Types::Protocol::Interface
SmartCore::Types::Protocol::Ancestors
SmartCore::Types::Protocol::Enumerable
SmartCore::Types::Protocol::Comparable
SmartCore::Types::Protocol::Forwardable
SmartCore::Types::Protocol::Callable
SmartCore::Types::Behavior::Truthy
SmartCore::Types::Behavior::Falsy
```

```ruby
# think about:
Clonable # for example, you can not clone or duplicate Method-objects
Duplicable
Allocatable # for example, Method object can not be allocated with #allocate method
```

- `#sum` alias for `|` and `#mult` alias for `&` (with a support for type name definition and other API);

- type category in invariant error codes:
```ruby
# before:
'String.password.should_contain_numbers' # `String` type from `Value` category

# after:
'Value.String.password.should_contain_numbers' # `Value::String`
```

- support for type of empty non-defined type (`SmartCore::Types::Primitive::Undefined`);
- constrained types;
- module-based type system integration;
- constructor implementation and support;
- support for invariant checking (and custom definition) in sum-types;
  - to provide a type comparability and compatibility between all passed types
    you should provide `type.reconcilable { |value, *types| .... }`  setting;
  - `type.reconcilable` should be accessible for type sum and type mult definitions;
  - (**preliminarily**) invariants of the concrete passed type should be valid for successful invariant check;
- support for invariant checking (and definition) in mult-types;
  - to provide a type comparability and compatibility between all passed types
    you should provide `type.reconcilable { |value, *types| .... }`  setting;
  - `type.reconcilable` should be accessible for type sum and type mult definitions;
  - (**preliminarily**) all invariants of all types should be valid for successful invariant check;

## Contributing

- Fork it ( https://github.com/smart-rb/smart_types )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## Build

- run tests:

```shell
bundle exec rake rspec
# --- or ---
bundle exec rspec
```

- run code stye linting:

```shell
bundle exec rake rubocop
# --- or ---
bundle exec rubocop
```

- run code style linting with auto-correction:

```shell
bundle exec rake rubcoop -A
# --- or ---
bundle exec rubocop -A
```

## License

Released under MIT License.

## Supporting

<a href="https://github.com/Cado-Labs">
  <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_logo.png" alt="Supported by Cado Labs" />
</a>

## Authors

[Rustam Ibragimov](https://github.com/0exp)
