# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]
### Added
- Extended *Type Definition API*: support for types with runtime attributes:
  - Type checkers, type casters and type invariants now receives runtime attributes (you can omit these);
- Internal *Type Development API*: all types has a reference to it's type category;
- Brand new `SmartCore::Types::Protocol` type category;
- New types:
  - `SmartCore::Types::Protocol::InstanceOf` (runtime-based type);
  - `SmartCore::Types::Value::Set`;

### Changed
- *Ruby@2.4* is no longer supported;

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
