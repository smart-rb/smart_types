# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Float' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('123.456')).to eq(123.456)
      expect(type.cast('0')).to eq(0.0)
      expect(type.cast(nil)).to eq(0.0)
      expect(type.cast(123.456)).to eq(123.456)
      expect(type.cast(-Float::INFINITY)).to eq(-Float::INFINITY)
      expect(type.cast(Float::INFINITY)).to eq(Float::INFINITY)

      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Float }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(0.0)).to eq(true)
      expect(type.valid?(1234.567)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('123.456')).to eq(false)
      expect(type.valid?('0.0')).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(-123)).to eq(false)
      expect(type.valid?(0)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(0.0) }.not_to raise_error
      expect { type.validate!(1234.567) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('123.456') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('0.0') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(-123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(0) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Float.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(0.0)).to eq(true)
      expect(type.valid?(1234.567)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?('123.456')).to eq(false)
      expect(type.valid?('0.0')).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(-123)).to eq(false)
      expect(type.valid?(0)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(0.0) }.not_to raise_error
      expect { type.validate!(1234.567) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!('123.456') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('0.0') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(-123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(0) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
