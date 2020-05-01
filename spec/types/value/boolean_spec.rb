# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Boolean' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      # NOTE: true
      expect(type.cast('test')).to eq(true)
      expect(type.cast(:test)).to eq(true)
      expect(type.cast([])).to eq(true)
      expect(type.cast({})).to eq(true)
      expect(type.cast(123.456)).to eq(true)

      # NOTE: false
      expect(type.cast(nil)).to eq(false)
      expect(type.cast(false)).to eq(false)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Boolean }

    include_examples 'type casting'

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

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Boolean.nilable }

    include_examples 'type casting'

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
end
