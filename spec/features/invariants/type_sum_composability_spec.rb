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

  specify 'TODO: support for invariant checking in type sum' do
    aggregate_failures 'true-checks' do
      # (integer) common type
      result = sum_type.validate(59)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment

      # (integer) nilable type (value check)
      result = nilable_sum_type.validate(0)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment

      # (integer) nilable type (nil check)
      result = nilable_sum_type.validate(nil)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment

      # (float) common type
      result = sum_type.validate(70.0)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment

      # (float) nilable type (value check)
      result = nilable_sum_type.validate(70.0)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment

      # (float) nilable type (nil check)
      result = nilable_sum_type.validate(nil)
      expect(result.success?).to eq(true)
      expect(result.failure?).to eq(false)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment
    end

    aggregate_failures 'false-checks' do
      # (integer) common type
      result = sum_type.validate('123')
      expect(result.success?).to eq(false)
      expect(result.failure?).to eq(true)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment

      # (integer) nilable type (value check)
      result = nilable_sum_type.validate('123')
      expect(result.success?).to eq(false)
      expect(result.failure?).to eq(true)
      expect(result.errors).to eq([]) # invariant checks does not supported at this moment
    end
  end

  # rubocop:disable Layout/LineLength
  specify 'result type' do
    expect(sum_type.validate('123')).to be_a(::SmartCore::Types::Primitive::SumValidator::Result)
    expect(sum_type.validate(123)).to be_a(::SmartCore::Types::Primitive::SumValidator::Result)
    expect(sum_type.validate(123.0)).to be_a(::SmartCore::Types::Primitive::SumValidator::Result)
    expect(sum_type.validate(nil)).to be_a(::SmartCore::Types::Primitive::SumValidator::Result)
    expect(nilable_sum_type.validate(nil)).to be_a(::SmartCore::Types::Primitive::NilableValidator::Result)
  end
  # rubocop:enable Layout/LineLength
end
