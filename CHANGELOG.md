# Changelog
All notable changes to this project will be documented in this file.

# [0.4.0] - 2021-01-18
### Added
- Support for *Ruby 3*;

## [0.3.0] - 2020-12-22
### Added
- Extended **Type Definition API**: support for **runtime attributes**:
  - Type checkers, type casters and type invariants now receives runtime attributes (you can omit these);
  - Type definitioning extended with `runtime_attribute_checker`-checker definition (runtime attributes validator);
  - Types with incorrect runtime attributes will raise `SmartCore::Types::IncorrectRuntimeAttributesError` exception;
  - Types which has no support for runtime attributes will raise `SmartCore::Types::RuntimeAttributesUnsupportedError` excpetion;
  - All types by default has a method alias (`()`) which does not allow runtime attributes (for example: `SmartCore::Types::Value::String` has
    a runtime-based alias `SmartCore::Types::Value::String()` which does not accept any attribute
    (`SmartCore::Types::Value::String('test')` will raise `SmartCore::Types::RuntimeAttributesUnsupportedError` respectively));
- Extended Internal **Type Development API**:
  - all types has a reference to it's type category;
- Brand new `SmartCore::Types::Protocol` type category and new types:
  - `SmartCore::Types::Protocol::InstanceOf` (runtime-based type);
- Brand new `SmartCore::Types::Variadic` type category and new types:
  - `SmartCore::Types::Variadic::Tuple` (runtime-based type);
- New types of `SmartCore::Types::Value` category:
  - `SmartCore::Types::Value::Set` (based on `Set` type with a support for type casting);
- Support for BasicObject values inside type checkers that can not be checked correctly via `#is_a?/#kind_of?` before;

### Changed
- Updated development dependencies;
- Drop `Travis CI` (TODO: migrate to `Github Actions`);
- **Ruby@2.4** is no longer supported;

## [0.2.0] - 2020-11-21
### Added
- Brand new **Type invariant API**:
  - globally refactored validation logic (with backward compatability for `#valid?(value)` method);
  - new type definition DSL: `.invariant(name)` and `.invariant_chain(name)`;
  - chained invariants will be invoked according to the definition order (second invokation
    depends on previous successful invariant check);
  - new validation API: `validate(value)` (with `#errors` support based on invariant names);
  - at this moment Invariant API is supported only by primitive types (type sum and type multiplication support coming soon);

### Changed

- Updated `smart_engine` dependency (to `~> 0.7`) (need `SmartCore::Engine::Atom`);

## [0.1.0] - 2020-05-05
- Release :)
