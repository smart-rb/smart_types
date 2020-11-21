# frozen_string_literal: true

RSpec.describe 'INVARIANTS: Type multiplication composability' do
  SmartCore::Types::Value.define_type(:InvFirstMultTypeSpec) do |type|
    type.define_checker { |value| value.is_a?(::Integer) }

    type.define_caster { |value| ::Kernel::Integer(value) }

    type.invariant_chain(:range) do
      invariant(:non_zero) { |value| value != 0 }
      invariant(:not_59) { |value| value != 59 }
    end

    type.invariant(:danger_value) { |value| value != 25 }
  end

  SmartCore::Types::Value.define_type(:InvSecMultTypeSpec) do |type|
    type.define_checker { |value| value.is_a?(::Float) }

    type.define_caster { |value| ::Kernel::Float(value) }

    type.invariant_chain(:range) do
      invariant(:less_than_100) { |value| value < 100 }
      invariant(:more_than_10) { |value| value > 10 }
    end

    type.invariant(:danger_value) { |value| value != 70.0 }
  end

  SmartCore::Types::Value::InvMultTypeSpec = SmartCore::Types::System.type_mult(
    SmartCore::Types::Value::InvFirstMultTypeSpec,
    SmartCore::Types::Value::InvSecMultTypeSpec
  )

  let!(:mult_type) { SmartCore::Types::Value::InvMultTypeSpec }
  let!(:nilable_mult_type) { SmartCore::Types::Value::InvMultTypeSpec.nilable }

  specify('TODO: support for invariant checking in type mult') {}

  # rubocop:disable Layout/LineLength
  specify 'result type' do
    expect(mult_type.validate('123')).to be_a(::SmartCore::Types::Primitive::MultValidator::Result)
    expect(mult_type.validate(123)).to be_a(::SmartCore::Types::Primitive::MultValidator::Result)
    expect(mult_type.validate(123.0)).to be_a(::SmartCore::Types::Primitive::MultValidator::Result)
    expect(mult_type.validate(nil)).to be_a(::SmartCore::Types::Primitive::MultValidator::Result)
    expect(nilable_mult_type.validate(nil)).to be_a(::SmartCore::Types::Primitive::NilableValidator::Result)
  end
  # rubocop:enable Layout/LineLength
end
