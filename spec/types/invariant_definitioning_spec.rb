# frozen_string_literal: true

RSpec.describe 'Type invariant definitioning' do
  specify 'SMOKE (all features): invariant definition' do
    SmartCore::Types::Value.define_type(:LikeTimeForSpec) do |type|
      type.define_checker do |value|
        value.is_a?(::Time) || value.is_a?(::Date) || value.is_a?(::String)
      end

      type.invariant_chain(:time_control) do
        invariant(:parsable_date) do |value|
          begin
            case
            when value.is_a?(::String)
              !!::Date.parse(value)
            else
              true
            end
          rescue
            false
          end
        end

        invariant(:parsable_time) do |value|
          begin
            case
            when value.is_a?(::String)
              !!::Time.parse(value)
            else
              true
            end
          rescue
            false
          end
        end
      end

      type.invariant(:danger_time) do |value|
        value.is_a?(::String) ? value != '00.00.0000' : true
      end

      type.invariant(:empty_value) do |value|
        value != ''
      end

      # TODO: invariant refinements
      #   type.refine_invariant(:present?)
      #   type.refine_invariant_chain(:chain_name)
    end

    nilable_type = SmartCore::Types::Value::LikeTimeForSpec.nilable

    # valid? => true
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?(::Time.now)).to eq(true)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?(::Date.new)).to eq(true)
    # valid? => false
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?(123)).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?(123.456)).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?((-> {}))).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?((proc {}))).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?([])).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?({})).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?(Object.new)).to eq(false)
    expect(SmartCore::Types::Value::LikeTimeForSpec.valid?(nil)).to eq(false)

    # good value
    good_result = SmartCore::Types::Value::LikeTimeForSpec.validate('01.01.2020')

    expect(good_result.success?).to eq(true)
    expect(good_result.failure?).to eq(false)

    expect(good_result.valid_invariants?).to eq(true)
    expect(good_result.valid_check?).to eq(true)
    expect(good_result.errors).to eq([])

    expect(good_result.is_valid_check).to eq(good_result.valid_check?)
    expect(good_result.invariant_errors).to eq(good_result.errors)
    expect(good_result.error_codes).to eq(good_result.errors)

    # bad value
    bad_result = SmartCore::Types::Value::LikeTimeForSpec.validate('')

    expect(bad_result.success?).to eq(false)
    expect(bad_result.failure?).to eq(true)

    expect(bad_result.valid_invariants?).to eq(false)
    expect(bad_result.valid_check?).to eq(true)
    expect(bad_result.errors).to contain_exactly(
      'time_control.parsable_date',
      'empty_value'
    )

    # good value
    good_result = nilable_type.validate(nil)

    expect(good_result.success?).to eq(true)
    expect(good_result.failure?).to eq(false)

    expect(good_result.valid_check?).to eq(true)
    expect(good_result.is_valid_check).to eq(good_result.valid_check?)
    expect(good_result.valid_invariants?).to eq(true)
    expect(good_result.errors).to eq([])
    expect(good_result.invariant_errors).to eq(good_result.errors)
    expect(good_result.error_codes).to eq(good_result.errors)

    # bad value
    bad_result = nilable_type.validate('00.00.0000')

    expect(bad_result.success?).to eq(false)
    expect(bad_result.failure?).to eq(true)

    expect(bad_result.valid_check?).to eq(true)
    expect(bad_result.is_valid_check).to eq(bad_result.valid_check?)
    expect(bad_result.valid_invariants?).to eq(false)
    expect(bad_result.errors).to contain_exactly('time_control.parsable_date', 'danger_time')
    expect(good_result.invariant_errors).to eq(good_result.errors)
    expect(good_result.error_codes).to eq(good_result.errors)
  end
end
