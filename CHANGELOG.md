# Changelog
All notable changes to this project will be documented in this file.

## Unreleased
- Brand new **Type invariant API**:
  - globally refactored validation logic (with backward compatability for `#valid?(value)` method);
  - new type definition DSL: `.invariant(name)` and `.invariant_chain(name)`;
  - chained invariants will be invoked according to the definition order (second invokation
    depends on previous successful invariant check);
  - new validation API: `validate(value)` (with `#errors` support based on invariant names);

## [0.1.0] - 2020-05-05
- Release :)
