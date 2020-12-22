# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Class' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
      expect { type.cast(Class) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
      expect { type.cast(Module) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Class)).to eq(true)
      expect(type.valid?(Class.new)).to eq(true)
      expect(type.valid?(Module)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Module.new)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Class) }.not_to raise_error
      expect { type.validate!(Class.new) }.not_to raise_error
      expect { type.validate!(Module) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Module.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Class)).to eq(true)
      expect(type.valid?(Class.new)).to eq(true)
      expect(type.valid?(Module)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Module.new)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Class) }.not_to raise_error
      expect { type.validate!(Class.new) }.not_to raise_error
      expect { type.validate!(Module) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Module.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Class }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Class() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Class.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Class().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Class(::Class) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
