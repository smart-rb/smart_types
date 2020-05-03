# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Numeric' do
  shared_examples 'type casting' do
    specify 'float => float' do
      value = type.cast(79.1)
      expect(value).to eq(79.1)
      expect(value).to be_a(::Float)
    end

    specify 'nil => float' do
      value = type.cast(nil)
      expect(value).to eq(0.0)
      expect(value).to be_a(::Float)
    end

    specify 'string => float' do
      value = type.cast('test')
      expect(value).to eq(0.0)
      expect(value).to be_a(::Float)

      value = type.cast('123')
      expect(value).to eq(123.0)
      expect(value).to be_a(::Float)

      value = type.cast('71.28')
      expect(value).to eq(71.28)
      expect(value).to be_a(::Float)

      value = type.cast('123test')
      expect(value).to eq(123.0)
      expect(value).to be_a(::Float)
    end

    specify 'integer => integer' do
      value = type.cast(99)
      expect(value).to eq(99)
      expect(value).to be_a(::Integer)
    end

    specify 'bigdecimal => bigdecimal' do
      value = type.cast(BigDecimal('100.507'))
      expect(value).to eq(BigDecimal('100.507'))
      expect(value).to be_a(::BigDecimal)
    end

    specify 'castable => numeric (integer/float/bigdecimal)' do
      as_integer = Class.new { def to_i; 123; end; }.new
      value = type.cast(as_integer)
      expect(value).to eq(123)
      expect(value).to be_a(::Integer)

      as_float = Class.new { def to_f; 22.0; end; }.new
      value = type.cast(as_float)
      expect(value).to eq(22.0)
      expect(value).to be_a(::Float)

      as_bigdecimal = Class.new { def to_d; BigDecimal('22.10'); end; }.new
      value = type.cast(as_bigdecimal)
      expect(value).to eq(BigDecimal('22.10'))
      expect(value).to be_a(::BigDecimal)
    end

    specify 'invalid casting' do
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(:test) }.to raise_error(SmartCore::Types::TypeCastingError)
    end

    context 'cast priority' do
      specify 'float > all (> integer > bigdecimal)' do
        float_has_highest_priority = Class.new do
          # rubocop:disable Layout/EmptyLineBetweenDefs
          def to_i; 1; end
          def to_f; 2.0; end
          def to_d; BigDecial('3.0'); end
          # rubocop:enable Layout/EmptyLineBetweenDefs
        end.new
        value = type.cast(float_has_highest_priority)
        expect(value).to eq(2.0)
        expect(value).to be_a(::Float)
      end

      specify 'integer > bigdecimal' do
        integer_before_bigdecimal = Class.new do
          # rubocop:disable Layout/EmptyLineBetweenDefs
          def to_i; 15; end
          def to_d; BigDecial('3.0'); end
          # rubocop:enable Layout/EmptyLineBetweenDefs
        end.new
        value = type.cast(integer_before_bigdecimal)
        expect(value).to eq(15)
        expect(value).to be_a(::Integer)
      end
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Numeric }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(123)).to eq(true)
      expect(type.valid?(123.567)).to eq(true)
      expect(type.valid?(BigDecimal('123.567'))).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(123) }.not_to raise_error
      expect { type.validate!(123.567) }.not_to raise_error
      expect { type.validate!(BigDecimal('123.567')) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Numeric.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(123)).to eq(true)
      expect(type.valid?(123.567)).to eq(true)
      expect(type.valid?(BigDecimal('123.567'))).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(123) }.not_to raise_error
      expect { type.validate!(123.567) }.not_to raise_error
      expect { type.validate!(BigDecimal('123.567')) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
