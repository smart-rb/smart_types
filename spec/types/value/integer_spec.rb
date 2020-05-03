# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Integer' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('0')).to eq(0)
      expect(type.cast('0.0')).to eq(0)
      expect(type.cast('0.1')).to eq(0)
      expect(type.cast('10.1')).to eq(10)
      expect(type.cast(123)).to eq(123)
      expect(type.cast(555.01234)).to eq(555)
      expect(type.cast('777test')).to eq(777)
      expect(type.cast('0126.2test')).to eq(126)
      expect(type.cast('test')).to eq(0)

      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)

      as_integer_1 = Class.new { def to_i; 7.12; end; }.new
      as_integer_2 = Class.new { def to_i; '555'; end; }.new
      as_integer_3 = Class.new { def to_i; 25; end; }.new

      non_integer_1 = Class.new { def to_i; 'test'; end; }.new
      non_integer_2 = Class.new { def to_i; Object.new; end }.new

      expect(type.cast(as_integer_1)).to eq(7)
      expect(type.cast(as_integer_2)).to eq(555)
      expect(type.cast(as_integer_3)).to eq(25)

      expect { type.cast(non_integer_1) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(non_integer_2) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    include_examples 'type casting'

    let(:type) { SmartCore::Types::Value::Integer }

    specify 'type-checking' do
      expect(type.valid?(7)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(-Float::INFINITY)).to eq(false)
      expect(type.valid?(Float::INFINITY)).to eq(false)
      expect(type.valid?(2.7)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('55')).to eq(false)
      expect(type.valid?('55test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(7) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(2.7) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('55') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('55test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(-Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    include_examples 'type casting'

    let(:type) { SmartCore::Types::Value::Integer.nilable }

    specify 'type-checking' do
      expect(type.valid?(7)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(-Float::INFINITY)).to eq(false)
      expect(type.valid?(Float::INFINITY)).to eq(false)
      expect(type.valid?(2.7)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('55')).to eq(false)
      expect(type.valid?('55test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(7) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(2.7) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('55') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('55test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(-Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Float::INFINITY) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
