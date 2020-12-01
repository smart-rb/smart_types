# Changelog
All notable changes to this project will be documented in this file.

## [0.3.0] - 2020-12-01
### Added
- Checker and caster are now optionally parametrized using type's `.of(*params)` or it's alias `[]`;
- New types:
  - `SmartCore::Types::Primitive::Varied::Enum`
  - `SmartCore::Types::Primitive::Varied::Variant`
  - `SmartCore::Types::Primitive::Struct::StrictHash`
  - `SmartCore::Types::Primitive::Protocol::Instance`
- Some typos fixed;

## [0.2.0] - 2020-11-21
### Added
- Brand new **Type invariant API**:
  - globally refactored validation logic (with backward compatibility for `#valid?(value)` method);
  - new type definition DSL: `.invariant(name)` and `.invariant_chain(name)`;
  - chained invariants will be invoked according to the definition order (second invocation
    depends on previous successful invariant check);
  - new validation API: `validate(value)` (with `#errors` support based on invariant names);
  - at this moment Invariant API is supported only by primitive types (type sum and type multiplication support coming soon);

### Changed

- Updated `smart_engine` dependency (to `~> 0.7`) (need `SmartCore::Engine::Atom`);

## [0.1.0] - 2020-05-05
- Release :)
