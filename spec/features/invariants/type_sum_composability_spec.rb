# frozen_string_literal: true

RSpec.describe 'INVARIANTS: Type sum composability' do
  SmartCore::Types::Value.define_type(:InvFirstSumTypeSpec) do |type|
    type.define_checker { |value| value.is_a?(::Integer) }

    type.invariant_chain(:range) do
      invariant(:non_zero) { |value| value != 0 }
      invariant(:not_59) { |value| value != 59 }
    end

    type.invariant(:danger_value) { |value| value != 25 }
  end

  SmartCore::Types::Value.define_type(:InvSecSumTypeSpec) do |type|
    type.define_checker { |value| value.is_a?(::Float) }

    type.invariant_chain(:range) do
      invariant(:less_than_100) { |value| value < 100 }
      invariant(:more_than_10) { |value| value > 10 }
    end

    type.invariant(:danger_value) { |value| value != 70.0 }
  end

  SmartCore::Types::Value::InvSumTypeSpec = SmartCore::Types::System.type_sum(
    SmartCore::Types::Value::InvFirstSumTypeSpec,
    SmartCore::Types::Value::InvSecSumTypeSpec
  )

  let!(:sum_type) { SmartCore::Types::Value::InvSumTypeSpec }
  let!(:nilable_sum_type) { SmartCore::Types::Value::InvSumTypeSpec.nilable }

  specify do
    sum_type.validate(55.0)
    nilable_sum_type.validate(55.0)
    sum_type.valid?(55.0)
    nilable_sum_type.valid?(55.0)
  end
end
