# frozen_string_literal: true

RSpec.describe 'INVARIANTS: definitioning and logic' do
  SmartCore::Types::Value.define_type(:LikePasswordForRSpec) do |type|
    type.define_checker { |value| value.is_a?(::String) }
    type.invariant_chain(:security) do
      invariant(:minimal_length) { |value| value.size >= 8 }
      invariant(:has_digits) { |value| value.match?(/[0-9]+/) }
    end
    type.invariant_chain(:compatability) do
      invariant(:count_bound) { |value| value.size <= 25 }
      invariant(:no_spaces) { |value| !value.match?(/\s/) }
    end
    type.invariant(:non_empty) { |value| value != '' }
    type.invariant(:danger_pass) { |value| value != 'test123' }
  end

  let!(:type) { SmartCore::Types::Value::LikePasswordForRSpec }
  let!(:nilable_type) { type.nilable }

  describe 'invariant functionality' do
    specify 'affects <#valid?(value)> method too' do
      aggregate_failures('affection_of_valid') do
        # checker - passed, invariants - passed => valid
        expect(type.valid?('test1234')).to eq(true)
        # for nilable
        expect(nilable_type.valid?('test1234')).to eq(true)

        # checker - pased, invariants - not passed => invalid
        expect(type.valid?('test')).to eq(false)
        expect(type.valid?('')).to eq(false)
        expect(type.valid?('test123')).to eq(false)
        expect(type.valid?(' ')).to eq(false)
        expect(type.valid?('testtest')).to eq(false)
        expect(type.valid?('test1234test1234test1234test1234')).to eq(false)
        # for nilable
        expect(nilable_type.valid?('test')).to eq(false)
        expect(nilable_type.valid?('')).to eq(false)
        expect(nilable_type.valid?('test123')).to eq(false)
        expect(nilable_type.valid?(' ')).to eq(false)
        expect(nilable_type.valid?('testtest')).to eq(false)
        expect(nilable_type.valid?('test1234test1234test1234test1234')).to eq(false)

        # checker - not passed => invairants - not checked
        expect(type.valid?(1234)).to eq(false)
        expect(type.valid?(::Time.now)).to eq(false)
        expect(type.valid?(nil)).to eq(false)
        # for nilable
        expect(nilable_type.valid?(1234)).to eq(false)
        expect(nilable_type.valid?(::Time.now)).to eq(false)
        expect(nilable_type.valid?(nil)).to eq(true)
      end
    end

    describe '#validate(value)/#validate!(value) with monadic Result objects' do
      specify 'nilable type, nil value => <succcessful result>' do
        aggregate_failures('result_state') do
          result = nilable_type.validate(nil)
          expect { nilable_type.validate!(nil) }.not_to raise_error

          expect(result.success?).to eq(true)
          expect(result.failure?).to eq(false)

          expect(result.valid_check?).to eq(true)
          expect(result.valid_invariants?).to eq(true)
          expect(result.is_valid_check).to eq(result.valid_check?)

          expect(result.error_codes).to eq([])
          expect(result.errors).to eq(result.error_codes)
          expect(result.invariant_errors).to eq(result.error_codes)
        end
      end

      specify 'valid type check, valid invariants => <successful result>' do
        aggregate_failures('result_state') do
          [type.validate('TeSt1234_!'), nilable_type.validate('TeSt1234_!')].each do |result|
            expect(result.success?).to eq(true)
            expect(result.failure?).to eq(false)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(true)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to eq([])
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!('TeSt1234_!') }.not_to raise_error
          expect { nilable_type.validate!('TeSt1234_!') }.not_to raise_error
        end
      end

      specify 'invalid type check => no invariant checking, <failure result>' do
        aggregate_failures('failure_result_state') do
          [type.validate(::Object.new), nilable_type.validate(::Object.new)].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(false)
            expect(result.valid_invariants?).to eq(true) # cuz not checked at all
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to eq([]) # cuz not checked at all
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!(::Object.new) }.to raise_error(
            SmartCore::Types::TypeError
          )
          expect { nilable_type.validate!(::Object.new) }.to raise_error(
            SmartCore::Types::TypeError
          )
        end
      end

      specify 'valid type check, invalid invariants => failed result' do
        aggregate_failures('unsecure/incompatible') do
          [type.validate('pas wrd'), nilable_type.validate('pas wrd')].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(false)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to contain_exactly(
              'LikePasswordForRSpec.security.minimal_length',
              'LikePasswordForRSpec.compatability.no_spaces'
            )
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!('pas wrd') }.to raise_error(SmartCore::Types::TypeError)
          expect { nilable_type.validate!('pas wrd') }.to raise_error(SmartCore::Types::TypeError)
        end

        aggregate_failures('unsecure/danger') do
          [type.validate('test123'), nilable_type.validate('test123')].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(false)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to contain_exactly(
              'LikePasswordForRSpec.security.minimal_length',
              'LikePasswordForRSpec.danger_pass'
            )
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!('test123') }.to raise_error(SmartCore::Types::TypeError)
          expect { nilable_type.validate!('test123') }.to raise_error(SmartCore::Types::TypeError)
        end

        aggregate_failures('unsecure/danger') do
          [type.validate('testtesttest'), nilable_type.validate('testtesttest')].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(false)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to contain_exactly(
              'LikePasswordForRSpec.security.has_digits'
            )
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!('testtesttest') }.to raise_error(
            SmartCore::Types::TypeError
          )
          expect { nilable_type.validate!('testtesttest') }.to raise_error(
            SmartCore::Types::TypeError
          )
        end

        aggregate_failures('empty/unsecure') do
          [type.validate(''), nilable_type.validate('')].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(false)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to contain_exactly(
              'LikePasswordForRSpec.non_empty',
              'LikePasswordForRSpec.security.minimal_length'
            )
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!('') }.to raise_error(SmartCore::Types::TypeError)
          expect { nilable_type.validate!('') }.to raise_error(SmartCore::Types::TypeError)
        end

        aggregate_failures('incompatible') do
          [
            type.validate("#{'test' * 4}#{'1234' * 4}"),
            nilable_type.validate("#{'test' * 4}#{'1234' * 4}")
          ].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(false)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to contain_exactly(
              'LikePasswordForRSpec.compatability.count_bound'
            )
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!("#{'test' * 4}#{'1234' * 4}") }.to raise_error(
            SmartCore::Types::TypeError
          )
          expect { nilable_type.validate!("#{'test' * 4}#{'1234' * 4}") }.to raise_error(
            SmartCore::Types::TypeError
          )
        end

        aggregate_failures('incompatible(no_spaces)') do
          [
            type.validate('test1234 test1234'),
            nilable_type.validate('test1234 test1234')
          ].each do |result|
            expect(result.success?).to eq(false)
            expect(result.failure?).to eq(true)

            expect(result.valid_check?).to eq(true)
            expect(result.valid_invariants?).to eq(false)
            expect(result.is_valid_check).to eq(result.valid_check?)

            expect(result.error_codes).to contain_exactly(
              'LikePasswordForRSpec.compatability.no_spaces'
            )
            expect(result.errors).to eq(result.error_codes)
            expect(result.invariant_errors).to eq(result.error_codes)
          end

          expect { type.validate!('test1234 test1234') }.to raise_error(
            SmartCore::Types::TypeError
          )
          expect { nilable_type.validate!('test1234 test1234') }.to raise_error(
            SmartCore::Types::TypeError
          )
        end
      end
    end
  end
end
