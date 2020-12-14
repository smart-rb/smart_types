# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Boolean' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('test')).to eq(true)
      expect(type.cast(:test)).to eq(true)
      expect(type.cast([])).to eq(true)
      expect(type.cast({})).to eq(true)
      expect(type.cast(123.456)).to eq(true)

      expect(type.cast(nil)).to eq(false)
      expect(type.cast(false)).to eq(false)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(true)).to eq(true)
      expect(type.valid?(false)).to eq(true)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(:true)).to eq(false)
      expect(type.valid?(:false)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(true) }.not_to raise_error
      expect { type.validate!(false) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:false) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(true)).to eq(true)
      expect(type.valid?(false)).to eq(true)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(:true)).to eq(false)
      expect(type.valid?(:false)).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(true) }.not_to raise_error
      expect { type.validate!(false) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:false) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Boolean }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Boolean() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Boolean.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Boolean().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Boolean(true) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
