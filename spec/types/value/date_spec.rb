# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Date' do
  shared_examples 'type casting' do
    specify 'type casting' do
      expect(type.cast('2020-05-01')).to eq(Date.new(2020, 5, 1)).and be_a(::Date)
      expect(type.cast('20210417')).to eq(Date.new(2021, 4, 17)).and be_a(::Date)
      expect(type.cast('3rd Feb 2019')).to eq(Date.new(2019, 2, 3)).and be_a(::Date)
      expect(type.cast(Date.new(2021, 1, 7))).to eq(Date.new(2021, 1, 7)).and be_a(::Date)
      expect(type.cast(Date::Infinity)).to eq(Date::Infinity)
      expect(type.cast(DateTime::Infinity)).to eq(DateTime::Infinity)

      expect { type.cast('2001') }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Object.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(BasicObject.new) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast({}) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast([]) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Date.new)).to eq(true)
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Time.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Date.new) }.not_to raise_error
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Time.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Date.new)).to eq(true)
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Time.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Date.new) }.not_to raise_error
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Time.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Date }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Date() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Date.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Date().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Date(Date.new) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
