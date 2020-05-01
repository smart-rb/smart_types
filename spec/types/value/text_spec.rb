# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Text' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast('test')).to eq('test')
      expect(type.cast(:test)).to eq('test')
      expect(type.cast([])).to eq('[]')
      expect(type.cast({})).to eq('{}')
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Text }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?('test')).to eq(true)
      expect(type.valid?(:test)).to eq(true)

      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(nil)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!('test') }.not_to raise_error
      expect { type.validate!(:test) }.not_to raise_error

      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Text.nilable }

    include_examples 'type casting'

    specify 'type-checking' do
      expect(type.valid?('test')).to eq(true)
      expect(type.valid?(:test)).to eq(true)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(nil)).to eq(true)
    end

    specify 'type-validation' do
      expect { type.validate!('test') }.not_to raise_error
      expect { type.validate!(:test) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
