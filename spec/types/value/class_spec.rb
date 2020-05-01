  # frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Class' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(Class) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Class }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(Class)).to eq(true)
      expect(type.valid?(Class.new)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Class) }.not_to raise_error
      expect { type.validate!(Class.new) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Class.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?(Class)).to eq(true)
      expect(type.valid?(Class.new)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Class) }.not_to raise_error
      expect { type.validate!(Class.new) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
