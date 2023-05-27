# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Range' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
      expect { type.cast(Class) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?((..10))).to eq(true)
      expect(type.valid?((10..))).to eq(true)
      expect(type.valid?((1..10))).to eq(true)
      expect(type.valid?((1...10))).to eq(true)
      expect(type.valid?(Range.new(1, 2, true))).to eq(true)
      expect(type.valid?(Range.new('a', 'c', false))).to eq(true)

      expect(type.valid?(-> {})).to eq(false)
      expect(type.valid?(proc {})).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(nil)).to eq(false)
    end

    specify 'type-valdation' do
      expect { type.validate!((..10)) }.not_to raise_error
      expect { type.validate!((10..)) }.not_to raise_error
      expect { type.validate!((1..10)) }.not_to raise_error
      expect { type.validate!((1...10)) }.not_to raise_error
      expect { type.validate!(Range.new(1, 2, true)) }.not_to raise_error
      expect { type.validate!(Range.new('a', 'c', false)) }.not_to raise_error

      expect { type.validate!(-> {}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(proc {}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?((..10))).to eq(true)
      expect(type.valid?((10..))).to eq(true)
      expect(type.valid?((1..10))).to eq(true)
      expect(type.valid?((1...10))).to eq(true)
      expect(type.valid?(Range.new(1, 2, true))).to eq(true)
      expect(type.valid?(Range.new('a', 'c', false))).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(-> {})).to eq(false)
      expect(type.valid?(proc {})).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-valdation' do
      expect { type.validate!((..10)) }.not_to raise_error
      expect { type.validate!((10..)) }.not_to raise_error
      expect { type.validate!((1..10)) }.not_to raise_error
      expect { type.validate!((1...10)) }.not_to raise_error
      expect { type.validate!(Range.new(1, 2, true)) }.not_to raise_error
      expect { type.validate!(Range.new('a', 'c', false)) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(-> {}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(proc {}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Range }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Range() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Range.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Range().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Range((1..100)) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
