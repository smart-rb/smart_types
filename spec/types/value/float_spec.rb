# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Float' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('123.456')).to eq(123.456).and be_a(::Float)
      expect(type.cast('0')).to eq(0.0).and be_a(::Float)
      expect(type.cast(nil)).to eq(0.0).and be_a(::Float)
      expect(type.cast(123.456)).to eq(123.456).and be_a(::Float)
      expect(type.cast(-Float::INFINITY)).to eq(-Float::INFINITY).and be_a(::Float)
      expect(type.cast(Float::INFINITY)).to eq(Float::INFINITY).and be_a(::Float)
      expect(type.cast(Float::NAN).object_id).to eq(Float::NAN.object_id)

      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)

      floatable_1 = Class.new { def to_f; 107.52; end }.new
      floatable_2 = Class.new { def to_f; 53.0721; end }.new
      expect(type.cast(floatable_1)).to eq(107.52).and be_a(::Float)
      expect(type.cast(floatable_2)).to eq(53.0721).and be_a(::Float)

      non_floatable = Class.new { def to_f; :test; end }.new
      expect { type.cast(non_floatable) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(0.0)).to eq(true)
      expect(type.valid?(1234.567)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('123.456')).to eq(false)
      expect(type.valid?('0.0')).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(-123)).to eq(false)
      expect(type.valid?(0)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(0.0) }.not_to raise_error
      expect { type.validate!(1234.567) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('123.456') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('0.0') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(-123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(0) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(0.0)).to eq(true)
      expect(type.valid?(1234.567)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?('123.456')).to eq(false)
      expect(type.valid?('0.0')).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(-123)).to eq(false)
      expect(type.valid?(0)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(0.0) }.not_to raise_error
      expect { type.validate!(1234.567) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!('123.456') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('0.0') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(-123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(0) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Float }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Float() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Float.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Float().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Float(33.0) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
